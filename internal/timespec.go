package internal

import (
	"time"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// resolvedTime is the normalised form of a TimeSpec: an absolute start, an
// optional end, and the duration between them. End and Duration are both nil
// exactly when the entry is meant to be left running.
type resolvedTime struct {
	Start    time.Time
	End      *time.Time
	Duration *int64
}

// Running reports whether the resolved specification describes an open timer.
func (r resolvedTime) Running() bool { return r.End == nil }

// maxEntrySeconds caps a single entry at 31 days. A longer entry is almost
// certainly a mistyped date or a timer left running for weeks, and allowing it
// would distort every report that includes it.
const maxEntrySeconds = int64(31 * 24 * 60 * 60)

// resolveTimeSpec turns the caller's chosen combination of start, end,
// duration and date into an absolute start/end/duration triple.
//
// Exactly which fields the caller supplies is up to them; the accepted
// combinations and the field each one derives are:
//
//	start + end       -> duration = end - start
//	start + duration  -> end      = start + duration
//	end + duration    -> start    = end - duration
//	date + duration   -> start    = midnight on date in loc, end = start + duration
//	start only        -> running entry (end and duration stay nil)
//	nothing           -> running entry starting at now
//
// All three of start, end and duration may be given together, but only if they
// agree; a mismatch is rejected rather than silently preferring one of them,
// because there is no way to know which the caller meant.
//
// loc is the user's timezone and is used only to interpret the date-only form.
// now is injected rather than read from the clock so the behaviour is testable.
func resolveTimeSpec(spec *timeloggerv1.TimeSpec, loc *time.Location, now time.Time) (resolvedTime, error) {
	if spec == nil {
		// No timing information at all means "start tracking now".
		return resolvedTime{Start: now.UTC()}, nil
	}

	var (
		start    *time.Time
		end      *time.Time
		duration *int64
	)

	if spec.StartTime != nil {
		t := spec.GetStartTime().AsTime().UTC()
		start = &t
	}
	if spec.EndTime != nil {
		t := spec.GetEndTime().AsTime().UTC()
		end = &t
	}
	if spec.DurationSeconds != nil {
		d := spec.GetDurationSeconds()
		duration = &d
	}

	// The date-only form is a shorthand for a start time, so fold it in before
	// the combination analysis below.
	if spec.Date != nil {
		if start != nil {
			return resolvedTime{}, ErrInvalidTimeSpec{
				Reason: "date cannot be combined with start_time; use one or the other",
			}
		}
		if err := validateDate(spec.GetDate(), "date"); err != nil {
			return resolvedTime{}, err
		}
		if duration == nil && end == nil {
			return resolvedTime{}, ErrInvalidTimeSpec{
				Reason: "date requires either duration_seconds or end_time",
			}
		}
		t := startOfDay(spec.GetDate(), loc).UTC()
		start = &t
	}

	if duration != nil && *duration < 0 {
		return resolvedTime{}, ErrInvalidTimeSpec{Reason: "duration_seconds cannot be negative"}
	}

	switch {
	case start != nil && end != nil && duration != nil:
		// Fully specified: accept only if self-consistent.
		computed := int64(end.Sub(*start).Seconds())
		if computed != *duration {
			return resolvedTime{}, ErrInvalidTimeSpec{
				Reason: "start_time, end_time and duration_seconds are inconsistent",
			}
		}

	case start != nil && end != nil:
		computed := int64(end.Sub(*start).Seconds())
		duration = &computed

	case start != nil && duration != nil:
		computed := start.Add(time.Duration(*duration) * time.Second)
		end = &computed

	case end != nil && duration != nil:
		computed := end.Add(-time.Duration(*duration) * time.Second)
		start = &computed

	case start != nil:
		// Start with no end and no duration: a running timer.
		return resolvedTime{Start: *start}, nil

	case end != nil:
		return resolvedTime{}, ErrInvalidTimeSpec{
			Reason: "end_time requires either start_time or duration_seconds",
		}

	case duration != nil:
		// A bare duration means "this much work, finishing now", which is the
		// natural reading of `time-logger create entry --duration 2h`.
		computedEnd := now.UTC()
		computedStart := computedEnd.Add(-time.Duration(*duration) * time.Second)
		start, end = &computedStart, &computedEnd

	default:
		return resolvedTime{Start: now.UTC()}, nil
	}

	if end.Before(*start) {
		return resolvedTime{}, ErrInvalidTimeSpec{Reason: "end_time is before start_time"}
	}
	if *duration > maxEntrySeconds {
		return resolvedTime{}, ErrInvalidTimeSpec{
			Reason: "a single entry cannot be longer than 31 days",
		}
	}

	return resolvedTime{Start: *start, End: end, Duration: duration}, nil
}
