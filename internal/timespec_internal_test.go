package internal

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/types/known/timestamppb"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

func ptr[T any](v T) *T { return &v }

func TestResolveTimeSpec(t *testing.T) {
	hongKong, err := time.LoadLocation("Asia/Hong_Kong")
	require.NoError(t, err)

	now := time.Date(2026, 8, 7, 10, 0, 0, 0, time.UTC)
	start := time.Date(2026, 8, 7, 9, 0, 0, 0, time.UTC)
	end := time.Date(2026, 8, 7, 11, 30, 0, 0, time.UTC)

	testCases := []struct {
		name             string
		spec             *timeloggerv1.TimeSpec
		expectedStart    time.Time
		expectedEnd      *time.Time
		expectedDuration *int64
		expectedRunning  bool
		expectError      bool
	}{
		{
			name:            "nil spec starts a timer now",
			spec:            nil,
			expectedStart:   now,
			expectedRunning: true,
		},
		{
			name:            "empty spec starts a timer now",
			spec:            &timeloggerv1.TimeSpec{},
			expectedStart:   now,
			expectedRunning: true,
		},
		{
			name:            "start only leaves the entry running",
			spec:            &timeloggerv1.TimeSpec{StartTime: timestamppb.New(start)},
			expectedStart:   start,
			expectedRunning: true,
		},
		{
			name: "start and end derive the duration",
			spec: &timeloggerv1.TimeSpec{
				StartTime: timestamppb.New(start),
				EndTime:   timestamppb.New(end),
			},
			expectedStart:    start,
			expectedEnd:      &end,
			expectedDuration: ptr(int64(9000)),
		},
		{
			name: "start and duration derive the end",
			spec: &timeloggerv1.TimeSpec{
				StartTime:       timestamppb.New(start),
				DurationSeconds: ptr(int64(9000)),
			},
			expectedStart:    start,
			expectedEnd:      &end,
			expectedDuration: ptr(int64(9000)),
		},
		{
			name: "end and duration derive the start",
			spec: &timeloggerv1.TimeSpec{
				EndTime:         timestamppb.New(end),
				DurationSeconds: ptr(int64(9000)),
			},
			expectedStart:    start,
			expectedEnd:      &end,
			expectedDuration: ptr(int64(9000)),
		},
		{
			name: "all three agreeing is accepted",
			spec: &timeloggerv1.TimeSpec{
				StartTime:       timestamppb.New(start),
				EndTime:         timestamppb.New(end),
				DurationSeconds: ptr(int64(9000)),
			},
			expectedStart:    start,
			expectedEnd:      &end,
			expectedDuration: ptr(int64(9000)),
		},
		{
			name: "all three disagreeing is rejected",
			spec: &timeloggerv1.TimeSpec{
				StartTime:       timestamppb.New(start),
				EndTime:         timestamppb.New(end),
				DurationSeconds: ptr(int64(60)),
			},
			expectError: true,
		},
		{
			name: "duration alone means work finishing now",
			spec: &timeloggerv1.TimeSpec{DurationSeconds: ptr(int64(3600))},
			// 09:00 UTC, one hour before the injected now.
			expectedStart:    now.Add(-time.Hour),
			expectedEnd:      &now,
			expectedDuration: ptr(int64(3600)),
		},
		{
			name: "date and duration start at local midnight",
			spec: &timeloggerv1.TimeSpec{
				Date:            &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
				DurationSeconds: ptr(int64(3600)),
			},
			// Midnight in Hong Kong (UTC+8) is 16:00 UTC on the previous day.
			expectedStart:    time.Date(2026, 8, 6, 16, 0, 0, 0, time.UTC),
			expectedEnd:      ptr(time.Date(2026, 8, 6, 17, 0, 0, 0, time.UTC)),
			expectedDuration: ptr(int64(3600)),
		},
		{
			name: "date combined with start_time is rejected",
			spec: &timeloggerv1.TimeSpec{
				Date:            &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
				StartTime:       timestamppb.New(start),
				DurationSeconds: ptr(int64(60)),
			},
			expectError: true,
		},
		{
			name: "date without duration or end is rejected",
			spec: &timeloggerv1.TimeSpec{
				Date: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
			},
			expectError: true,
		},
		{
			name:        "end alone is rejected",
			spec:        &timeloggerv1.TimeSpec{EndTime: timestamppb.New(end)},
			expectError: true,
		},
		{
			name: "negative duration is rejected",
			spec: &timeloggerv1.TimeSpec{
				StartTime:       timestamppb.New(start),
				DurationSeconds: ptr(int64(-1)),
			},
			expectError: true,
		},
		{
			name: "end before start is rejected",
			spec: &timeloggerv1.TimeSpec{
				StartTime: timestamppb.New(end),
				EndTime:   timestamppb.New(start),
			},
			expectError: true,
		},
		{
			name: "an entry longer than 31 days is rejected",
			spec: &timeloggerv1.TimeSpec{
				StartTime:       timestamppb.New(start),
				DurationSeconds: ptr(maxEntrySeconds + 1),
			},
			expectError: true,
		},
		{
			name: "an entry of exactly 31 days is accepted",
			spec: &timeloggerv1.TimeSpec{
				StartTime:       timestamppb.New(start),
				DurationSeconds: ptr(maxEntrySeconds),
			},
			expectedStart:    start,
			expectedEnd:      ptr(start.Add(time.Duration(maxEntrySeconds) * time.Second)),
			expectedDuration: ptr(maxEntrySeconds),
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			resolved, err := resolveTimeSpec(tc.spec, hongKong, now)

			if tc.expectError {
				assert.Error(t, err)
				return
			}

			require.NoError(t, err)
			assert.True(t, tc.expectedStart.Equal(resolved.Start),
				"start: expected %s, got %s", tc.expectedStart, resolved.Start)
			assert.Equal(t, tc.expectedRunning, resolved.Running())

			if tc.expectedEnd == nil {
				assert.Nil(t, resolved.End)
			} else {
				require.NotNil(t, resolved.End)
				assert.True(t, tc.expectedEnd.Equal(*resolved.End),
					"end: expected %s, got %s", *tc.expectedEnd, *resolved.End)
			}

			if tc.expectedDuration == nil {
				assert.Nil(t, resolved.Duration)
			} else {
				require.NotNil(t, resolved.Duration)
				assert.Equal(t, *tc.expectedDuration, *resolved.Duration)
			}
		})
	}
}

func TestStartOfWeek(t *testing.T) {
	// 2026-08-07 is a Friday.
	friday := time.Date(2026, 8, 7, 15, 30, 0, 0, time.UTC)

	testCases := []struct {
		name         string
		weekStartsOn int
		expectedDay  int
	}{
		{name: "week starting Monday", weekStartsOn: 1, expectedDay: 3},
		{name: "week starting Sunday", weekStartsOn: 7, expectedDay: 2},
		{name: "week starting Saturday", weekStartsOn: 6, expectedDay: 1},
		{name: "week starting Friday is the same day", weekStartsOn: 5, expectedDay: 7},
		{name: "an out-of-range value falls back to Monday", weekStartsOn: 0, expectedDay: 3},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			got := startOfWeek(friday, tc.weekStartsOn)
			assert.Equal(t, tc.expectedDay, got.Day())
			assert.Equal(t, time.August, got.Month())
			// The time of day is always truncated to midnight.
			assert.Equal(t, 0, got.Hour())
			assert.Equal(t, 0, got.Minute())
		})
	}
}

func TestEndOfMonth(t *testing.T) {
	testCases := []struct {
		name        string
		input       time.Time
		expectedDay int
	}{
		{name: "31 day month", input: time.Date(2026, 8, 7, 0, 0, 0, 0, time.UTC), expectedDay: 31},
		{name: "30 day month", input: time.Date(2026, 9, 15, 0, 0, 0, 0, time.UTC), expectedDay: 30},
		{name: "february in a common year", input: time.Date(2026, 2, 1, 0, 0, 0, 0, time.UTC), expectedDay: 28},
		{name: "february in a leap year", input: time.Date(2028, 2, 1, 0, 0, 0, 0, time.UTC), expectedDay: 29},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.expectedDay, endOfMonth(tc.input).Day())
		})
	}
}

func TestPeriodBounds(t *testing.T) {
	// A Friday.
	day := time.Date(2026, 8, 7, 13, 0, 0, 0, time.UTC)

	testCases := []struct {
		name          string
		period        string
		expectedStart time.Time
		expectedEnd   time.Time
	}{
		{
			name:          "daily is a single day",
			period:        databasePeriodDaily,
			expectedStart: time.Date(2026, 8, 7, 0, 0, 0, 0, time.UTC),
			expectedEnd:   time.Date(2026, 8, 7, 0, 0, 0, 0, time.UTC),
		},
		{
			name:          "weekly spans Monday to Sunday",
			period:        databasePeriodWeekly,
			expectedStart: time.Date(2026, 8, 3, 0, 0, 0, 0, time.UTC),
			expectedEnd:   time.Date(2026, 8, 9, 0, 0, 0, 0, time.UTC),
		},
		{
			name:          "monthly spans the calendar month",
			period:        databasePeriodMonthly,
			expectedStart: time.Date(2026, 8, 1, 0, 0, 0, 0, time.UTC),
			expectedEnd:   time.Date(2026, 8, 31, 0, 0, 0, 0, time.UTC),
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			start, end := periodBounds(day, tc.period, 1)
			assert.True(t, tc.expectedStart.Equal(start), "start: want %s got %s", tc.expectedStart, start)
			assert.True(t, tc.expectedEnd.Equal(end), "end: want %s got %s", tc.expectedEnd, end)
		})
	}
}

func TestRoundUpSeconds(t *testing.T) {
	testCases := []struct {
		name     string
		seconds  int64
		rounding int
		expected int64
	}{
		{name: "rounding disabled", seconds: 100, rounding: 0, expected: 100},
		{name: "negative rounding is ignored", seconds: 100, rounding: -5, expected: 100},
		{name: "zero stays zero", seconds: 0, rounding: 15, expected: 0},
		{name: "one second rounds to a full increment", seconds: 1, rounding: 15, expected: 900},
		{name: "an exact multiple is unchanged", seconds: 900, rounding: 15, expected: 900},
		{name: "rounds up to the next increment", seconds: 901, rounding: 15, expected: 1800},
		{name: "six minutes rounds to fifteen", seconds: 360, rounding: 15, expected: 900},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.expected, roundUpSeconds(tc.seconds, tc.rounding))
		})
	}
}

func TestLoadLocation(t *testing.T) {
	t.Run("an empty name resolves to UTC", func(t *testing.T) {
		loc, err := loadLocation("")
		require.NoError(t, err)
		assert.Equal(t, time.UTC, loc)
	})

	t.Run("a valid name resolves", func(t *testing.T) {
		loc, err := loadLocation("Asia/Hong_Kong")
		require.NoError(t, err)
		assert.Equal(t, "Asia/Hong_Kong", loc.String())
	})

	t.Run("an unknown name is an error rather than a silent fallback", func(t *testing.T) {
		_, err := loadLocation("Mars/Olympus_Mons")
		assert.ErrorAs(t, err, &ErrUnknownTimezone{})
	})
}

func TestValidateDate(t *testing.T) {
	testCases := []struct {
		name        string
		date        *timeloggerv1.Date
		expectError bool
	}{
		{name: "valid", date: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7}},
		{name: "nil", date: nil, expectError: true},
		{name: "year too small", date: &timeloggerv1.Date{Year: 1969, Month: 1, Day: 1}, expectError: true},
		{name: "month zero", date: &timeloggerv1.Date{Year: 2026, Month: 0, Day: 1}, expectError: true},
		{name: "month too large", date: &timeloggerv1.Date{Year: 2026, Month: 13, Day: 1}, expectError: true},
		{name: "day zero", date: &timeloggerv1.Date{Year: 2026, Month: 1, Day: 0}, expectError: true},
		{name: "day too large", date: &timeloggerv1.Date{Year: 2026, Month: 1, Day: 32}, expectError: true},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			err := validateDate(tc.date, "date")
			if tc.expectError {
				assert.Error(t, err)
			} else {
				assert.NoError(t, err)
			}
		})
	}
}

func TestPeriodProtoRoundTrip(t *testing.T) {
	for _, p := range []timeloggerv1.Period{
		timeloggerv1.Period_PERIOD_DAILY,
		timeloggerv1.Period_PERIOD_WEEKLY,
		timeloggerv1.Period_PERIOD_MONTHLY,
	} {
		assert.Equal(t, p, periodToProto(periodFromProto(p)))
	}

	// The unspecified value is normalised to weekly rather than preserved.
	assert.Equal(t,
		timeloggerv1.Period_PERIOD_WEEKLY,
		periodToProto(periodFromProto(timeloggerv1.Period_PERIOD_UNSPECIFIED)),
	)
}
