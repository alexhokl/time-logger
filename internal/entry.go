package internal

import (
	"context"
	"errors"
	"log/slog"
	"strconv"
	"strings"
	"time"

	"gorm.io/gorm"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// maxBulkEntries caps a single CreateEntries request. The whole batch runs in
// one transaction, so an unbounded batch would hold a write lock on the SQLite
// file for an arbitrarily long time.
const maxBulkEntries = 500

// TimeEntryService implements the gRPC service of the same name.
type TimeEntryService struct {
	timeloggerv1.UnimplementedTimeEntryServiceServer
	base
}

func NewTimeEntryService(db *gorm.DB) *TimeEntryService {
	return &TimeEntryService{base: base{db: db}}
}

func (s *TimeEntryService) CreateEntry(
	ctx context.Context,
	req *timeloggerv1.CreateEntryRequest,
) (*timeloggerv1.CreateEntryResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	ctx, span := startSpan(ctx, "db.create_entry")
	defer span.End()

	now := s.clock()
	var created database.TimeEntry

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		entry, err := buildEntry(ctx, tx, user, req, now)
		if err != nil {
			return err
		}
		if err := insertEntry(ctx, tx, entry, req.GetTags(), user.UserID); err != nil {
			return err
		}
		created = *entry
		return nil
	})
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(mapRunningTimerConflict(err))
	}
	endSpanOk(span)

	loaded, err := loadEntry(ctx, s.db, user.UserID, created.ID)
	if err != nil {
		return nil, toStatusError(err)
	}

	recordTrackedSeconds(ctx, loaded.ElapsedSeconds(now))

	logMutation(ctx, timeloggerv1.TimeEntryService_CreateEntry_FullMethodName, user.UserID,
		slog.Uint64("entry_id", uint64(loaded.ID)))

	return &timeloggerv1.CreateEntryResponse{
		Entry: toProtoEntry(*loaded, now, user.Settings.RoundingMinutes),
	}, nil
}

// CreateEntries inserts a batch atomically. Partial success is deliberately not
// offered: a CSV import that half-applied would be far harder for the user to
// reconcile than one that failed cleanly.
func (s *TimeEntryService) CreateEntries(
	ctx context.Context,
	req *timeloggerv1.CreateEntriesRequest,
) (*timeloggerv1.CreateEntriesResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	if len(req.GetEntries()) == 0 {
		return nil, toStatusError(invalid("at least one entry is required"))
	}
	if len(req.GetEntries()) > maxBulkEntries {
		return nil, toStatusError(invalid("a batch cannot contain more than 500 entries"))
	}

	ctx, span := startSpan(ctx, "db.create_entries")
	defer span.End()

	now := s.clock()
	ids := make([]uint, 0, len(req.GetEntries()))

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		for i, entryReq := range req.GetEntries() {
			entry, err := buildEntry(ctx, tx, user, entryReq, now)
			if err != nil {
				return errors.Join(invalid(positionPrefix(i)), err)
			}
			if err := insertEntry(ctx, tx, entry, entryReq.GetTags(), user.UserID); err != nil {
				return err
			}
			ids = append(ids, entry.ID)
		}
		return nil
	})
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(mapRunningTimerConflict(err))
	}
	endSpanOk(span)

	recordBulkBatchSize(ctx, "CreateEntries", "create", len(ids))

	entries, err := loadEntries(ctx, s.db, user.UserID, ids)
	if err != nil {
		return nil, toStatusError(err)
	}

	out := make([]*timeloggerv1.TimeEntry, 0, len(entries))
	for _, e := range entries {
		out = append(out, toProtoEntry(e, now, user.Settings.RoundingMinutes))
	}

	logMutation(ctx, timeloggerv1.TimeEntryService_CreateEntries_FullMethodName, user.UserID,
		slog.Int("count", len(out)))

	return &timeloggerv1.CreateEntriesResponse{Entries: out}, nil
}

func (s *TimeEntryService) ListEntries(
	ctx context.Context,
	req *timeloggerv1.ListEntriesRequest,
) (*timeloggerv1.ListEntriesResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	ctx, span := startSpan(ctx, "db.list_entries")
	defer span.End()

	query := applyEntryFilter(
		s.db.WithContext(ctx).Model(&database.TimeEntry{}),
		user.UserID,
		req.GetFilter(),
	)

	var total int64
	if err := query.Count(&total).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}

	// The total is reported over the whole filter rather than the page so the
	// client can show "12h this week" without fetching every row.
	var totalSeconds int64
	if err := query.Session(&gorm.Session{}).
		Select("COALESCE(SUM(duration_seconds), 0)").
		Scan(&totalSeconds).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}

	limit, offset := normalisePage(req.GetPage())

	order := "time_entries.start_time DESC"
	if req.GetOrder() == timeloggerv1.SortOrder_SORT_ORDER_ASC {
		order = "time_entries.start_time ASC"
	}

	var entries []database.TimeEntry
	if err := query.
		Preload("Project").Preload("Task").Preload("Tags").
		Order(order).Order("time_entries.id DESC").
		Limit(limit).Offset(offset).
		Find(&entries).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	now := s.clock()
	out := make([]*timeloggerv1.TimeEntry, 0, len(entries))
	for _, e := range entries {
		out = append(out, toProtoEntry(e, now, user.Settings.RoundingMinutes))
	}

	recordRecordsReturned(ctx, "ListEntries", "entry", len(out))

	return &timeloggerv1.ListEntriesResponse{
		Entries:      out,
		Page:         pageResponse(total, offset, len(out)),
		TotalSeconds: roundUpSeconds(totalSeconds, user.Settings.RoundingMinutes),
	}, nil
}

func (s *TimeEntryService) GetEntry(
	ctx context.Context,
	req *timeloggerv1.GetEntryRequest,
) (*timeloggerv1.GetEntryResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	entry, err := loadEntry(ctx, s.db, user.UserID, uint(req.GetId()))
	if err != nil {
		return nil, toStatusError(err)
	}

	return &timeloggerv1.GetEntryResponse{
		Entry: toProtoEntry(*entry, s.clock(), user.Settings.RoundingMinutes),
	}, nil
}

func (s *TimeEntryService) UpdateEntry(
	ctx context.Context,
	req *timeloggerv1.UpdateEntryRequest,
) (*timeloggerv1.UpdateEntryResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	entry, err := loadEntry(ctx, s.db, user.UserID, uint(req.GetId()))
	if err != nil {
		return nil, toStatusError(err)
	}

	mask := newFieldMask(req.GetUpdateMask())
	now := s.clock()

	ctx, span := startSpan(ctx, "db.update_entry")
	defer span.End()

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		updates := map[string]any{}

		if mask.has("description") {
			updates["description"] = strings.TrimSpace(req.GetDescription())
		}

		projectID := entry.ProjectID
		if mask.has("project_id") {
			projectID = uintPtr(req.GetProjectId())
			if projectID != nil {
				if _, err := findProjectByID(ctx, tx, user.UserID, req.GetProjectId()); err != nil {
					return err
				}
			}
			updates["project_id"] = projectID
		}

		if mask.has("task_id") {
			taskID := uintPtr(req.GetTaskId())
			if taskID != nil {
				task, err := findTaskByID(ctx, tx, user.UserID, req.GetTaskId())
				if err != nil {
					return err
				}
				// Setting a task implies its project; this keeps the pair
				// consistent instead of rejecting the common case where the
				// caller only names the task.
				if projectID == nil || *projectID != task.ProjectID {
					projectID = &task.ProjectID
					updates["project_id"] = projectID
				}
			}
			updates["task_id"] = taskID
		}

		// Re-deriving the timing is only attempted when the caller actually
		// sent a TimeSpec, otherwise an update of just the description would
		// silently convert a closed entry into a running one.
		if req.GetTime() != nil && (mask.has("start_time") || mask.has("end_time") ||
			mask.has("duration_seconds") || !mask.explicit()) {
			resolved, err := resolveTimeSpec(req.GetTime(), user.Location, now)
			if err != nil {
				return err
			}
			updates["start_time"] = resolved.Start
			updates["end_time"] = resolved.End
			updates["duration_seconds"] = resolved.Duration
		}

		if len(updates) > 0 {
			if err := tx.Model(&database.TimeEntry{}).
				Where("id = ? AND user_id = ?", entry.ID, user.UserID).
				Updates(updates).Error; err != nil {
				return err
			}
		}

		if mask.has("tags") {
			return replaceEntryTags(ctx, tx, user.UserID, entry.ID, req.GetTags())
		}
		return nil
	})
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(mapRunningTimerConflict(err))
	}
	endSpanOk(span)

	reloaded, err := loadEntry(ctx, s.db, user.UserID, entry.ID)
	if err != nil {
		return nil, toStatusError(err)
	}

	logMutation(ctx, timeloggerv1.TimeEntryService_UpdateEntry_FullMethodName, user.UserID,
		slog.Uint64("entry_id", req.GetId()))

	return &timeloggerv1.UpdateEntryResponse{
		Entry: toProtoEntry(*reloaded, now, user.Settings.RoundingMinutes),
	}, nil
}

func (s *TimeEntryService) DeleteEntry(
	ctx context.Context,
	req *timeloggerv1.DeleteEntryRequest,
) (*timeloggerv1.DeleteEntryResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	entry, err := loadEntry(ctx, s.db, user.UserID, uint(req.GetId()))
	if err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.delete_entry")
	defer span.End()

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("time_entry_id = ?", entry.ID).
			Delete(&database.EntryTag{}).Error; err != nil {
			return err
		}
		return tx.Delete(&database.TimeEntry{}, entry.ID).Error
	})
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	logMutation(ctx, timeloggerv1.TimeEntryService_DeleteEntry_FullMethodName, user.UserID,
		slog.Uint64("entry_id", req.GetId()))

	return &timeloggerv1.DeleteEntryResponse{}, nil
}

// CopyEntries duplicates entries onto another date, preserving each source
// entry's time of day, duration, project, task and tags. It is the fast path
// for a user whose days look broadly the same.
//
// A running entry cannot be copied: it has no duration yet, and the copy would
// collide with the running-timer constraint.
func (s *TimeEntryService) CopyEntries(
	ctx context.Context,
	req *timeloggerv1.CopyEntriesRequest,
) (*timeloggerv1.CopyEntriesResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	if len(req.GetEntryIds()) == 0 {
		return nil, toStatusError(invalid("at least one entry id is required"))
	}
	if len(req.GetEntryIds()) > maxBulkEntries {
		return nil, toStatusError(invalid("cannot copy more than 500 entries at once"))
	}
	if err := validateDate(req.GetTargetDate(), "target_date"); err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.copy_entries")
	defer span.End()

	targetMidnight := startOfDay(req.GetTargetDate(), user.Location)
	now := s.clock()
	newIDs := make([]uint, 0, len(req.GetEntryIds()))

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		sources, err := loadEntries(ctx, tx, user.UserID, uintSlice(req.GetEntryIds()))
		if err != nil {
			return err
		}
		if len(sources) != len(req.GetEntryIds()) {
			return invalid("one or more entry ids do not exist")
		}

		for _, source := range sources {
			if source.IsRunning() {
				return invalid("a running entry cannot be copied; stop the timer first")
			}

			// Shift the source's wall-clock time of day onto the target date,
			// working in the user's timezone so that "the 9am entry" lands at
			// 9am locally even across a DST boundary.
			local := source.StartTime.In(user.Location)
			start := time.Date(
				targetMidnight.Year(), targetMidnight.Month(), targetMidnight.Day(),
				local.Hour(), local.Minute(), local.Second(), 0,
				user.Location,
			).UTC()

			duration := source.DurationSeconds
			end := start.Add(time.Duration(*duration) * time.Second)

			copied := database.TimeEntry{
				Description:     source.Description,
				ProjectID:       source.ProjectID,
				TaskID:          source.TaskID,
				StartTime:       start,
				EndTime:         &end,
				DurationSeconds: duration,
				UserID:          user.UserID,
			}
			if err := tx.Create(&copied).Error; err != nil {
				return err
			}
			if err := attachTags(ctx, tx, copied.ID, source.Tags); err != nil {
				return err
			}
			newIDs = append(newIDs, copied.ID)
		}
		return nil
	})
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	recordBulkBatchSize(ctx, "CopyEntries", "copy", len(newIDs))

	entries, err := loadEntries(ctx, s.db, user.UserID, newIDs)
	if err != nil {
		return nil, toStatusError(err)
	}

	out := make([]*timeloggerv1.TimeEntry, 0, len(entries))
	for _, e := range entries {
		out = append(out, toProtoEntry(e, now, user.Settings.RoundingMinutes))
	}

	logMutation(ctx, timeloggerv1.TimeEntryService_CopyEntries_FullMethodName, user.UserID,
		slog.Int("count", len(out)))

	return &timeloggerv1.CopyEntriesResponse{Entries: out}, nil
}

// --- Shared entry helpers --------------------------------------------------

// buildEntry validates a create request and turns it into an unsaved model.
// It is shared by CreateEntry and CreateEntries so the two cannot drift.
func buildEntry(
	ctx context.Context,
	tx *gorm.DB,
	user userContext,
	req *timeloggerv1.CreateEntryRequest,
	now time.Time,
) (*database.TimeEntry, error) {
	resolved, err := resolveTimeSpec(req.GetTime(), user.Location, now)
	if err != nil {
		return nil, err
	}

	projectID := uintPtr(req.GetProjectId())
	taskID := uintPtr(req.GetTaskId())

	if projectID != nil {
		if _, err := findProjectByID(ctx, tx, user.UserID, req.GetProjectId()); err != nil {
			return nil, err
		}
	}

	if taskID != nil {
		task, err := findTaskByID(ctx, tx, user.UserID, req.GetTaskId())
		if err != nil {
			return nil, err
		}
		switch {
		case projectID == nil:
			// Naming only a task is unambiguous: adopt its project.
			projectID = &task.ProjectID
		case *projectID != task.ProjectID:
			projectName := ""
			if task.Project != nil {
				projectName = task.Project.Name
			}
			return nil, ErrTaskProjectMismatch{
				TaskName:    task.Name,
				TaskProject: projectName,
			}
		}
	}

	return &database.TimeEntry{
		Description:     strings.TrimSpace(req.GetDescription()),
		ProjectID:       projectID,
		TaskID:          taskID,
		StartTime:       resolved.Start,
		EndTime:         resolved.End,
		DurationSeconds: resolved.Duration,
		UserID:          user.UserID,
	}, nil
}

// insertEntry persists an entry and its tags inside the caller's transaction.
func insertEntry(ctx context.Context, tx *gorm.DB, entry *database.TimeEntry, tags []string, userID uint) error {
	if err := tx.WithContext(ctx).Create(entry).Error; err != nil {
		return err
	}
	resolved, err := resolveTags(ctx, tx, userID, tags)
	if err != nil {
		return err
	}
	return attachTags(ctx, tx, entry.ID, resolved)
}

// attachTags writes the join rows for an entry.
func attachTags(ctx context.Context, tx *gorm.DB, entryID uint, tags []database.Tag) error {
	if len(tags) == 0 {
		return nil
	}
	rows := make([]database.EntryTag, 0, len(tags))
	for _, t := range tags {
		rows = append(rows, database.EntryTag{TimeEntryID: entryID, TagID: t.ID})
	}
	return tx.WithContext(ctx).Create(&rows).Error
}

// replaceEntryTags swaps an entry's tag set wholesale. Replacing rather than
// merging is what an update with an explicit tag list means.
func replaceEntryTags(ctx context.Context, tx *gorm.DB, userID, entryID uint, names []string) error {
	if err := tx.WithContext(ctx).Where("time_entry_id = ?", entryID).
		Delete(&database.EntryTag{}).Error; err != nil {
		return err
	}
	tags, err := resolveTags(ctx, tx, userID, names)
	if err != nil {
		return err
	}
	return attachTags(ctx, tx, entryID, tags)
}

// loadEntry fetches a single entry with its associations, scoped to the user.
func loadEntry(ctx context.Context, db *gorm.DB, userID, id uint) (*database.TimeEntry, error) {
	if id == 0 {
		return nil, gorm.ErrRecordNotFound
	}
	var entry database.TimeEntry
	if err := db.WithContext(ctx).
		Preload("Project").Preload("Task").Preload("Tags").
		Where("id = ? AND user_id = ?", id, userID).
		First(&entry).Error; err != nil {
		return nil, err
	}
	return &entry, nil
}

// loadEntries fetches many entries with associations, preserving no particular
// order. Callers that care about order sort the result themselves.
func loadEntries(ctx context.Context, db *gorm.DB, userID uint, ids []uint) ([]database.TimeEntry, error) {
	if len(ids) == 0 {
		return nil, nil
	}
	var entries []database.TimeEntry
	if err := db.WithContext(ctx).
		Preload("Project").Preload("Task").Preload("Tags").
		Where("user_id = ? AND id IN ?", userID, ids).
		Order("start_time ASC").
		Find(&entries).Error; err != nil {
		return nil, err
	}
	return entries, nil
}

// applyEntryFilter translates an EntryFilter into GORM query conditions.
//
// Tag filtering is conjunctive: an entry must carry every requested tag. That
// is implemented with a grouped subquery counting matches rather than a join,
// because a plain join would return an entry once per matching tag and inflate
// both the count and the duration sum.
func applyEntryFilter(query *gorm.DB, userID uint, filter *timeloggerv1.EntryFilter) *gorm.DB {
	query = query.Where("time_entries.user_id = ?", userID)
	if filter == nil {
		return query
	}

	if filter.From != nil {
		query = query.Where("time_entries.start_time >= ?", filter.GetFrom().AsTime().UTC())
	}
	if filter.To != nil {
		query = query.Where("time_entries.start_time < ?", filter.GetTo().AsTime().UTC())
	}
	if ids := uintSlice(filter.GetProjectIds()); len(ids) > 0 {
		query = query.Where("time_entries.project_id IN ?", ids)
	}
	if ids := uintSlice(filter.GetTaskIds()); len(ids) > 0 {
		query = query.Where("time_entries.task_id IN ?", ids)
	}
	if search := strings.TrimSpace(filter.GetSearch()); search != "" {
		query = query.Where("LOWER(time_entries.description) LIKE ?",
			"%"+strings.ToLower(search)+"%")
	}
	if filter.Running != nil {
		if filter.GetRunning() {
			query = query.Where("time_entries.end_time IS NULL")
		} else {
			query = query.Where("time_entries.end_time IS NOT NULL")
		}
	}

	names := make([]string, 0, len(filter.GetTags()))
	for _, raw := range filter.GetTags() {
		if name := normaliseTagName(raw); name != "" {
			names = append(names, name)
		}
	}
	if len(names) > 0 {
		subQuery := query.Session(&gorm.Session{NewDB: true}).
			Table("entry_tags").
			Select("entry_tags.time_entry_id").
			Joins("JOIN tags ON tags.id = entry_tags.tag_id").
			Where("tags.user_id = ? AND tags.name IN ? AND tags.deleted_at IS NULL", userID, names).
			Group("entry_tags.time_entry_id").
			Having("COUNT(DISTINCT tags.name) = ?", len(names))
		query = query.Where("time_entries.id IN (?)", subQuery)
	}

	return query
}

// mapRunningTimerConflict turns a violation of the one-running-timer index into
// the domain error, so the client sees FAILED_PRECONDITION with an explanation
// rather than an opaque INTERNAL.
func mapRunningTimerConflict(err error) error {
	if err == nil {
		return nil
	}
	if isUniqueViolation(err) && strings.Contains(err.Error(), "user_id") {
		return ErrTimerAlreadyRunning{}
	}
	return err
}

// positionPrefix labels which element of a bulk request failed, so a user
// importing a CSV knows which row to fix.
func positionPrefix(index int) string {
	return "entry at position " + strconv.Itoa(index) + ":"
}
