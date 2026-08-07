package internal

import (
	"time"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// DefaultTimezone is used for a user who has never saved a settings row.
const DefaultTimezone = "Asia/Hong_Kong"

// dateFromTime converts an instant, already expressed in the target location,
// into a calendar Date.
func dateFromTime(t time.Time) *timeloggerv1.Date {
	year, month, day := t.Date()
	return &timeloggerv1.Date{
		Year:  int32(year),
		Month: int32(month),
		Day:   int32(day),
	}
}

// startOfDay returns midnight at the beginning of the given calendar date in
// loc.
//
// Note that time.Date normalises out-of-range components (month 13 becomes
// January of the next year) rather than failing, and resolves the ambiguity
// around a DST transition by picking one of the two candidate instants. Both
// behaviours are acceptable here because dates are validated before they reach
// this function and because no timezone starts its day inside a DST gap.
func startOfDay(d *timeloggerv1.Date, loc *time.Location) time.Time {
	return time.Date(int(d.GetYear()), time.Month(d.GetMonth()), int(d.GetDay()), 0, 0, 0, 0, loc)
}

// startOfWeek returns midnight on the first day of the week containing t,
// where weekStartsOn uses ISO numbering (1 = Monday ... 7 = Sunday) to match
// the DayOfWeek enum in the proto.
//
// Go's time.Weekday numbers Sunday as 0, so it is converted to ISO numbering
// first; the modulo keeps the offset non-negative when the week starts on a day
// later than the current one.
func startOfWeek(t time.Time, weekStartsOn int) time.Time {
	if weekStartsOn < 1 || weekStartsOn > 7 {
		weekStartsOn = int(time.Monday)
	}

	isoWeekday := int(t.Weekday())
	if isoWeekday == 0 {
		isoWeekday = 7 // Sunday
	}

	offset := (isoWeekday - weekStartsOn + 7) % 7
	day := t.AddDate(0, 0, -offset)

	return time.Date(day.Year(), day.Month(), day.Day(), 0, 0, 0, 0, t.Location())
}

// startOfMonth returns midnight on the first day of the month containing t.
func startOfMonth(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), 1, 0, 0, 0, 0, t.Location())
}

// endOfMonth returns the last calendar day of the month containing t. It is
// derived by stepping to the first of the next month and back one day, which
// handles month lengths and leap years without a lookup table.
func endOfMonth(t time.Time) time.Time {
	return startOfMonth(t).AddDate(0, 1, -1)
}

// periodBounds returns the inclusive first and last calendar day of the period
// of the given kind that contains the instant t.
func periodBounds(t time.Time, period string, weekStartsOn int) (time.Time, time.Time) {
	switch period {
	case databasePeriodDaily:
		day := time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, t.Location())
		return day, day
	case databasePeriodMonthly:
		return startOfMonth(t), endOfMonth(t)
	default: // weekly
		start := startOfWeek(t, weekStartsOn)
		return start, start.AddDate(0, 0, 6)
	}
}

// loadLocation resolves an IANA timezone name, falling back to UTC when the
// name is empty. An unknown name is reported as an error rather than silently
// falling back, because misreading a user's timezone would quietly shift every
// report by hours.
func loadLocation(name string) (*time.Location, error) {
	if name == "" {
		return time.UTC, nil
	}
	loc, err := time.LoadLocation(name)
	if err != nil {
		return nil, ErrUnknownTimezone{Name: name}
	}
	return loc, nil
}

// validateDate checks that a Date is present and internally plausible. It does
// not check that the day exists in the given month; time.Date normalises such
// values, and rejecting them would make the CLI harder to use than it is worth.
func validateDate(d *timeloggerv1.Date, fieldName string) error {
	if d == nil {
		return ErrInvalidTimeSpec{Reason: fieldName + " is required"}
	}
	if d.GetYear() < 1970 || d.GetYear() > 9999 {
		return ErrInvalidTimeSpec{Reason: fieldName + " has an out-of-range year"}
	}
	if d.GetMonth() < 1 || d.GetMonth() > 12 {
		return ErrInvalidTimeSpec{Reason: fieldName + " has an out-of-range month"}
	}
	if d.GetDay() < 1 || d.GetDay() > 31 {
		return ErrInvalidTimeSpec{Reason: fieldName + " has an out-of-range day"}
	}
	return nil
}

// roundUpSeconds rounds a duration up to the next multiple of roundingMinutes.
// A zero or negative rounding disables the behaviour, and a zero duration stays
// zero so that an untracked bucket is not inflated to a full increment.
func roundUpSeconds(seconds int64, roundingMinutes int) int64 {
	if roundingMinutes <= 0 || seconds <= 0 {
		return seconds
	}
	increment := int64(roundingMinutes) * 60
	remainder := seconds % increment
	if remainder == 0 {
		return seconds
	}
	return seconds + increment - remainder
}

// Period constants duplicated from the database package to avoid an import
// cycle in the helpers above; they are asserted to be in sync by a unit test.
const (
	databasePeriodDaily   = "daily"
	databasePeriodWeekly  = "weekly"
	databasePeriodMonthly = "monthly"
)

// periodFromProto maps the proto Period enum onto its database representation,
// defaulting to weekly for the unspecified value.
func periodFromProto(p timeloggerv1.Period) string {
	switch p {
	case timeloggerv1.Period_PERIOD_DAILY:
		return databasePeriodDaily
	case timeloggerv1.Period_PERIOD_MONTHLY:
		return databasePeriodMonthly
	case timeloggerv1.Period_PERIOD_WEEKLY, timeloggerv1.Period_PERIOD_UNSPECIFIED:
		return databasePeriodWeekly
	default:
		return databasePeriodWeekly
	}
}

// periodToProto is the inverse of periodFromProto.
func periodToProto(p string) timeloggerv1.Period {
	switch p {
	case databasePeriodDaily:
		return timeloggerv1.Period_PERIOD_DAILY
	case databasePeriodMonthly:
		return timeloggerv1.Period_PERIOD_MONTHLY
	default:
		return timeloggerv1.Period_PERIOD_WEEKLY
	}
}
