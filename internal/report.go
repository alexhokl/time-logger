package internal

import (
	"context"
	"fmt"
	"sort"
	"time"

	"gorm.io/gorm"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// ReportService implements the gRPC service of the same name.
//
// Every report resolves day boundaries in the user's timezone rather than UTC,
// so "today" means the user's local day. Entries are stored in UTC, so each
// report converts its local window into a UTC half-open interval before
// querying, and converts back when labelling buckets.
type ReportService struct {
	timeloggerv1.UnimplementedReportServiceServer
	base
}

func NewReportService(db *gorm.DB) *ReportService {
	return &ReportService{base: base{db: db}}
}

func (s *ReportService) GetDailyReport(
	ctx context.Context,
	req *timeloggerv1.GetDailyReportRequest,
) (*timeloggerv1.GetDailyReportResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	day, err := s.anchorDate(req.Date, user)
	if err != nil {
		return nil, toStatusError(err)
	}

	report, err := s.periodReport(ctx, user, day, day, req.GetOptions(), "daily")
	if err != nil {
		return nil, toStatusError(err)
	}
	return &timeloggerv1.GetDailyReportResponse{Report: report}, nil
}

func (s *ReportService) GetWeeklyReport(
	ctx context.Context,
	req *timeloggerv1.GetWeeklyReportRequest,
) (*timeloggerv1.GetWeeklyReportResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	anchor, err := s.anchorDate(req.Date, user)
	if err != nil {
		return nil, toStatusError(err)
	}

	start := startOfWeek(anchor, user.Settings.WeekStartsOn)
	report, err := s.periodReport(ctx, user, start, start.AddDate(0, 0, 6), req.GetOptions(), "weekly")
	if err != nil {
		return nil, toStatusError(err)
	}
	return &timeloggerv1.GetWeeklyReportResponse{Report: report}, nil
}

func (s *ReportService) GetMonthlyReport(
	ctx context.Context,
	req *timeloggerv1.GetMonthlyReportRequest,
) (*timeloggerv1.GetMonthlyReportResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	anchor, err := s.anchorDate(req.Date, user)
	if err != nil {
		return nil, toStatusError(err)
	}

	report, err := s.periodReport(ctx, user, startOfMonth(anchor), endOfMonth(anchor), req.GetOptions(), "monthly")
	if err != nil {
		return nil, toStatusError(err)
	}
	return &timeloggerv1.GetMonthlyReportResponse{Report: report}, nil
}

func (s *ReportService) GetRangeReport(
	ctx context.Context,
	req *timeloggerv1.GetRangeReportRequest,
) (*timeloggerv1.GetRangeReportResponse, error) {
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

	report, err := s.periodReport(ctx, user, from, to, req.GetOptions(), "range")
	if err != nil {
		return nil, toStatusError(err)
	}
	return &timeloggerv1.GetRangeReportResponse{Report: report}, nil
}

// periodReport aggregates entries between two local midnights (inclusive of
// both days) and groups them by the requested dimension.
func (s *ReportService) periodReport(
	ctx context.Context,
	user userContext,
	fromDay, toDay time.Time,
	options *timeloggerv1.ReportOptions,
	kind string,
) (*timeloggerv1.PeriodReport, error) {
	started := time.Now()

	ctx, span := startSpan(ctx, "db.report_"+kind)
	defer span.End()

	// Half-open interval: [midnight on fromDay, midnight after toDay).
	windowStart := fromDay.UTC()
	windowEnd := toDay.AddDate(0, 0, 1).UTC()

	entries, err := s.entriesInWindow(ctx, user.UserID, windowStart, windowEnd, options)
	if err != nil {
		recordSpanError(span, err)
		return nil, err
	}
	endSpanOk(span)

	groupBy := options.GetGroupBy()
	if groupBy == timeloggerv1.GroupBy_GROUP_BY_UNSPECIFIED {
		groupBy = timeloggerv1.GroupBy_GROUP_BY_PROJECT
	}

	rows, totalSeconds := groupEntries(entries, groupBy, user, s.clock())

	// Percentages are computed after grouping so that they always sum to 100
	// across the returned rows, even when rounding is enabled.
	for _, row := range rows {
		if totalSeconds > 0 {
			row.Percentage = float64(row.TotalSeconds) / float64(totalSeconds) * 100
		}
	}

	recordReportComputeDuration(ctx, kind, float64(time.Since(started).Milliseconds()))
	recordReportRowsReturned(ctx, kind, len(rows))

	return &timeloggerv1.PeriodReport{
		From:         dateFromTime(fromDay),
		To:           dateFromTime(toDay),
		Rows:         rows,
		TotalSeconds: totalSeconds,
		EntryCount:   int64(len(entries)),
		Timezone:     user.Settings.Timezone,
	}, nil
}

// entriesInWindow loads the entries a report should consider.
//
// Running entries are excluded: their final duration is unknown, and including
// a partial value would make consecutive calls to the same report return
// different totals.
func (s *ReportService) entriesInWindow(
	ctx context.Context,
	userID uint,
	from, to time.Time,
	options *timeloggerv1.ReportOptions,
) ([]database.TimeEntry, error) {
	filter := &timeloggerv1.EntryFilter{
		ProjectIds: options.GetProjectIds(),
		TaskIds:    options.GetTaskIds(),
		Tags:       options.GetTags(),
		Running:    boolPtr(false),
	}

	query := applyEntryFilter(
		s.db.WithContext(ctx).Model(&database.TimeEntry{}),
		userID,
		filter,
	)

	var entries []database.TimeEntry
	if err := query.
		Preload("Project").Preload("Task").Preload("Tags").
		Where("time_entries.start_time >= ? AND time_entries.start_time < ?", from, to).
		Order("time_entries.start_time ASC").
		Find(&entries).Error; err != nil {
		return nil, err
	}
	return entries, nil
}

// groupEntries buckets entries by the requested dimension and returns the rows
// sorted by descending total time, which is the order a reader cares about.
//
// Grouping is done in Go rather than SQL because the tag dimension fans an
// entry out across several buckets and the day dimension needs timezone-aware
// bucketing that SQLite cannot express portably.
func groupEntries(
	entries []database.TimeEntry,
	groupBy timeloggerv1.GroupBy,
	user userContext,
	now time.Time,
) ([]*timeloggerv1.ReportRow, int64) {
	type bucket struct {
		id      uint64
		label   string
		seconds int64
		count   int64
	}

	buckets := map[string]*bucket{}
	var total int64

	add := func(key string, id uint64, label string, seconds int64) {
		b, ok := buckets[key]
		if !ok {
			b = &bucket{id: id, label: label}
			buckets[key] = b
		}
		b.seconds += seconds
		b.count++
	}

	for _, e := range entries {
		seconds := roundUpSeconds(e.ElapsedSeconds(now), user.Settings.RoundingMinutes)
		total += seconds

		switch groupBy {
		case timeloggerv1.GroupBy_GROUP_BY_PROJECT:
			id, label := uint64(0), "(no project)"
			if e.Project != nil {
				id, label = uint64(e.Project.ID), e.Project.Name
			}
			add(fmt.Sprintf("p:%d", id), id, label, seconds)

		case timeloggerv1.GroupBy_GROUP_BY_TASK:
			id, label := uint64(0), "(no task)"
			if e.Task != nil {
				id, label = uint64(e.Task.ID), e.Task.Name
			}
			add(fmt.Sprintf("t:%d", id), id, label, seconds)

		case timeloggerv1.GroupBy_GROUP_BY_TAG:
			if len(e.Tags) == 0 {
				add("g:0", 0, "(untagged)", seconds)
				break
			}
			// An entry with several tags contributes its full duration to each
			// of them. The rows therefore sum to more than the report total,
			// which is the only useful reading of "time spent on billable
			// work" when tags overlap.
			for _, tag := range e.Tags {
				add(fmt.Sprintf("g:%d", tag.ID), uint64(tag.ID), tag.Name, seconds)
			}

		case timeloggerv1.GroupBy_GROUP_BY_DAY:
			local := e.StartTime.In(user.Location)
			label := local.Format("2006-01-02")
			add("d:"+label, 0, label, seconds)

		default:
			add("all:0", 0, "total", seconds)
		}
	}

	rows := make([]*timeloggerv1.ReportRow, 0, len(buckets))
	for _, b := range buckets {
		rows = append(rows, &timeloggerv1.ReportRow{
			Id:           b.id,
			Label:        b.label,
			TotalSeconds: b.seconds,
			EntryCount:   b.count,
		})
	}

	// Day buckets read naturally in chronological order; every other dimension
	// is most useful ranked by time spent.
	if groupBy == timeloggerv1.GroupBy_GROUP_BY_DAY {
		sort.Slice(rows, func(i, j int) bool { return rows[i].Label < rows[j].Label })
	} else {
		sort.Slice(rows, func(i, j int) bool {
			if rows[i].TotalSeconds != rows[j].TotalSeconds {
				return rows[i].TotalSeconds > rows[j].TotalSeconds
			}
			return rows[i].Label < rows[j].Label
		})
	}

	return rows, total
}

// anchorDate resolves an optional Date into a local midnight, defaulting to
// today in the user's timezone.
func (s *ReportService) anchorDate(d *timeloggerv1.Date, user userContext) (time.Time, error) {
	if d == nil {
		now := s.clock().In(user.Location)
		return time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, user.Location), nil
	}
	if err := validateDate(d, "date"); err != nil {
		return time.Time{}, err
	}
	return startOfDay(d, user.Location), nil
}

func boolPtr(b bool) *bool { return &b }
