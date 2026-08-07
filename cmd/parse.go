package cmd

import (
	"fmt"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/spf13/cobra"

	"google.golang.org/protobuf/types/known/timestamppb"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// dateLayout is the canonical date format accepted and printed by the CLI.
const dateLayout = "2006-01-02"

// dateTimeLayouts are the accepted forms for a flag that names an instant,
// tried in order. Offering several avoids forcing the user to remember one
// exact spelling for what is obviously a time.
var dateTimeLayouts = []string{
	time.RFC3339,
	"2006-01-02T15:04:05",
	"2006-01-02 15:04:05",
	"2006-01-02 15:04",
	"2006-01-02T15:04",
	"2006-01-02",
}

// parseDate accepts an ISO date or one of the relative keywords "today",
// "yesterday" and "tomorrow".
//
// The keywords are resolved against the client's local clock, which may differ
// from the timezone the server reports in. That is the right trade-off for a
// CLI: "yesterday" should mean the user's yesterday, and the server is told an
// explicit calendar date rather than a relative term.
func parseDate(value string) (*timeloggerv1.Date, error) {
	value = strings.ToLower(strings.TrimSpace(value))
	if value == "" {
		return nil, nil
	}

	now := time.Now()
	switch value {
	case "today":
		return dateOf(now), nil
	case "yesterday":
		return dateOf(now.AddDate(0, 0, -1)), nil
	case "tomorrow":
		return dateOf(now.AddDate(0, 0, 1)), nil
	}

	parsed, err := time.ParseInLocation(dateLayout, value, time.Local)
	if err != nil {
		return nil, fmt.Errorf(
			"invalid date %q: expected YYYY-MM-DD, today, yesterday or tomorrow", value)
	}
	return dateOf(parsed), nil
}

// dateOf converts an instant to a calendar Date in its own location.
func dateOf(t time.Time) *timeloggerv1.Date {
	return &timeloggerv1.Date{
		Year:  int32(t.Year()),
		Month: int32(t.Month()),
		Day:   int32(t.Day()),
	}
}

// parseTimestamp accepts any of dateTimeLayouts and returns a proto timestamp.
// The value is interpreted in the client's local timezone unless it carries an
// explicit offset.
func parseTimestamp(value string) (*timestamppb.Timestamp, error) {
	value = strings.TrimSpace(value)
	if value == "" {
		return nil, nil
	}

	if strings.EqualFold(value, "now") {
		return timestamppb.New(time.Now()), nil
	}

	for _, layout := range dateTimeLayouts {
		if parsed, err := time.ParseInLocation(layout, value, time.Local); err == nil {
			return timestamppb.New(parsed), nil
		}
	}

	return nil, fmt.Errorf(
		"invalid time %q: expected e.g. 2026-08-07T09:30 or 2026-08-07 09:30", value)
}

// parseDuration accepts Go duration syntax ("1h30m", "90m") plus the bare and
// decimal-hour forms people naturally type ("1.5h", "90" meaning 90 minutes).
//
// A bare number is read as minutes because that is the smaller and far more
// common unit when logging work; reading it as hours would silently inflate an
// entry by 60x.
func parseDuration(value string) (time.Duration, error) {
	value = strings.ToLower(strings.TrimSpace(value))
	if value == "" {
		return 0, nil
	}

	if minutes, err := strconv.ParseFloat(value, 64); err == nil {
		if minutes < 0 {
			return 0, fmt.Errorf("duration cannot be negative")
		}
		return time.Duration(minutes * float64(time.Minute)), nil
	}

	// "1.5h" is not valid Go duration syntax before Go's parser sees a decimal
	// with a unit, but it is valid; handle the general case by deferring to
	// time.ParseDuration, which does accept "1.5h".
	parsed, err := time.ParseDuration(value)
	if err != nil {
		return 0, fmt.Errorf(
			"invalid duration %q: expected e.g. 90, 1h30m, 1.5h or 45m", value)
	}
	if parsed < 0 {
		return 0, fmt.Errorf("duration cannot be negative")
	}
	return parsed, nil
}

// buildTimeSpec assembles the proto TimeSpec from the timing flags a command
// received. Empty flags are left unset so the server applies its own inference
// rules rather than the CLI guessing on its behalf.
func buildTimeSpec(startFlag, endFlag, durationFlag, dateFlag string) (*timeloggerv1.TimeSpec, error) {
	spec := &timeloggerv1.TimeSpec{}
	any := false

	if startFlag != "" {
		start, err := parseTimestamp(startFlag)
		if err != nil {
			return nil, err
		}
		spec.StartTime = start
		any = true
	}

	if endFlag != "" {
		end, err := parseTimestamp(endFlag)
		if err != nil {
			return nil, err
		}
		spec.EndTime = end
		any = true
	}

	if durationFlag != "" {
		duration, err := parseDuration(durationFlag)
		if err != nil {
			return nil, err
		}
		seconds := int64(duration.Seconds())
		spec.DurationSeconds = &seconds
		any = true
	}

	if dateFlag != "" {
		date, err := parseDate(dateFlag)
		if err != nil {
			return nil, err
		}
		spec.Date = date
		any = true
	}

	if !any {
		return nil, nil
	}
	return spec, nil
}

// parsePeriod maps a user-facing period word onto the proto enum.
func parsePeriod(value string) (timeloggerv1.Period, error) {
	switch strings.ToLower(strings.TrimSpace(value)) {
	case "", "weekly", "week":
		return timeloggerv1.Period_PERIOD_WEEKLY, nil
	case "daily", "day":
		return timeloggerv1.Period_PERIOD_DAILY, nil
	case "monthly", "month":
		return timeloggerv1.Period_PERIOD_MONTHLY, nil
	default:
		return timeloggerv1.Period_PERIOD_UNSPECIFIED,
			fmt.Errorf("invalid period %q: expected daily, weekly or monthly", value)
	}
}

// parseGroupBy maps a user-facing grouping word onto the proto enum.
func parseGroupBy(value string) (timeloggerv1.GroupBy, error) {
	switch strings.ToLower(strings.TrimSpace(value)) {
	case "", "project":
		return timeloggerv1.GroupBy_GROUP_BY_PROJECT, nil
	case "task":
		return timeloggerv1.GroupBy_GROUP_BY_TASK, nil
	case "tag":
		return timeloggerv1.GroupBy_GROUP_BY_TAG, nil
	case "day", "date":
		return timeloggerv1.GroupBy_GROUP_BY_DAY, nil
	default:
		return timeloggerv1.GroupBy_GROUP_BY_UNSPECIFIED,
			fmt.Errorf("invalid group-by %q: expected project, task, tag or day", value)
	}
}

// parseDayOfWeek maps a weekday name onto the proto enum.
func parseDayOfWeek(value string) (timeloggerv1.DayOfWeek, error) {
	days := map[string]timeloggerv1.DayOfWeek{
		"monday":    timeloggerv1.DayOfWeek_DAY_OF_WEEK_MONDAY,
		"tuesday":   timeloggerv1.DayOfWeek_DAY_OF_WEEK_TUESDAY,
		"wednesday": timeloggerv1.DayOfWeek_DAY_OF_WEEK_WEDNESDAY,
		"thursday":  timeloggerv1.DayOfWeek_DAY_OF_WEEK_THURSDAY,
		"friday":    timeloggerv1.DayOfWeek_DAY_OF_WEEK_FRIDAY,
		"saturday":  timeloggerv1.DayOfWeek_DAY_OF_WEEK_SATURDAY,
		"sunday":    timeloggerv1.DayOfWeek_DAY_OF_WEEK_SUNDAY,
	}

	key := strings.ToLower(strings.TrimSpace(value))
	if day, ok := days[key]; ok {
		return day, nil
	}
	return timeloggerv1.DayOfWeek_DAY_OF_WEEK_UNSPECIFIED,
		fmt.Errorf("invalid day %q: expected a weekday name such as monday", value)
}

// parseID parses a positional record identifier.
func parseID(value string) (uint64, error) {
	id, err := strconv.ParseUint(strings.TrimSpace(value), 10, 64)
	if err != nil || id == 0 {
		return 0, fmt.Errorf("invalid id %q: expected a positive whole number", value)
	}
	return id, nil
}

// changedFlags builds an update mask from the flags the user actually set.
//
// Deriving the mask from flag usage rather than from non-zero values is what
// lets a field be cleared: `--project 0` is a deliberate instruction to unset
// the project, whereas omitting the flag entirely leaves it untouched. The
// mapping is flag name to proto field name, and duplicates are collapsed.
func changedFlags(cmd *cobra.Command, mapping map[string]string) []string {
	seen := map[string]struct{}{}
	mask := make([]string, 0, len(mapping))

	for flagName, fieldName := range mapping {
		if !cmd.Flags().Changed(flagName) {
			continue
		}
		if _, dup := seen[fieldName]; dup {
			continue
		}
		seen[fieldName] = struct{}{}
		mask = append(mask, fieldName)
	}

	sort.Strings(mask)
	return mask
}

// timestampOf wraps an instant for use in a request message.
func timestampOf(t time.Time) *timestamppb.Timestamp {
	return timestamppb.New(t)
}

// toUint64Slice widens the uint slice pflag produces into the uint64 the proto
// fields use.
func toUint64Slice(values []uint) []uint64 {
	if len(values) == 0 {
		return nil
	}
	out := make([]uint64, 0, len(values))
	for _, v := range values {
		out = append(out, uint64(v))
	}
	return out
}
