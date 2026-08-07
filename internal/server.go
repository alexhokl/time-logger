package internal

import (
	"context"
	"errors"
	"log/slog"
	"strings"
	"sync"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"gorm.io/gorm"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// base carries the dependencies every service implementation needs. It is
// embedded rather than duplicated so that adding a dependency does not mean
// touching eight constructors.
type base struct {
	db *gorm.DB
	// now is injected so tests can pin the clock. Production code leaves it
	// nil and falls back to time.Now.
	now func() time.Time
}

func (b base) clock() time.Time {
	if b.now != nil {
		return b.now()
	}
	return time.Now()
}

// --- Pagination ------------------------------------------------------------

const (
	defaultPageSize = 100
	maxPageSize     = 1000
)

// normalisePage clamps a client-supplied page request into a range the server
// is willing to serve. A page size of zero means "use the default" rather than
// "return nothing", which is what a client that omits the field intends.
func normalisePage(p *timeloggerv1.PageRequest) (limit int, offset int) {
	limit = defaultPageSize
	if p != nil && p.GetPageSize() > 0 {
		limit = int(p.GetPageSize())
	}
	if limit > maxPageSize {
		limit = maxPageSize
	}
	if p != nil && p.GetOffset() > 0 {
		offset = int(p.GetOffset())
	}
	return limit, offset
}

// pageResponse builds the pagination metadata for a List response.
func pageResponse(total int64, offset, returned int) *timeloggerv1.PageResponse {
	return &timeloggerv1.PageResponse{
		TotalCount: total,
		HasMore:    int64(offset+returned) < total,
	}
}

// --- User settings ---------------------------------------------------------

// settingsCache memoises each user's settings so that the common path of a
// report or entry creation does not incur an extra query just to learn the
// timezone. The cache is process-local and write-through: every update goes to
// the database first and then refreshes the entry, so a stale read is only
// possible if a second process writes to the same database. That is acceptable
// because the deployment runs a single container against a local SQLite file.
var (
	settingsCacheMu sync.RWMutex
	settingsCache   = map[uint]database.UserSetting{}
)

// LoadUserSettings warms the settings cache at start-up so the first request of
// each user does not pay for the lookup. A failure is not fatal: the cache
// fills lazily on demand.
func LoadUserSettings(db *gorm.DB) error {
	var settings []database.UserSetting
	if err := db.Find(&settings).Error; err != nil {
		return err
	}

	settingsCacheMu.Lock()
	defer settingsCacheMu.Unlock()
	for _, s := range settings {
		settingsCache[s.UserID] = s
	}

	slog.Info("user settings cache warmed", slog.Int("users", len(settings)))
	return nil
}

// resetSettingsCache clears the memoised settings. It exists for tests, which
// share the package-level cache across cases.
func resetSettingsCache() {
	settingsCacheMu.Lock()
	defer settingsCacheMu.Unlock()
	settingsCache = map[uint]database.UserSetting{}
}

// resetSettingsCacheFor evicts one user's memoised settings, forcing the next
// read to reload from the database. Called when a change elsewhere (such as
// deleting the project a user had set as their default) may have invalidated
// the cached row.
func resetSettingsCacheFor(userID uint) {
	settingsCacheMu.Lock()
	defer settingsCacheMu.Unlock()
	delete(settingsCache, userID)
}

// userSettings returns the user's settings, creating a default row the first
// time a user is seen. Defaults are materialised rather than left implicit so
// that a client reading settings back always sees the values the server is
// actually using.
func (b base) userSettings(userID uint) (database.UserSetting, error) {
	settingsCacheMu.RLock()
	cached, ok := settingsCache[userID]
	settingsCacheMu.RUnlock()
	if ok {
		return cached, nil
	}

	settings := database.UserSetting{
		UserID:       userID,
		Timezone:     DefaultTimezone,
		WeekStartsOn: int(time.Monday),
	}
	if err := b.db.Where(database.UserSetting{UserID: userID}).
		Attrs(settings).
		FirstOrCreate(&settings).Error; err != nil {
		return database.UserSetting{}, err
	}

	cacheSettings(settings)
	return settings, nil
}

// cacheSettings stores a settings row in the memo. Called after every read that
// misses and after every successful update.
func cacheSettings(s database.UserSetting) {
	settingsCacheMu.Lock()
	defer settingsCacheMu.Unlock()
	settingsCache[s.UserID] = s
}

// userContext bundles the values almost every handler needs: the authenticated
// user, their settings, and their timezone resolved into a *time.Location.
type userContext struct {
	UserID   uint
	Settings database.UserSetting
	Location *time.Location
}

// resolveUser authenticates the request and loads everything the handler needs
// to interpret dates. Handlers call this as their first statement.
func (b base) resolveUser(ctx context.Context) (userContext, error) {
	userID, err := userIDFromContext(ctx)
	if err != nil {
		return userContext{}, err
	}

	settings, err := b.userSettings(userID)
	if err != nil {
		return userContext{}, toStatusError(err)
	}

	loc, err := loadLocation(settings.Timezone)
	if err != nil {
		// A settings row naming a timezone this host cannot resolve would make
		// every request fail. Fall back to UTC and complain loudly instead, so
		// the user can still reach SettingsService to fix it.
		slog.ErrorContext(ctx, "falling back to UTC for an unresolvable timezone",
			slog.Uint64("user_id", uint64(userID)),
			slog.String("timezone", settings.Timezone),
		)
		loc = time.UTC
	}

	return userContext{UserID: userID, Settings: settings, Location: loc}, nil
}

// --- Error mapping ---------------------------------------------------------

// toStatusError translates domain and GORM errors into gRPC status errors.
// Anything unrecognised becomes INTERNAL with a generic message so that raw
// database errors are never echoed back to a client; the original is logged by
// ErrorLoggingInterceptor.
func toStatusError(err error) error {
	if err == nil {
		return nil
	}

	// Already a status error: pass it through unchanged.
	if _, ok := status.FromError(err); ok && status.Code(err) != codes.Unknown {
		return err
	}

	switch {
	case errors.Is(err, gorm.ErrRecordNotFound):
		return status.Error(codes.NotFound, "not found")
	case errors.Is(err, gorm.ErrDuplicatedKey):
		return status.Error(codes.AlreadyExists, err.Error())
	}

	var (
		projectExists   ErrProjectAlreadyExists
		taskExists      ErrTaskAlreadyExists
		tagExists       ErrTagAlreadyExists
		projectInUse    ErrProjectHasEntries
		timerRunning    ErrTimerAlreadyRunning
		noTimer         ErrNoTimerRunning
		invalidTime     ErrInvalidTimeSpec
		taskMismatch    ErrTaskProjectMismatch
		unknownTimeZone ErrUnknownTimezone
		validation      ErrValidation
	)

	switch {
	case errors.As(err, &projectExists), errors.As(err, &taskExists), errors.As(err, &tagExists):
		return status.Error(codes.AlreadyExists, err.Error())
	case errors.As(err, &projectInUse), errors.As(err, &timerRunning), errors.As(err, &noTimer):
		return status.Error(codes.FailedPrecondition, err.Error())
	case errors.As(err, &invalidTime), errors.As(err, &taskMismatch),
		errors.As(err, &unknownTimeZone), errors.As(err, &validation):
		return status.Error(codes.InvalidArgument, err.Error())
	}

	return status.Error(codes.Internal, "internal server error")
}

// isUniqueViolation reports whether an error came from a unique index. GORM's
// SQLite driver does not always wrap these as gorm.ErrDuplicatedKey, so the
// driver message is inspected as a fallback. Used to turn a race on the
// running-timer index into a friendly FAILED_PRECONDITION.
func isUniqueViolation(err error) bool {
	if err == nil {
		return false
	}
	if errors.Is(err, gorm.ErrDuplicatedKey) {
		return true
	}
	return strings.Contains(strings.ToLower(err.Error()), "unique constraint failed")
}
