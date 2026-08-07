package cmd

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

func TestParseDuration(t *testing.T) {
	testCases := []struct {
		name        string
		input       string
		expected    time.Duration
		expectError bool
	}{
		{name: "empty is zero", input: "", expected: 0},
		// A bare number means minutes: it is the smaller and far more common
		// unit when logging work, and reading it as hours would inflate an
		// entry sixty-fold.
		{name: "a bare number is minutes", input: "90", expected: 90 * time.Minute},
		{name: "a bare decimal is minutes", input: "7.5", expected: 450 * time.Second},
		{name: "go duration syntax", input: "1h30m", expected: 90 * time.Minute},
		{name: "decimal hours", input: "1.5h", expected: 90 * time.Minute},
		{name: "minutes with a unit", input: "45m", expected: 45 * time.Minute},
		{name: "seconds", input: "30s", expected: 30 * time.Second},
		{name: "uppercase is accepted", input: "2H", expected: 2 * time.Hour},
		{name: "negative bare number", input: "-5", expectError: true},
		{name: "negative duration", input: "-1h", expectError: true},
		{name: "nonsense", input: "soon", expectError: true},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			got, err := parseDuration(tc.input)
			if tc.expectError {
				assert.Error(t, err)
				return
			}
			require.NoError(t, err)
			assert.Equal(t, tc.expected, got)
		})
	}
}

func TestParseDateKeywords(t *testing.T) {
	now := time.Now()

	testCases := []struct {
		name     string
		input    string
		expected time.Time
	}{
		{name: "today", input: "today", expected: now},
		{name: "yesterday", input: "yesterday", expected: now.AddDate(0, 0, -1)},
		{name: "tomorrow", input: "tomorrow", expected: now.AddDate(0, 0, 1)},
		{name: "case-insensitive", input: "TODAY", expected: now},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			got, err := parseDate(tc.input)
			require.NoError(t, err)
			assert.Equal(t, int32(tc.expected.Year()), got.GetYear())
			assert.Equal(t, int32(tc.expected.Month()), got.GetMonth())
			assert.Equal(t, int32(tc.expected.Day()), got.GetDay())
		})
	}
}

func TestParseDateISO(t *testing.T) {
	got, err := parseDate("2026-08-07")
	require.NoError(t, err)
	assert.Equal(t, int32(2026), got.GetYear())
	assert.Equal(t, int32(8), got.GetMonth())
	assert.Equal(t, int32(7), got.GetDay())

	_, err = parseDate("07/08/2026")
	assert.Error(t, err)
}

func TestParseTimestampAcceptsSeveralLayouts(t *testing.T) {
	for _, input := range []string{
		"2026-08-07T09:30:00Z",
		"2026-08-07T09:30:00",
		"2026-08-07 09:30:00",
		"2026-08-07 09:30",
		"2026-08-07T09:30",
		"2026-08-07",
	} {
		t.Run(input, func(t *testing.T) {
			got, err := parseTimestamp(input)
			require.NoError(t, err)
			require.NotNil(t, got)
			assert.Equal(t, 2026, got.AsTime().Year())
		})
	}

	t.Run("nonsense is rejected", func(t *testing.T) {
		_, err := parseTimestamp("half past nine")
		assert.Error(t, err)
	})

	t.Run("empty yields no timestamp", func(t *testing.T) {
		got, err := parseTimestamp("")
		require.NoError(t, err)
		assert.Nil(t, got)
	})
}

func TestBuildTimeSpec(t *testing.T) {
	t.Run("no flags yields no spec so the server decides", func(t *testing.T) {
		spec, err := buildTimeSpec("", "", "", "")
		require.NoError(t, err)
		assert.Nil(t, spec)
	})

	t.Run("duration alone", func(t *testing.T) {
		spec, err := buildTimeSpec("", "", "90", "")
		require.NoError(t, err)
		require.NotNil(t, spec.DurationSeconds)
		assert.Equal(t, int64(5400), spec.GetDurationSeconds())
		assert.Nil(t, spec.StartTime)
	})

	t.Run("date and duration", func(t *testing.T) {
		spec, err := buildTimeSpec("", "", "2h", "2026-08-07")
		require.NoError(t, err)
		assert.Equal(t, int64(7200), spec.GetDurationSeconds())
		assert.Equal(t, int32(7), spec.GetDate().GetDay())
	})

	t.Run("an invalid flag is reported", func(t *testing.T) {
		_, err := buildTimeSpec("", "", "soon", "")
		assert.Error(t, err)
	})
}

func TestFormatDuration(t *testing.T) {
	testCases := []struct {
		name     string
		seconds  int64
		expected string
	}{
		{name: "zero", seconds: 0, expected: "0m"},
		{name: "negative clamps to zero", seconds: -10, expected: "0m"},
		{name: "under a minute shows seconds", seconds: 45, expected: "45s"},
		{name: "whole minutes", seconds: 900, expected: "15m"},
		{name: "whole hours omit the minutes", seconds: 7200, expected: "2h"},
		{name: "hours and minutes are zero-padded", seconds: 5400, expected: "1h30m"},
		{name: "single-digit minutes are padded", seconds: 3660, expected: "1h01m"},
		{name: "long durations", seconds: 123456, expected: "34h17m"},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.expected, formatDuration(tc.seconds))
		})
	}
}

func TestFormatDate(t *testing.T) {
	assert.Equal(t, "", formatDate(nil))
	assert.Equal(t, "2026-08-07",
		formatDate(&timeloggerv1.Date{Year: 2026, Month: 8, Day: 7}))
	// Single-digit components are zero-padded so output sorts lexically.
	assert.Equal(t, "2026-01-02",
		formatDate(&timeloggerv1.Date{Year: 2026, Month: 1, Day: 2}))
}

func TestFilterColumns(t *testing.T) {
	defaults := []string{"id", "name", "duration"}
	allowed := map[string]struct{}{
		"id": {}, "name": {}, "duration": {}, "seconds": {},
	}

	testCases := []struct {
		name     string
		fields   []string
		expected []string
	}{
		{name: "no selection keeps the defaults", fields: nil, expected: defaults},
		{
			name:     "selection is honoured in the order given",
			fields:   []string{"duration", "id"},
			expected: []string{"duration", "id"},
		},
		{
			// Hidden machine-friendly keys must be selectable, otherwise
			// scripting against the CLI is needlessly awkward.
			name:     "a key absent from the defaults is still selectable",
			fields:   []string{"seconds"},
			expected: []string{"seconds"},
		},
		{
			name:     "unknown names are ignored",
			fields:   []string{"id", "nonsense"},
			expected: []string{"id"},
		},
		{
			// Printing nothing is never what the user meant.
			name:     "a wholly unmatched selection falls back to the defaults",
			fields:   []string{"nonsense"},
			expected: defaults,
		},
		{
			name:     "whitespace is trimmed",
			fields:   []string{" id ", " name"},
			expected: []string{"id", "name"},
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.expected, filterColumns(defaults, allowed, tc.fields))
		})
	}
}

func TestValidateFormat(t *testing.T) {
	for _, format := range []string{formatText, formatJSON, formatCSV} {
		assert.NoError(t, validateFormat(format))
	}
	assert.Error(t, validateFormat("yaml"))
	assert.Error(t, validateFormat(""))
}

func TestRequireSecureConnection(t *testing.T) {
	testCases := []struct {
		name     string
		url      string
		expected bool
	}{
		// Loopback means a developer running without certificates.
		{name: "localhost", url: "localhost:8080", expected: false},
		{name: "ipv4 loopback", url: "127.0.0.1:8080", expected: false},
		{name: "ipv6 loopback", url: "[::1]:8080", expected: false},
		{name: "empty", url: "", expected: false},
		// Anything else is assumed to be the tailnet, where the server
		// terminates TLS with a publicly trusted certificate.
		{name: "a tailnet FQDN", url: "time-logger.husky-bee.ts.net:443", expected: true},
		{name: "an arbitrary host", url: "example.com:443", expected: true},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.expected, requireSecureConnection(tc.url))
		})
	}
}

func TestParseID(t *testing.T) {
	got, err := parseID("42")
	require.NoError(t, err)
	assert.Equal(t, uint64(42), got)

	for _, invalid := range []string{"0", "-1", "abc", ""} {
		t.Run("rejects "+invalid, func(t *testing.T) {
			_, err := parseID(invalid)
			assert.Error(t, err)
		})
	}
}

func TestParsePeriod(t *testing.T) {
	testCases := map[string]timeloggerv1.Period{
		"":        timeloggerv1.Period_PERIOD_WEEKLY,
		"weekly":  timeloggerv1.Period_PERIOD_WEEKLY,
		"week":    timeloggerv1.Period_PERIOD_WEEKLY,
		"daily":   timeloggerv1.Period_PERIOD_DAILY,
		"day":     timeloggerv1.Period_PERIOD_DAILY,
		"monthly": timeloggerv1.Period_PERIOD_MONTHLY,
		"MONTH":   timeloggerv1.Period_PERIOD_MONTHLY,
	}

	for input, expected := range testCases {
		t.Run("parses "+input, func(t *testing.T) {
			got, err := parsePeriod(input)
			require.NoError(t, err)
			assert.Equal(t, expected, got)
		})
	}

	_, err := parsePeriod("fortnightly")
	assert.Error(t, err)
}

func TestParseGroupBy(t *testing.T) {
	testCases := map[string]timeloggerv1.GroupBy{
		"":        timeloggerv1.GroupBy_GROUP_BY_PROJECT,
		"project": timeloggerv1.GroupBy_GROUP_BY_PROJECT,
		"task":    timeloggerv1.GroupBy_GROUP_BY_TASK,
		"tag":     timeloggerv1.GroupBy_GROUP_BY_TAG,
		"day":     timeloggerv1.GroupBy_GROUP_BY_DAY,
		"date":    timeloggerv1.GroupBy_GROUP_BY_DAY,
	}

	for input, expected := range testCases {
		t.Run("parses "+input, func(t *testing.T) {
			got, err := parseGroupBy(input)
			require.NoError(t, err)
			assert.Equal(t, expected, got)
		})
	}

	_, err := parseGroupBy("client")
	assert.Error(t, err)
}

func TestParseDayOfWeek(t *testing.T) {
	got, err := parseDayOfWeek("Monday")
	require.NoError(t, err)
	assert.Equal(t, timeloggerv1.DayOfWeek_DAY_OF_WEEK_MONDAY, got)

	got, err = parseDayOfWeek("sunday")
	require.NoError(t, err)
	assert.Equal(t, timeloggerv1.DayOfWeek_DAY_OF_WEEK_SUNDAY, got)

	_, err = parseDayOfWeek("caturday")
	assert.Error(t, err)
}

func TestStringify(t *testing.T) {
	assert.Equal(t, "", stringify(nil))
	assert.Equal(t, "yes", stringify(true))
	assert.Equal(t, "no", stringify(false))
	assert.Equal(t, "42", stringify(42))
	assert.Equal(t, "3.14", stringify(3.14159))
	assert.Equal(t, "hello", stringify("hello"))
}
