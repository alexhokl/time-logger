package internal

import (
	"context"

	"gorm.io/gorm"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// SettingsService implements the gRPC service of the same name.
type SettingsService struct {
	timeloggerv1.UnimplementedSettingsServiceServer
	base
}

func NewSettingsService(db *gorm.DB) *SettingsService {
	return &SettingsService{base: base{db: db}}
}

func (s *SettingsService) GetSettings(
	ctx context.Context,
	_ *timeloggerv1.GetSettingsRequest,
) (*timeloggerv1.GetSettingsResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	return &timeloggerv1.GetSettingsResponse{
		Settings: toProtoSettings(user.Settings, s.defaultProjectName(ctx, user)),
	}, nil
}

// UpdateSettings changes the user's preferences.
//
// The timezone is validated against the host's zoneinfo database before it is
// stored. Accepting an unresolvable name would shift every subsequent report by
// an unpredictable amount, and the user would have no obvious way to tell what
// went wrong.
func (s *SettingsService) UpdateSettings(
	ctx context.Context,
	req *timeloggerv1.UpdateSettingsRequest,
) (*timeloggerv1.UpdateSettingsResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	incoming := req.GetSettings()
	if incoming == nil {
		return nil, toStatusError(invalid("settings is required"))
	}

	mask := newFieldMask(req.GetUpdateMask())
	updates := map[string]any{}

	if mask.has("timezone") && incoming.GetTimezone() != "" {
		if _, err := loadLocation(incoming.GetTimezone()); err != nil {
			return nil, toStatusError(err)
		}
		updates["timezone"] = incoming.GetTimezone()
	}

	if mask.has("week_starts_on") && incoming.GetWeekStartsOn() != timeloggerv1.DayOfWeek_DAY_OF_WEEK_UNSPECIFIED {
		day := int(incoming.GetWeekStartsOn())
		if day < 1 || day > 7 {
			return nil, toStatusError(invalid("week_starts_on must be between Monday and Sunday"))
		}
		updates["week_starts_on"] = day
	}

	if mask.has("rounding_minutes") {
		rounding := int(incoming.GetRoundingMinutes())
		if rounding < 0 || rounding > 240 {
			return nil, toStatusError(invalid("rounding_minutes must be between 0 and 240"))
		}
		updates["rounding_minutes"] = rounding
	}

	if mask.has("default_project_id") {
		projectID := uintPtr(incoming.GetDefaultProjectId())
		if projectID != nil {
			if _, err := findProjectByID(ctx, s.db, user.UserID, incoming.GetDefaultProjectId()); err != nil {
				return nil, toStatusError(err)
			}
		}
		updates["default_project_id"] = projectID
	}

	if len(updates) > 0 {
		ctx, span := startSpan(ctx, "db.update_settings")
		if err := s.db.WithContext(ctx).Model(&database.UserSetting{}).
			Where("user_id = ?", user.UserID).
			Updates(updates).Error; err != nil {
			recordSpanError(span, err)
			span.End()
			return nil, toStatusError(err)
		}
		endSpanOk(span)
	}

	// Re-read rather than patching the in-memory copy, so the cache always
	// holds exactly what the database holds.
	resetSettingsCacheFor(user.UserID)
	refreshed, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	return &timeloggerv1.UpdateSettingsResponse{
		Settings: toProtoSettings(refreshed.Settings, s.defaultProjectName(ctx, refreshed)),
	}, nil
}

// defaultProjectName resolves the display name of the configured default
// project. A dangling reference yields an empty name rather than an error: the
// settings should still be readable so the user can correct them.
func (s *SettingsService) defaultProjectName(ctx context.Context, user userContext) string {
	if user.Settings.DefaultProjectID == nil {
		return ""
	}
	project, err := findProjectByID(ctx, s.db, user.UserID, uint64(*user.Settings.DefaultProjectID))
	if err != nil {
		// A dangling default must not block reading the settings, since
		// reading them is how the user would fix it.
		return ""
	}
	return project.Name
}
