package internal

import (
	"context"
	"time"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// maxHeatmapDays bounds a heatmap request. The response carries one message per
// day including empty ones, so an unbounded range would be a cheap way to make
// the server allocate a very large response.
const maxHeatmapDays = 1500

// GetActivityHeatmap returns one bucket per day across a range, including days
// with no tracked time, so a client can render a contribution-graph without
// having to fill gaps itself.
func (s *ReportService) GetActivityHeatmap(
	ctx context.Context,
	req *timeloggerv1.GetActivityHeatmapRequest,
) (*timeloggerv1.GetActivityHeatmapResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	if err := validateDate(req.GetFrom(), "from"); err != nil {
		return nil, toStatusError(err)
	}
	if err := validateDate(req.GetTo(), "to"); err != nil {
		return nil, toStatusError(err)
	}

	from := startOfDay(req.GetFrom(), user.Location)
	to := startOfDay(req.GetTo(), user.Location)
	if to.Before(from) {
		return nil, toStatusError(invalid("to is before from"))
	}
	if int(to.Sub(from).Hours()/24)+1 > maxHeatmapDays {
		return nil, toStatusError(invalid("a heatmap cannot span more than 1500 days"))
	}

	started := time.Now()
	ctx, span := startSpan(ctx, "db.report_heatmap")
	defer span.End()

	totals, err := s.dailyTotals(ctx, user, from, to, uintSlice(req.GetProjectIds()))
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	var maxSeconds, totalSeconds int64
	for _, t := range totals {
		if t.seconds > maxSeconds {
			maxSeconds = t.seconds
		}
		totalSeconds += t.seconds
	}

	days := make([]*timeloggerv1.HeatmapDay, 0, int(to.Sub(from).Hours()/24)+1)
	for day := from; !day.After(to); day = day.AddDate(0, 0, 1) {
		key := day.Format(dayKeyLayout)
		bucket := totals[key]
		days = append(days, &timeloggerv1.HeatmapDay{
			Date:         dateFromTime(day),
			TotalSeconds: bucket.seconds,
			EntryCount:   bucket.count,
			Level:        heatmapLevel(bucket.seconds, maxSeconds),
		})
	}

	recordReportComputeDuration(ctx, "heatmap", float64(time.Since(started).Milliseconds()))
	recordReportRowsReturned(ctx, "heatmap", len(days))

	return &timeloggerv1.GetActivityHeatmapResponse{
		Days:         days,
		MaxSeconds:   maxSeconds,
		TotalSeconds: totalSeconds,
		Timezone:     user.Settings.Timezone,
	}, nil
}

// GetStreaks reports runs of consecutive days on which the user tracked time.
func (s *ReportService) GetStreaks(
	ctx context.Context,
	req *timeloggerv1.GetStreaksRequest,
) (*timeloggerv1.GetStreaksResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	today := truncateToDay(s.clock().In(user.Location), user.Location)

	to := today
	if req.To != nil {
		if err := validateDate(req.GetTo(), "to"); err != nil {
			return nil, toStatusError(err)
		}
		to = startOfDay(req.GetTo(), user.Location)
	}

	// A year of history is a sensible default: long enough to be interesting,
	// short enough to stay cheap.
	from := to.AddDate(0, 0, -364)
	if req.From != nil {
		if err := validateDate(req.GetFrom(), "from"); err != nil {
			return nil, toStatusError(err)
		}
		from = startOfDay(req.GetFrom(), user.Location)
	}
	if to.Before(from) {
		return nil, toStatusError(invalid("to is before from"))
	}
	if int(to.Sub(from).Hours()/24)+1 > maxHeatmapDays {
		return nil, toStatusError(invalid("a streak query cannot span more than 1500 days"))
	}

	started := time.Now()
	ctx, span := startSpan(ctx, "db.report_streaks")
	defer span.End()

	totals, err := s.dailyTotals(ctx, user, from, to, nil)
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	streaks, activeDays := buildStreaks(from, to, totals, req.GetMinimumSeconds())

	response := &timeloggerv1.GetStreaksResponse{
		Streaks:    streaks,
		ActiveDays: int32(activeDays),
		Timezone:   user.Settings.Timezone,
	}

	// The current streak is the one ending today or yesterday. Yesterday still
	// counts because a user who has not yet worked today has not broken it.
	yesterday := today.AddDate(0, 0, -1)
	for _, streak := range streaks {
		end := startOfDay(streak.GetEndDate(), user.Location)
		if end.Equal(today) || end.Equal(yesterday) {
			response.Current = streak
			break
		}
	}

	for _, streak := range streaks {
		if response.Longest == nil || streak.GetDays() > response.Longest.GetDays() {
			response.Longest = streak
		}
	}

	recordReportComputeDuration(ctx, "streaks", float64(time.Since(started).Milliseconds()))
	recordReportRowsReturned(ctx, "streaks", len(streaks))

	return response, nil
}

// dayKeyLayout is the canonical key format for a local calendar day.
const dayKeyLayout = "2006-01-02"

type dayTotal struct {
	seconds int64
	count   int64
}

// dailyTotals buckets completed entries by local calendar day.
//
// The bucketing is done in Go rather than with a SQL date function because the
// day an entry belongs to depends on the user's timezone, and SQLite's date
// functions only offer UTC and the server's local zone.
func (s *ReportService) dailyTotals(
	ctx context.Context,
	user userContext,
	from, to time.Time,
	projectIDs []uint,
) (map[string]dayTotal, error) {
	query := s.db.WithContext(ctx).Model(&database.TimeEntry{}).
		Select("start_time, duration_seconds").
		Where("user_id = ?", user.UserID).
		Where("end_time IS NOT NULL").
		Where("start_time >= ? AND start_time < ?", from.UTC(), to.AddDate(0, 0, 1).UTC())

	if len(projectIDs) > 0 {
		query = query.Where("project_id IN ?", projectIDs)
	}

	var rows []struct {
		StartTime       time.Time
		DurationSeconds int64
	}
	if err := query.Scan(&rows).Error; err != nil {
		return nil, err
	}

	totals := map[string]dayTotal{}
	for _, r := range rows {
		key := r.StartTime.In(user.Location).Format(dayKeyLayout)
		bucket := totals[key]
		bucket.seconds += roundUpSeconds(r.DurationSeconds, user.Settings.RoundingMinutes)
		bucket.count++
		totals[key] = bucket
	}
	return totals, nil
}

// heatmapLevel buckets a day's total into one of five intensities relative to
// the busiest day in the range. Scaling against the range's own maximum, rather
// than an absolute threshold, keeps the visualisation meaningful for both a
// full-time user and someone logging an hour a week.
func heatmapLevel(seconds, maxSeconds int64) int32 {
	if seconds <= 0 || maxSeconds <= 0 {
		return 0
	}
	switch ratio := float64(seconds) / float64(maxSeconds); {
	case ratio <= 0.25:
		return 1
	case ratio <= 0.50:
		return 2
	case ratio <= 0.75:
		return 3
	default:
		return 4
	}
}

// buildStreaks walks the range day by day and collects maximal runs of days
// meeting the minimum. Returned newest first, matching how a client lists them.
func buildStreaks(
	from, to time.Time,
	totals map[string]dayTotal,
	minimumSeconds int64,
) ([]*timeloggerv1.Streak, int) {
	var (
		streaks    []*timeloggerv1.Streak
		activeDays int
		runStart   *time.Time
		runSeconds int64
		runDays    int32
		previous   time.Time
	)

	flush := func() {
		if runStart == nil {
			return
		}
		streaks = append(streaks, &timeloggerv1.Streak{
			StartDate:    dateFromTime(*runStart),
			EndDate:      dateFromTime(previous),
			Days:         runDays,
			TotalSeconds: runSeconds,
		})
		runStart, runSeconds, runDays = nil, 0, 0
	}

	for day := from; !day.After(to); day = day.AddDate(0, 0, 1) {
		bucket := totals[day.Format(dayKeyLayout)]

		qualifies := bucket.seconds > 0 && bucket.seconds >= minimumSeconds
		if bucket.seconds > 0 {
			activeDays++
		}

		if !qualifies {
			flush()
			continue
		}

		if runStart == nil {
			start := day
			runStart = &start
		}
		runSeconds += bucket.seconds
		runDays++
		previous = day
	}
	flush()

	// Newest first.
	for i, j := 0, len(streaks)-1; i < j; i, j = i+1, j-1 {
		streaks[i], streaks[j] = streaks[j], streaks[i]
	}

	return streaks, activeDays
}
