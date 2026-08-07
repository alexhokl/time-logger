package internal

import "fmt"

// ErrValidation reports a malformed request field. It maps to
// INVALID_ARGUMENT and its message is safe to return to the client, since it
// only ever describes the caller's own input.
type ErrValidation struct{ Reason string }

func (e ErrValidation) Error() string { return e.Reason }

// invalid is shorthand for building an ErrValidation at a call site.
func invalid(reason string) error { return ErrValidation{Reason: reason} }

// ErrProjectAlreadyExists is returned when a project name collides with an
// existing one for the same user.
type ErrProjectAlreadyExists struct{ Name string }

func (e ErrProjectAlreadyExists) Error() string {
	return fmt.Sprintf("project [%s] already exists", e.Name)
}

// ErrTaskAlreadyExists is returned when a task name collides within the same
// project.
type ErrTaskAlreadyExists struct {
	Name    string
	Project string
}

func (e ErrTaskAlreadyExists) Error() string {
	return fmt.Sprintf("task [%s] already exists in project [%s]", e.Name, e.Project)
}

// ErrTagAlreadyExists is returned when a tag name collides for the same user.
type ErrTagAlreadyExists struct{ Name string }

func (e ErrTagAlreadyExists) Error() string {
	return fmt.Sprintf("tag [%s] already exists", e.Name)
}

// ErrProjectHasEntries blocks deletion of a project that still has tracked
// time against it. Archiving is offered as the alternative because deleting
// would orphan history the user probably wants to keep.
type ErrProjectHasEntries struct {
	Name  string
	Count int64
}

func (e ErrProjectHasEntries) Error() string {
	return fmt.Sprintf(
		"project [%s] still has %d time entries; archive it instead of deleting it",
		e.Name, e.Count,
	)
}

// ErrTimerAlreadyRunning is returned by StartTimer when the user already has an
// open entry.
type ErrTimerAlreadyRunning struct {
	EntryID     uint
	Description string
}

func (e ErrTimerAlreadyRunning) Error() string {
	if e.Description == "" {
		return fmt.Sprintf("a timer is already running (entry %d)", e.EntryID)
	}
	return fmt.Sprintf("a timer is already running: %q (entry %d)", e.Description, e.EntryID)
}

// ErrNoTimerRunning is returned by StopTimer and CancelRunningTimer when there
// is nothing to act on.
type ErrNoTimerRunning struct{}

func (ErrNoTimerRunning) Error() string { return "no timer is currently running" }

// ErrInvalidTimeSpec describes an unusable combination of start, end, duration
// and date on a create or update request.
type ErrInvalidTimeSpec struct{ Reason string }

func (e ErrInvalidTimeSpec) Error() string {
	return fmt.Sprintf("invalid time specification: %s", e.Reason)
}

// ErrTaskProjectMismatch is returned when an entry names both a project and a
// task, but the task belongs to a different project.
type ErrTaskProjectMismatch struct {
	TaskName    string
	TaskProject string
	Project     string
}

func (e ErrTaskProjectMismatch) Error() string {
	return fmt.Sprintf(
		"task [%s] belongs to project [%s], not [%s]",
		e.TaskName, e.TaskProject, e.Project,
	)
}

// ErrUnknownTimezone is returned when a settings update names a timezone the
// host's zoneinfo database does not contain.
type ErrUnknownTimezone struct{ Name string }

func (e ErrUnknownTimezone) Error() string {
	return fmt.Sprintf("unknown timezone [%s]", e.Name)
}
