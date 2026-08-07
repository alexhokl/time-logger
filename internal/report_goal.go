package internal

import (
	"context"
	"time"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// GetGoalReport compares tracked time against each goal's target.
//
// Each goal is evaluated over the instance of its own period that contains the
// anchor date, so a weekly and a monthly goal in the same response are measured
// over different windows. A goal whose window does not cover the anchor date is
// skipped entirely rather than reported as 0%, which would suggest the user is
// behind on a goal that is not yet active.
func (s *ReportService) GetGoalReport(
	ctx context.Context,
	req *timeloggerv1.GetGoalReportRequest,
) (*timeloggerv1.GetGoalReportResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	anchor, err := s.anchorDate(req.Date, user)
	if err != nil {
		return nil, toStatusError(err)
	}

	started := time.Now()
	ctx, span := startSpan(ctx, "db.report_goals")
	defer span.End()

	query := s.db.WithContext(ctx).Preload("Project").Preload("Task").
		Where("user_id = ?", user.UserID)
	if req.GetProjectId() != 0 {
		query = query.Where("project_id = ?", req.GetProjectId())
	}

	var goals []database.Goal
	if err := query.Order("start_date DESC").Find(&goals).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	progress := make([]*timeloggerv1.GoalProgress, 0, len(goals))
	for _, goal := range goals {
		if !goalCoversDate(goal, anchor, user.Location) {
			continue
		}

		periodStart, periodEnd := periodBounds(anchor, goal.Period, user.Settings.WeekStartsOn)

		// Clamp the measurement window to the goal's own validity window, so a
		// goal starting mid-week is not judged against a full week of work.
		periodStart, periodEnd = clampToGoalWindow(goal, periodStart, periodEnd, user.Location)

		actual, err := s.trackedSecondsFor(ctx, user, goal, periodStart, periodEnd)
		if err != nil {
			return nil, toStatusError(err)
		}

		item := &timeloggerv1.GoalProgress{
			GoalId:           uint64(goal.ID),
			Period:           periodToProto(goal.Period),
			PeriodStart:      dateFromTime(periodStart),
			PeriodEnd:        dateFromTime(periodEnd),
			TargetSeconds:    goal.TargetSeconds,
			ActualSeconds:    actual,
			RemainingSeconds: goal.TargetSeconds - actual,
			Met:              actual >= goal.TargetSeconds,
		}
		if goal.TargetSeconds > 0 {
			item.Percentage = float64(actual) / float64(goal.TargetSeconds) * 100
		}
		if goal.ProjectID != nil {
			item.ProjectId = uint64(*goal.ProjectID)
		}
		if goal.Project != nil {
			item.ProjectName = goal.Project.Name
		}
		if goal.TaskID != nil {
			item.TaskId = uint64(*goal.TaskID)
		}
		if goal.Task != nil {
			item.TaskName = goal.Task.Name
		}

		progress = append(progress, item)
	}

	recordReportComputeDuration(ctx, "goals", float64(time.Since(started).Milliseconds()))
	recordReportRowsReturned(ctx, "goals", len(progress))

	return &timeloggerv1.GetGoalReportResponse{
		Progress: progress,
		Timezone: user.Settings.Timezone,
	}, nil
}

// trackedSecondsFor sums completed work matching a goal's scope over a window
// of local days, inclusive of both endpoints.
func (s *ReportService) trackedSecondsFor(
	ctx context.Context,
	user userContext,
	goal database.Goal,
	fromDay, toDay time.Time,
) (int64, error) {
	query := s.db.WithContext(ctx).Model(&database.TimeEntry{}).
		Where("user_id = ?", user.UserID).
		Where("end_time IS NOT NULL").
		Where("start_time >= ? AND start_time < ?", fromDay.UTC(), toDay.AddDate(0, 0, 1).UTC())

	if goal.TaskID != nil {
		query = query.Where("task_id = ?", *goal.TaskID)
	} else if goal.ProjectID != nil {
		query = query.Where("project_id = ?", *goal.ProjectID)
	}

	var seconds int64
	if err := query.Select("COALESCE(SUM(duration_seconds), 0)").Scan(&seconds).Error; err != nil {
		return 0, err
	}
	return roundUpSeconds(seconds, user.Settings.RoundingMinutes), nil
}

// goalCoversDate reports whether the goal is in force on the given local day.
func goalCoversDate(goal database.Goal, day time.Time, loc *time.Location) bool {
	start := goal.StartDate.In(loc)
	if day.Before(truncateToDay(start, loc)) {
		return false
	}
	if goal.EndDate == nil {
		return true
	}
	return !day.After(truncateToDay(goal.EndDate.In(loc), loc))
}

// clampToGoalWindow narrows a period to the part of it the goal actually
// covers.
func clampToGoalWindow(goal database.Goal, start, end time.Time, loc *time.Location) (time.Time, time.Time) {
	goalStart := truncateToDay(goal.StartDate.In(loc), loc)
	if start.Before(goalStart) {
		start = goalStart
	}
	if goal.EndDate != nil {
		goalEnd := truncateToDay(goal.EndDate.In(loc), loc)
		if end.After(goalEnd) {
			end = goalEnd
		}
	}
	return start, end
}

// truncateToDay drops the time of day, keeping the instant in loc.
func truncateToDay(t time.Time, loc *time.Location) time.Time {
	t = t.In(loc)
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, loc)
}
