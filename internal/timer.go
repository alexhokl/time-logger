package internal

import (
	"context"
	"errors"
	"strings"
	"time"

	"gorm.io/gorm"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// TimerService implements the gRPC service of the same name.
//
// A running timer is an ordinary TimeEntry with a NULL end_time, so the
// stopwatch shares all of its storage, filtering and reporting behaviour with
// manually entered work. Only the lifecycle differs.
type TimerService struct {
	timeloggerv1.UnimplementedTimerServiceServer
	base
}

func NewTimerService(db *gorm.DB) *TimerService {
	return &TimerService{base: base{db: db}}
}

// StartTimer opens a new running entry.
//
// The user's existing timer is not stopped automatically: an accidental start
// would then silently truncate work in progress, and the mistake is invisible
// until the report looks wrong. Refusing with FAILED_PRECONDITION and naming
// the running entry makes the situation obvious and leaves the choice to the
// user.
//
// The handler checks for an existing timer, but the partial unique index on
// time_entries is what actually guarantees the invariant: two concurrent calls
// can both pass the check, and the loser's INSERT is rejected by the database
// and mapped back onto the same domain error.
func (s *TimerService) StartTimer(
	ctx context.Context,
	req *timeloggerv1.StartTimerRequest,
) (*timeloggerv1.StartTimerResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	now := s.clock()
	start := now.UTC()
	if req.StartTime != nil {
		start = req.GetStartTime().AsTime().UTC()
		if start.After(now.Add(time.Minute)) {
			// A small tolerance absorbs clock skew between client and server;
			// anything beyond it is a mistake worth reporting.
			return nil, toStatusError(invalid("start_time cannot be in the future"))
		}
	}

	ctx, span := startSpan(ctx, "db.start_timer")
	defer span.End()

	var started database.TimeEntry

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		running, err := findRunningEntry(ctx, tx, user.UserID)
		if err != nil {
			return err
		}
		if running != nil {
			return ErrTimerAlreadyRunning{
				EntryID:     running.ID,
				Description: running.Description,
			}
		}

		entry, err := buildEntry(ctx, tx, user, &timeloggerv1.CreateEntryRequest{
			Description: req.GetDescription(),
			ProjectId:   req.GetProjectId(),
			TaskId:      req.GetTaskId(),
			Tags:        req.GetTags(),
			// Supplying only a start time is what marks the entry as running.
			Time: &timeloggerv1.TimeSpec{StartTime: timestampOf(start)},
		}, now)
		if err != nil {
			return err
		}

		if err := insertEntry(ctx, tx, entry, req.GetTags(), user.UserID); err != nil {
			return err
		}
		started = *entry
		return nil
	})
	if err != nil {
		recordSpanError(span, err)
		recordTimerStart(ctx, "rejected")
		return nil, toStatusError(mapRunningTimerConflict(err))
	}
	endSpanOk(span)

	recordTimerStart(ctx, "success")

	loaded, err := loadEntry(ctx, s.db, user.UserID, started.ID)
	if err != nil {
		return nil, toStatusError(err)
	}

	return &timeloggerv1.StartTimerResponse{
		Entry: toProtoEntry(*loaded, now, user.Settings.RoundingMinutes),
	}, nil
}

// StopTimer closes the running entry and stores its final duration.
func (s *TimerService) StopTimer(
	ctx context.Context,
	req *timeloggerv1.StopTimerRequest,
) (*timeloggerv1.StopTimerResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	now := s.clock()

	ctx, span := startSpan(ctx, "db.stop_timer")
	defer span.End()

	var stoppedID uint

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		running, err := findRunningEntry(ctx, tx, user.UserID)
		if err != nil {
			return err
		}
		if running == nil {
			return ErrNoTimerRunning{}
		}

		end := now.UTC()
		if req.EndTime != nil {
			end = req.GetEndTime().AsTime().UTC()
		}
		if end.Before(running.StartTime) {
			return invalid("end_time is before the timer's start time")
		}

		duration := int64(end.Sub(running.StartTime).Seconds())
		if duration > maxEntrySeconds {
			return invalid("the timer has been running for more than 31 days; " +
				"stop it with an explicit end_time or cancel it")
		}

		updates := map[string]any{
			"end_time":         end,
			"duration_seconds": duration,
		}
		if req.Description != nil {
			updates["description"] = strings.TrimSpace(req.GetDescription())
		}

		if err := tx.Model(&database.TimeEntry{}).
			Where("id = ? AND user_id = ?", running.ID, user.UserID).
			Updates(updates).Error; err != nil {
			return err
		}

		stoppedID = running.ID
		return nil
	})
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	recordTimerStop(ctx, "stop")

	entry, err := loadEntry(ctx, s.db, user.UserID, stoppedID)
	if err != nil {
		return nil, toStatusError(err)
	}

	recordTrackedSeconds(ctx, entry.ElapsedSeconds(now))

	return &timeloggerv1.StopTimerResponse{
		Entry: toProtoEntry(*entry, now, user.Settings.RoundingMinutes),
	}, nil
}

// GetRunningTimer reports the open entry, if any.
//
// The absence of a timer is a normal state rather than an error, so this
// returns an empty response instead of NOT_FOUND. Clients poll it on a timer
// tick and would otherwise have to treat an error code as routine.
func (s *TimerService) GetRunningTimer(
	ctx context.Context,
	_ *timeloggerv1.GetRunningTimerRequest,
) (*timeloggerv1.GetRunningTimerResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	running, err := findRunningEntry(ctx, s.db, user.UserID)
	if err != nil {
		return nil, toStatusError(err)
	}
	if running == nil {
		return &timeloggerv1.GetRunningTimerResponse{}, nil
	}

	loaded, err := loadEntry(ctx, s.db, user.UserID, running.ID)
	if err != nil {
		return nil, toStatusError(err)
	}

	return &timeloggerv1.GetRunningTimerResponse{
		Entry: toProtoEntry(*loaded, s.clock(), user.Settings.RoundingMinutes),
	}, nil
}

// CancelRunningTimer discards the running entry without recording any time.
// The entry is soft-deleted, and because the running-timer index excludes
// soft-deleted rows the user can start a new timer immediately.
func (s *TimerService) CancelRunningTimer(
	ctx context.Context,
	_ *timeloggerv1.CancelRunningTimerRequest,
) (*timeloggerv1.CancelRunningTimerResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	ctx, span := startSpan(ctx, "db.cancel_timer")
	defer span.End()

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		running, err := findRunningEntry(ctx, tx, user.UserID)
		if err != nil {
			return err
		}
		if running == nil {
			return ErrNoTimerRunning{}
		}
		if err := tx.Where("time_entry_id = ?", running.ID).
			Delete(&database.EntryTag{}).Error; err != nil {
			return err
		}
		return tx.Delete(&database.TimeEntry{}, running.ID).Error
	})
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	recordTimerStop(ctx, "cancel")

	return &timeloggerv1.CancelRunningTimerResponse{}, nil
}

// findRunningEntry returns the user's open entry, or nil when none exists.
// A missing timer is signalled by a nil result rather than an error so callers
// can distinguish it from a genuine query failure.
func findRunningEntry(ctx context.Context, db *gorm.DB, userID uint) (*database.TimeEntry, error) {
	var entry database.TimeEntry
	err := db.WithContext(ctx).
		Where("user_id = ? AND end_time IS NULL", userID).
		First(&entry).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &entry, nil
}
