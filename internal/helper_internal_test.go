package internal

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// testUserID is the user every handler test operates as.
const testUserID uint = 1

// fixedNow pins the clock so that report windows and elapsed durations are
// deterministic. It is a Friday, chosen so week boundaries are non-trivial.
var fixedNow = time.Date(2026, 8, 7, 12, 0, 0, 0, time.UTC)

// newHandlerTestDB returns a migrated in-memory database seeded with the test
// user, and clears the process-wide settings cache so cases cannot leak into
// each other.
func newHandlerTestDB(t *testing.T) *gorm.DB {
	t.Helper()

	db, err := gorm.Open(sqlite.Open("file::memory:"), &gorm.Config{
		Logger:                                   logger.Default.LogMode(logger.Silent),
		TranslateError:                           true,
		DisableForeignKeyConstraintWhenMigrating: true,
	})
	require.NoError(t, err)
	require.NoError(t, database.AutoMigrate(db))
	require.NoError(t, db.Create(&database.User{Username: "test@example.com"}).Error)

	resetSettingsCache()
	t.Cleanup(resetSettingsCache)

	return db
}

// authContext returns a context carrying the test user, as an authentication
// interceptor would have set it up.
func authContext() context.Context {
	return withUserID(context.Background(), testUserID)
}

// clockOf returns a clock function pinned to fixedNow.
func clockOf(t time.Time) func() time.Time {
	return func() time.Time { return t }
}

// assertStatusCode fails unless err carries the expected gRPC code.
func assertStatusCode(t *testing.T, err error, expected codes.Code) {
	t.Helper()
	require.Error(t, err)
	require.Equalf(t, expected, status.Code(err),
		"expected %s but got %s: %v", expected, status.Code(err), err)
}

// --- Fixture builders -------------------------------------------------------

type fixtures struct {
	db      *gorm.DB
	project *ProjectService
	task    *TaskService
	tag     *TagService
	entry   *TimeEntryService
	timer   *TimerService
	goal    *GoalService
	report  *ReportService
	setting *SettingsService
}

// newFixtures wires every service against one database with a pinned clock.
func newFixtures(t *testing.T) *fixtures {
	t.Helper()
	db := newHandlerTestDB(t)
	clock := clockOf(fixedNow)

	return &fixtures{
		db:      db,
		project: &ProjectService{base: base{db: db, now: clock}},
		task:    &TaskService{base: base{db: db, now: clock}},
		tag:     &TagService{base: base{db: db, now: clock}},
		entry:   &TimeEntryService{base: base{db: db, now: clock}},
		timer:   &TimerService{base: base{db: db, now: clock}},
		goal:    &GoalService{base: base{db: db, now: clock}},
		report:  &ReportService{base: base{db: db, now: clock}},
		setting: &SettingsService{base: base{db: db, now: clock}},
	}
}

// mustProject creates a project and returns its ID.
func (f *fixtures) mustProject(t *testing.T, name string) uint64 {
	t.Helper()
	resp, err := f.project.CreateProject(authContext(), &timeloggerv1.CreateProjectRequest{Name: name})
	require.NoError(t, err)
	return resp.GetProject().GetId()
}

// mustTask creates a task under a project and returns its ID.
func (f *fixtures) mustTask(t *testing.T, projectID uint64, name string) uint64 {
	t.Helper()
	resp, err := f.task.CreateTask(authContext(), &timeloggerv1.CreateTaskRequest{
		Name:      name,
		ProjectId: projectID,
	})
	require.NoError(t, err)
	return resp.GetTask().GetId()
}

// mustEntry creates a completed entry starting at the given instant.
func (f *fixtures) mustEntry(
	t *testing.T,
	projectID uint64,
	start time.Time,
	duration time.Duration,
	tags ...string,
) *timeloggerv1.TimeEntry {
	t.Helper()
	seconds := int64(duration.Seconds())
	resp, err := f.entry.CreateEntry(authContext(), &timeloggerv1.CreateEntryRequest{
		Description: "work",
		ProjectId:   projectID,
		Tags:        tags,
		Time: &timeloggerv1.TimeSpec{
			StartTime:       timestampOf(start),
			DurationSeconds: &seconds,
		},
	})
	require.NoError(t, err)
	return resp.GetEntry()
}

// mustSetTimezone updates the test user's timezone.
func (f *fixtures) mustSetTimezone(t *testing.T, tz string) {
	t.Helper()
	_, err := f.setting.UpdateSettings(authContext(), &timeloggerv1.UpdateSettingsRequest{
		UpdateMask: []string{"timezone"},
		Settings:   &timeloggerv1.Settings{Timezone: tz},
	})
	require.NoError(t, err)
}
