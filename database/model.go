package database

import (
	"time"

	"gorm.io/gorm"
)

// User is the owner of every other record. Users are created implicitly the
// first time a Tailscale login name is seen by the authentication interceptor.
type User struct {
	gorm.Model
	Username string `gorm:"uniqueIndex;not null"`
}

// TailscaleAddress caches the mapping from a tailnet IP address to a user so
// that the authentication interceptor does not have to query the Tailscale
// local API on every request. It deliberately does not embed gorm.Model: the
// address is the primary key and the row has no meaningful lifecycle beyond
// existing.
type TailscaleAddress struct {
	Address   string `gorm:"primaryKey"`
	UserID    uint   `gorm:"not null;index"`
	CreatedAt time.Time
}

// UserSetting holds the per-user preferences that change how the server
// interprets time. There is at most one row per user; it is created lazily with
// defaults the first time it is read.
type UserSetting struct {
	gorm.Model
	UserID uint `gorm:"uniqueIndex;not null"`

	// Timezone is an IANA name such as "Asia/Hong_Kong". Date-only inputs and
	// all report day boundaries are resolved in this zone.
	Timezone string `gorm:"not null;default:Asia/Hong_Kong"`

	// WeekStartsOn uses the ISO numbering of time.Weekday shifted so that
	// Monday is 1 and Sunday is 7, matching the DayOfWeek enum in the proto.
	WeekStartsOn int `gorm:"not null;default:1"`

	// RoundingMinutes rounds durations up to a multiple of this many minutes
	// when reporting. Zero disables rounding. Stored durations are never
	// altered, so switching this value is always reversible.
	RoundingMinutes int `gorm:"not null;default:0"`

	// DefaultProjectID is a hint for clients starting a timer. Nil means none.
	DefaultProjectID *uint
}

// Project is the top-level grouping of tracked work.
type Project struct {
	gorm.Model
	Name string `gorm:"not null;index:idx_project_user_name,unique"`
	// Color is an optional hex string such as "#4285F4" used by the UI.
	Color    string
	Archived bool `gorm:"not null;default:false;index"`
	UserID   uint `gorm:"not null;index:idx_project_user_name,unique"`
}

// Task is an optional second level of grouping nested inside a project.
type Task struct {
	gorm.Model
	Name      string `gorm:"not null;index:idx_task_user_project_name,unique"`
	ProjectID uint   `gorm:"not null;index:idx_task_user_project_name,unique"`
	Archived  bool   `gorm:"not null;default:false;index"`
	UserID    uint   `gorm:"not null;index:idx_task_user_project_name,unique"`

	Project *Project `gorm:"foreignKey:ProjectID"`
}

// Tag is a free-form label. Tags are shared across entries via EntryTag rather
// than duplicated per entry, so renaming one updates every entry that uses it.
type Tag struct {
	gorm.Model
	Name   string `gorm:"not null;index:idx_tag_user_name,unique"`
	UserID uint   `gorm:"not null;index:idx_tag_user_name,unique"`
}

// TimeEntry is a single unit of tracked work.
//
// A running timer is represented as a TimeEntry with EndTime nil. There is a
// partial unique index (see AutoMigrate) enforcing at most one such row per
// user, so a race between two concurrent StartTimer calls is rejected by the
// database rather than producing two running timers.
//
// DurationSeconds is always derived from StartTime and EndTime and is stored
// redundantly so that reports can sum it without per-row arithmetic. It is nil
// exactly when the entry is running.
type TimeEntry struct {
	gorm.Model
	Description string

	// Nil when the entry is not associated with a project or task.
	ProjectID *uint `gorm:"index"`
	TaskID    *uint `gorm:"index"`

	StartTime       time.Time  `gorm:"not null;index:idx_entry_user_start"`
	EndTime         *time.Time `gorm:"index"`
	DurationSeconds *int64

	UserID uint `gorm:"not null;index:idx_entry_user_start"`

	Project *Project `gorm:"foreignKey:ProjectID"`
	Task    *Task    `gorm:"foreignKey:TaskID"`
	Tags    []Tag    `gorm:"many2many:entry_tags;joinForeignKey:TimeEntryID;joinReferences:TagID"`
}

// IsRunning reports whether the entry is the user's open timer.
func (e TimeEntry) IsRunning() bool {
	return e.EndTime == nil
}

// ElapsedSeconds returns the entry's duration, computing it on the fly against
// now for a running entry. It never returns a negative value.
func (e TimeEntry) ElapsedSeconds(now time.Time) int64 {
	if e.DurationSeconds != nil {
		return *e.DurationSeconds
	}
	seconds := int64(now.Sub(e.StartTime).Seconds())
	if seconds < 0 {
		return 0
	}
	return seconds
}

// EntryTag is the join table between TimeEntry and Tag. It is declared
// explicitly so that the composite primary key is created and so that handlers
// can manipulate associations with plain queries.
type EntryTag struct {
	TimeEntryID uint `gorm:"primaryKey"`
	TagID       uint `gorm:"primaryKey;index"`
}

// Goal is a recurring target for how much time should be spent on a project or
// task within a period.
type Goal struct {
	gorm.Model
	// Nil ProjectID means the goal spans every project; nil TaskID means it
	// spans every task within the project.
	ProjectID *uint `gorm:"index"`
	TaskID    *uint `gorm:"index"`

	// TargetSeconds is stored in seconds even though the API speaks in hours,
	// so that comparisons against tracked time need no unit conversion.
	TargetSeconds int64 `gorm:"not null"`

	// Period is one of "daily", "weekly" or "monthly".
	Period string `gorm:"not null;default:weekly"`

	// StartDate and EndDate are midnight instants in the user's timezone. A nil
	// EndDate means the goal is open-ended.
	StartDate time.Time `gorm:"not null"`
	EndDate   *time.Time

	UserID uint `gorm:"not null;index"`

	Project *Project `gorm:"foreignKey:ProjectID"`
	Task    *Task    `gorm:"foreignKey:TaskID"`
}

// Goal period values. These mirror the Period enum in the proto.
const (
	PeriodDaily   = "daily"
	PeriodWeekly  = "weekly"
	PeriodMonthly = "monthly"
)
