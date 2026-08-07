package database

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// newTestDB returns a migrated in-memory database. Each call gets its own
// database because the DSN uses a private cache.
func newTestDB(t *testing.T) *gorm.DB {
	t.Helper()
	db, err := gorm.Open(sqlite.Open("file::memory:"), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent),
	})
	require.NoError(t, err)
	require.NoError(t, AutoMigrate(db))
	return db
}

func TestAutoMigrateIsIdempotent(t *testing.T) {
	db := newTestDB(t)
	// Running the migration a second time must not fail; the server calls it
	// on every start.
	assert.NoError(t, AutoMigrate(db))
}

func TestAutoMigrateCreatesTables(t *testing.T) {
	db := newTestDB(t)

	tables := []string{
		"users", "tailscale_addresses", "user_settings", "projects",
		"tasks", "tags", "time_entries", "entry_tags", "goals",
	}
	for _, table := range tables {
		assert.Truef(t, db.Migrator().HasTable(table), "expected table %q to exist", table)
	}
}

func TestOneRunningEntryPerUserIsEnforced(t *testing.T) {
	db := newTestDB(t)
	start := time.Now()

	first := TimeEntry{UserID: 1, StartTime: start, Description: "first"}
	require.NoError(t, db.Create(&first).Error)

	// A second open entry for the same user must be rejected by the partial
	// unique index, regardless of what the handler does.
	second := TimeEntry{UserID: 1, StartTime: start, Description: "second"}
	assert.Error(t, db.Create(&second).Error)

	// A different user is unaffected.
	other := TimeEntry{UserID: 2, StartTime: start, Description: "other user"}
	assert.NoError(t, db.Create(&other).Error)
}

func TestClosedEntriesAreNotConstrained(t *testing.T) {
	db := newTestDB(t)
	start := time.Now()
	end := start.Add(time.Hour)
	duration := int64(3600)

	for range 3 {
		entry := TimeEntry{
			UserID:          1,
			StartTime:       start,
			EndTime:         &end,
			DurationSeconds: &duration,
		}
		assert.NoError(t, db.Create(&entry).Error)
	}
}

func TestCancelledTimerFreesTheSlot(t *testing.T) {
	db := newTestDB(t)
	start := time.Now()

	first := TimeEntry{UserID: 1, StartTime: start}
	require.NoError(t, db.Create(&first).Error)

	// Cancelling is a soft delete; the index excludes soft-deleted rows so a
	// new timer can be started immediately afterwards.
	require.NoError(t, db.Delete(&first).Error)

	second := TimeEntry{UserID: 1, StartTime: start}
	assert.NoError(t, db.Create(&second).Error)
}

func TestUniqueConstraintsAreScopedPerUser(t *testing.T) {
	db := newTestDB(t)

	require.NoError(t, db.Create(&Project{Name: "acme", UserID: 1}).Error)
	// Same name, same user: rejected.
	assert.Error(t, db.Create(&Project{Name: "acme", UserID: 1}).Error)
	// Same name, different user: allowed.
	assert.NoError(t, db.Create(&Project{Name: "acme", UserID: 2}).Error)

	require.NoError(t, db.Create(&Tag{Name: "billable", UserID: 1}).Error)
	assert.Error(t, db.Create(&Tag{Name: "billable", UserID: 1}).Error)
	assert.NoError(t, db.Create(&Tag{Name: "billable", UserID: 2}).Error)
}

func TestTaskNameIsUniquePerProject(t *testing.T) {
	db := newTestDB(t)

	projectA := Project{Name: "a", UserID: 1}
	projectB := Project{Name: "b", UserID: 1}
	require.NoError(t, db.Create(&projectA).Error)
	require.NoError(t, db.Create(&projectB).Error)

	require.NoError(t, db.Create(&Task{Name: "review", ProjectID: projectA.ID, UserID: 1}).Error)
	assert.Error(t, db.Create(&Task{Name: "review", ProjectID: projectA.ID, UserID: 1}).Error)
	// The same task name under a different project is a different task.
	assert.NoError(t, db.Create(&Task{Name: "review", ProjectID: projectB.ID, UserID: 1}).Error)
}

func TestTimeEntryIsRunning(t *testing.T) {
	end := time.Now()
	assert.True(t, TimeEntry{}.IsRunning())
	assert.False(t, TimeEntry{EndTime: &end}.IsRunning())
}

func TestTimeEntryElapsedSeconds(t *testing.T) {
	now := time.Date(2026, 8, 7, 12, 0, 0, 0, time.UTC)
	stored := int64(120)

	testCases := []struct {
		name     string
		entry    TimeEntry
		expected int64
	}{
		{
			name:     "closed entry uses the stored duration",
			entry:    TimeEntry{DurationSeconds: &stored, StartTime: now.Add(-time.Hour)},
			expected: 120,
		},
		{
			name:     "running entry is measured against now",
			entry:    TimeEntry{StartTime: now.Add(-90 * time.Second)},
			expected: 90,
		},
		{
			name:     "a start time in the future clamps to zero",
			entry:    TimeEntry{StartTime: now.Add(time.Hour)},
			expected: 0,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.expected, tc.entry.ElapsedSeconds(now))
		})
	}
}
