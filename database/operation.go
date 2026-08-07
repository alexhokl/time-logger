package database

import (
	"fmt"

	"gorm.io/gorm"
)

// runningTimerIndexName is the partial unique index that enforces "at most one
// running timer per user" at the storage layer.
const runningTimerIndexName = "idx_one_running_entry_per_user"

// AutoMigrate brings the schema up to date and installs the indexes GORM's
// struct tags cannot express.
func AutoMigrate(db *gorm.DB) error {
	if err := db.AutoMigrate(
		&User{},
		&TailscaleAddress{},
		&UserSetting{},
		&Project{},
		&Task{},
		&Tag{},
		&TimeEntry{},
		&EntryTag{},
		&Goal{},
	); err != nil {
		return fmt.Errorf("auto migration failed: %w", err)
	}

	if err := createRunningTimerIndex(db); err != nil {
		return fmt.Errorf("running timer index migration failed: %w", err)
	}

	return nil
}

// createRunningTimerIndex installs a partial unique index over time_entries so
// that a user can never end up with two open timers, even if two StartTimer
// calls race past the handler's check.
//
// The index is partial in two ways: it only covers rows whose end_time is NULL
// (i.e. running entries), and it excludes soft-deleted rows so that cancelling
// a timer and immediately starting another one does not collide. GORM's struct
// tags cannot express a WHERE clause on an index, hence the raw DDL.
func createRunningTimerIndex(db *gorm.DB) error {
	stmt := fmt.Sprintf(
		`CREATE UNIQUE INDEX IF NOT EXISTS %s ON time_entries (user_id) `+
			`WHERE end_time IS NULL AND deleted_at IS NULL`,
		runningTimerIndexName,
	)
	return db.Exec(stmt).Error
}
