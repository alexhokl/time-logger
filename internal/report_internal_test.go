package internal

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

func TestDailyReportUsesLocalDayBoundaries(t *testing.T) {
	f := newFixtures(t)
	f.mustSetTimezone(t, "Asia/Hong_Kong")
	projectID := f.mustProject(t, "acme")

	// 23:00 UTC on 2026-08-06 is 07:00 on 2026-08-07 in Hong Kong. A UTC-based
	// report would place this on the wrong day, which is the whole reason the
	// server resolves boundaries in the user's zone.
	f.mustEntry(t, projectID, time.Date(2026, 8, 6, 23, 0, 0, 0, time.UTC), time.Hour)

	// 15:00 UTC on 2026-08-07 is 23:00 the same day locally: still 2026-08-07.
	f.mustEntry(t, projectID, time.Date(2026, 8, 7, 15, 0, 0, 0, time.UTC), 30*time.Minute)

	// 16:30 UTC on 2026-08-07 is 00:30 on 2026-08-08 locally: a different day.
	f.mustEntry(t, projectID, time.Date(2026, 8, 7, 16, 30, 0, 0, time.UTC), time.Hour)

	resp, err := f.report.GetDailyReport(authContext(), &timeloggerv1.GetDailyReportRequest{
		Date: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
	})
	require.NoError(t, err)

	report := resp.GetReport()
	assert.Equal(t, int64(2), report.GetEntryCount())
	assert.Equal(t, int64(5400), report.GetTotalSeconds())
	assert.Equal(t, "Asia/Hong_Kong", report.GetTimezone())
}

func TestWeeklyReportHonoursTheConfiguredFirstDay(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	// Monday 2026-08-03 through Friday 2026-08-07.
	for day := 3; day <= 7; day++ {
		f.mustEntry(t, projectID, time.Date(2026, 8, day, 9, 0, 0, 0, time.UTC), time.Hour)
	}
	// The preceding Sunday.
	f.mustEntry(t, projectID, time.Date(2026, 8, 2, 9, 0, 0, 0, time.UTC), 2*time.Hour)

	t.Run("a week starting Monday excludes the preceding Sunday", func(t *testing.T) {
		resp, err := f.report.GetWeeklyReport(authContext(), &timeloggerv1.GetWeeklyReportRequest{
			Date: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
		})
		require.NoError(t, err)
		assert.Equal(t, int64(5*3600), resp.GetReport().GetTotalSeconds())
		assert.Equal(t, int32(3), resp.GetReport().GetFrom().GetDay())
		assert.Equal(t, int32(9), resp.GetReport().GetTo().GetDay())
	})

	t.Run("a week starting Sunday includes it", func(t *testing.T) {
		_, err := f.setting.UpdateSettings(authContext(), &timeloggerv1.UpdateSettingsRequest{
			UpdateMask: []string{"week_starts_on"},
			Settings:   &timeloggerv1.Settings{WeekStartsOn: timeloggerv1.DayOfWeek_DAY_OF_WEEK_SUNDAY},
		})
		require.NoError(t, err)

		resp, err := f.report.GetWeeklyReport(authContext(), &timeloggerv1.GetWeeklyReportRequest{
			Date: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
		})
		require.NoError(t, err)
		assert.Equal(t, int64(7*3600), resp.GetReport().GetTotalSeconds())
		assert.Equal(t, int32(2), resp.GetReport().GetFrom().GetDay())
	})
}

func TestReportGroupingDimensions(t *testing.T) {
	f := newFixtures(t)
	alpha := f.mustProject(t, "alpha")
	beta := f.mustProject(t, "beta")

	f.mustEntry(t, alpha, time.Date(2026, 8, 7, 1, 0, 0, 0, time.UTC), 3*time.Hour, "billable")
	f.mustEntry(t, beta, time.Date(2026, 8, 7, 5, 0, 0, 0, time.UTC), time.Hour, "billable", "urgent")

	t.Run("by project, ranked by time spent", func(t *testing.T) {
		resp, err := f.report.GetDailyReport(authContext(), &timeloggerv1.GetDailyReportRequest{
			Date:    &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
			Options: &timeloggerv1.ReportOptions{GroupBy: timeloggerv1.GroupBy_GROUP_BY_PROJECT},
		})
		require.NoError(t, err)

		rows := resp.GetReport().GetRows()
		require.Len(t, rows, 2)
		assert.Equal(t, "alpha", rows[0].GetLabel())
		assert.Equal(t, int64(10800), rows[0].GetTotalSeconds())
		assert.InDelta(t, 75.0, rows[0].GetPercentage(), 0.01)
		assert.Equal(t, "beta", rows[1].GetLabel())
		assert.InDelta(t, 25.0, rows[1].GetPercentage(), 0.01)
	})

	t.Run("by tag, where a multi-tagged entry counts towards each", func(t *testing.T) {
		resp, err := f.report.GetDailyReport(authContext(), &timeloggerv1.GetDailyReportRequest{
			Date:    &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
			Options: &timeloggerv1.ReportOptions{GroupBy: timeloggerv1.GroupBy_GROUP_BY_TAG},
		})
		require.NoError(t, err)

		byLabel := map[string]int64{}
		for _, row := range resp.GetReport().GetRows() {
			byLabel[row.GetLabel()] = row.GetTotalSeconds()
		}

		// "billable" covers both entries, "urgent" only the second. The rows
		// deliberately sum to more than the report total.
		assert.Equal(t, int64(14400), byLabel["billable"])
		assert.Equal(t, int64(3600), byLabel["urgent"])
		assert.Equal(t, int64(14400), resp.GetReport().GetTotalSeconds())
	})
}

func TestReportBucketsUnassignedWork(t *testing.T) {
	f := newFixtures(t)

	seconds := int64(3600)
	_, err := f.entry.CreateEntry(authContext(), &timeloggerv1.CreateEntryRequest{
		Description: "unassigned",
		Time: &timeloggerv1.TimeSpec{
			StartTime:       timestampOf(time.Date(2026, 8, 7, 1, 0, 0, 0, time.UTC)),
			DurationSeconds: &seconds,
		},
	})
	require.NoError(t, err)

	resp, err := f.report.GetDailyReport(authContext(), &timeloggerv1.GetDailyReportRequest{
		Date:    &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
		Options: &timeloggerv1.ReportOptions{GroupBy: timeloggerv1.GroupBy_GROUP_BY_PROJECT},
	})
	require.NoError(t, err)

	rows := resp.GetReport().GetRows()
	require.Len(t, rows, 1)
	assert.Equal(t, "(no project)", rows[0].GetLabel())
	assert.Zero(t, rows[0].GetId())
}

func TestRangeReportRejectsAnInvertedRange(t *testing.T) {
	f := newFixtures(t)

	_, err := f.report.GetRangeReport(authContext(), &timeloggerv1.GetRangeReportRequest{
		From: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 10},
		To:   &timeloggerv1.Date{Year: 2026, Month: 8, Day: 1},
	})
	require.Error(t, err)
}

func TestGoalReportComparesActualAgainstTarget(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	_, err := f.goal.CreateGoal(authContext(), &timeloggerv1.CreateGoalRequest{
		ProjectId:   projectID,
		TargetHours: 10,
		Period:      timeloggerv1.Period_PERIOD_WEEKLY,
		StartDate:   &timeloggerv1.Date{Year: 2026, Month: 1, Day: 1},
	})
	require.NoError(t, err)

	// Six hours across the week containing 2026-08-07.
	for day := 3; day <= 5; day++ {
		f.mustEntry(t, projectID, time.Date(2026, 8, day, 9, 0, 0, 0, time.UTC), 2*time.Hour)
	}

	resp, err := f.report.GetGoalReport(authContext(), &timeloggerv1.GetGoalReportRequest{})
	require.NoError(t, err)

	require.Len(t, resp.GetProgress(), 1)
	progress := resp.GetProgress()[0]
	assert.Equal(t, int64(36000), progress.GetTargetSeconds())
	assert.Equal(t, int64(21600), progress.GetActualSeconds())
	assert.Equal(t, int64(14400), progress.GetRemainingSeconds())
	assert.InDelta(t, 60.0, progress.GetPercentage(), 0.01)
	assert.False(t, progress.GetMet())
}

func TestGoalReportSkipsGoalsOutsideTheirWindow(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	// A goal that ended before the anchor date is not "0% complete"; it simply
	// does not apply, so reporting it would misleadingly suggest the user is
	// behind.
	_, err := f.goal.CreateGoal(authContext(), &timeloggerv1.CreateGoalRequest{
		ProjectId:   projectID,
		TargetHours: 5,
		Period:      timeloggerv1.Period_PERIOD_WEEKLY,
		StartDate:   &timeloggerv1.Date{Year: 2026, Month: 1, Day: 1},
		EndDate:     &timeloggerv1.Date{Year: 2026, Month: 3, Day: 1},
	})
	require.NoError(t, err)

	resp, err := f.report.GetGoalReport(authContext(), &timeloggerv1.GetGoalReportRequest{})
	require.NoError(t, err)
	assert.Empty(t, resp.GetProgress())
}

func TestGoalReportMarksAMetGoal(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	_, err := f.goal.CreateGoal(authContext(), &timeloggerv1.CreateGoalRequest{
		ProjectId:   projectID,
		TargetHours: 2,
		Period:      timeloggerv1.Period_PERIOD_DAILY,
		StartDate:   &timeloggerv1.Date{Year: 2026, Month: 1, Day: 1},
	})
	require.NoError(t, err)

	f.mustEntry(t, projectID, time.Date(2026, 8, 7, 1, 0, 0, 0, time.UTC), 3*time.Hour)

	resp, err := f.report.GetGoalReport(authContext(), &timeloggerv1.GetGoalReportRequest{})
	require.NoError(t, err)

	require.Len(t, resp.GetProgress(), 1)
	assert.True(t, resp.GetProgress()[0].GetMet())
	// Overshooting is reported as a negative remainder rather than clamped.
	assert.Equal(t, int64(-3600), resp.GetProgress()[0].GetRemainingSeconds())
}

func TestActivityHeatmapIncludesEmptyDays(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	f.mustEntry(t, projectID, time.Date(2026, 8, 3, 9, 0, 0, 0, time.UTC), 4*time.Hour)
	f.mustEntry(t, projectID, time.Date(2026, 8, 5, 9, 0, 0, 0, time.UTC), time.Hour)

	resp, err := f.report.GetActivityHeatmap(authContext(), &timeloggerv1.GetActivityHeatmapRequest{
		From: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 1},
		To:   &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
	})
	require.NoError(t, err)

	// A client rendering a grid should not have to fill the gaps itself.
	require.Len(t, resp.GetDays(), 7)
	assert.Equal(t, int64(14400), resp.GetMaxSeconds())
	assert.Equal(t, int64(18000), resp.GetTotalSeconds())

	byDay := map[int32]*timeloggerv1.HeatmapDay{}
	for _, d := range resp.GetDays() {
		byDay[d.GetDate().GetDay()] = d
	}

	// Levels scale against the busiest day in the range.
	assert.Equal(t, int32(4), byDay[3].GetLevel())
	assert.Equal(t, int32(1), byDay[5].GetLevel())
	assert.Equal(t, int32(0), byDay[1].GetLevel())
	assert.Zero(t, byDay[1].GetTotalSeconds())
}

func TestStreaksFindsConsecutiveDays(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	// 2026-08-03, 04, 05 then a gap, then 07 (today).
	for _, day := range []int{3, 4, 5, 7} {
		f.mustEntry(t, projectID, time.Date(2026, 8, day, 9, 0, 0, 0, time.UTC), time.Hour)
	}

	resp, err := f.report.GetStreaks(authContext(), &timeloggerv1.GetStreaksRequest{
		From: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 1},
		To:   &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
	})
	require.NoError(t, err)

	assert.Equal(t, int32(4), resp.GetActiveDays())
	require.Len(t, resp.GetStreaks(), 2)

	// Newest first.
	assert.Equal(t, int32(1), resp.GetStreaks()[0].GetDays())
	assert.Equal(t, int32(3), resp.GetStreaks()[1].GetDays())

	require.NotNil(t, resp.GetLongest())
	assert.Equal(t, int32(3), resp.GetLongest().GetDays())

	// The streak ending today is the current one.
	require.NotNil(t, resp.GetCurrent())
	assert.Equal(t, int32(7), resp.GetCurrent().GetEndDate().GetDay())
}

func TestStreaksHonourTheMinimumThreshold(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	f.mustEntry(t, projectID, time.Date(2026, 8, 3, 9, 0, 0, 0, time.UTC), 2*time.Hour)
	// A token 10 minutes on the middle day should not sustain the streak when
	// the user asks for at least an hour a day.
	f.mustEntry(t, projectID, time.Date(2026, 8, 4, 9, 0, 0, 0, time.UTC), 10*time.Minute)
	f.mustEntry(t, projectID, time.Date(2026, 8, 5, 9, 0, 0, 0, time.UTC), 2*time.Hour)

	resp, err := f.report.GetStreaks(authContext(), &timeloggerv1.GetStreaksRequest{
		From:           &timeloggerv1.Date{Year: 2026, Month: 8, Day: 1},
		To:             &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
		MinimumSeconds: 3600,
	})
	require.NoError(t, err)

	require.Len(t, resp.GetStreaks(), 2)
	assert.Equal(t, int32(1), resp.GetStreaks()[0].GetDays())
	assert.Equal(t, int32(1), resp.GetStreaks()[1].GetDays())
}

func TestRoundingAppliesToReportsButNotStorage(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	// 21 minutes of work.
	f.mustEntry(t, projectID, time.Date(2026, 8, 7, 1, 0, 0, 0, time.UTC), 21*time.Minute)

	_, err := f.setting.UpdateSettings(authContext(), &timeloggerv1.UpdateSettingsRequest{
		UpdateMask: []string{"rounding_minutes"},
		Settings:   &timeloggerv1.Settings{RoundingMinutes: 15},
	})
	require.NoError(t, err)

	resp, err := f.report.GetDailyReport(authContext(), &timeloggerv1.GetDailyReportRequest{
		Date: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
	})
	require.NoError(t, err)
	assert.Equal(t, int64(1800), resp.GetReport().GetTotalSeconds())

	// Turning rounding off must recover the exact figure, proving the stored
	// value was never altered.
	_, err = f.setting.UpdateSettings(authContext(), &timeloggerv1.UpdateSettingsRequest{
		UpdateMask: []string{"rounding_minutes"},
		Settings:   &timeloggerv1.Settings{RoundingMinutes: 0},
	})
	require.NoError(t, err)

	resp, err = f.report.GetDailyReport(authContext(), &timeloggerv1.GetDailyReportRequest{
		Date: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
	})
	require.NoError(t, err)
	assert.Equal(t, int64(1260), resp.GetReport().GetTotalSeconds())
}
