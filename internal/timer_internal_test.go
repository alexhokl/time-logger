package internal

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

func TestStartTimerCreatesARunningEntry(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	resp, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{
		Description: "writing tests",
		ProjectId:   projectID,
		Tags:        []string{"Billable", "billable", " focus "},
	})
	require.NoError(t, err)

	entry := resp.GetEntry()
	assert.True(t, entry.GetRunning())
	assert.Nil(t, entry.EndTime)
	assert.Equal(t, "writing tests", entry.GetDescription())
	assert.Equal(t, projectID, entry.GetProjectId())
	// Tag names are normalised and de-duplicated.
	assert.Equal(t, []string{"billable", "focus"}, entry.GetTags())
	assert.True(t, fixedNow.Equal(entry.GetStartTime().AsTime()))
}

func TestStartTimerRejectsASecondTimer(t *testing.T) {
	f := newFixtures(t)

	_, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{Description: "first"})
	require.NoError(t, err)

	_, err = f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{Description: "second"})
	assertStatusCode(t, err, codes.FailedPrecondition)

	// The original timer is untouched.
	running, err := f.timer.GetRunningTimer(authContext(), &timeloggerv1.GetRunningTimerRequest{})
	require.NoError(t, err)
	assert.Equal(t, "first", running.GetEntry().GetDescription())
}

func TestStartTimerRejectsAFutureStart(t *testing.T) {
	f := newFixtures(t)

	_, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{
		StartTime: timestampOf(fixedNow.Add(time.Hour)),
	})
	assertStatusCode(t, err, codes.InvalidArgument)
}

func TestStartTimerAllowsBackdating(t *testing.T) {
	f := newFixtures(t)

	backdated := fixedNow.Add(-2 * time.Hour)
	resp, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{
		StartTime: timestampOf(backdated),
	})
	require.NoError(t, err)

	assert.True(t, backdated.Equal(resp.GetEntry().GetStartTime().AsTime()))
	// A running entry reports elapsed time measured against the pinned clock.
	assert.Equal(t, int64(7200), resp.GetEntry().GetDurationSeconds())
}

func TestStopTimerClosesTheEntry(t *testing.T) {
	f := newFixtures(t)

	_, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{
		Description: "work",
		StartTime:   timestampOf(fixedNow.Add(-30 * time.Minute)),
	})
	require.NoError(t, err)

	resp, err := f.timer.StopTimer(authContext(), &timeloggerv1.StopTimerRequest{})
	require.NoError(t, err)

	entry := resp.GetEntry()
	assert.False(t, entry.GetRunning())
	require.NotNil(t, entry.EndTime)
	assert.True(t, fixedNow.Equal(entry.GetEndTime().AsTime()))
	assert.Equal(t, int64(1800), entry.GetDurationSeconds())

	// The slot is free again.
	_, err = f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{Description: "next"})
	assert.NoError(t, err)
}

func TestStopTimerCanRenameTheEntry(t *testing.T) {
	f := newFixtures(t)

	_, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{Description: ""})
	require.NoError(t, err)

	named := "figured out what I was doing"
	resp, err := f.timer.StopTimer(authContext(), &timeloggerv1.StopTimerRequest{Description: &named})
	require.NoError(t, err)

	assert.Equal(t, named, resp.GetEntry().GetDescription())
}

func TestStopTimerRejectsAnEndBeforeTheStart(t *testing.T) {
	f := newFixtures(t)

	_, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{})
	require.NoError(t, err)

	_, err = f.timer.StopTimer(authContext(), &timeloggerv1.StopTimerRequest{
		EndTime: timestampOf(fixedNow.Add(-time.Hour)),
	})
	assertStatusCode(t, err, codes.InvalidArgument)
}

func TestStopTimerWithoutARunningTimerFails(t *testing.T) {
	f := newFixtures(t)

	_, err := f.timer.StopTimer(authContext(), &timeloggerv1.StopTimerRequest{})
	assertStatusCode(t, err, codes.FailedPrecondition)
}

func TestGetRunningTimerReturnsEmptyRatherThanNotFound(t *testing.T) {
	f := newFixtures(t)

	// The absence of a timer is a normal state, so clients polling this must
	// not have to treat an error as routine.
	resp, err := f.timer.GetRunningTimer(authContext(), &timeloggerv1.GetRunningTimerRequest{})
	require.NoError(t, err)
	assert.Nil(t, resp.Entry)
}

func TestCancelRunningTimerDiscardsTheEntry(t *testing.T) {
	f := newFixtures(t)

	_, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{Description: "mistake"})
	require.NoError(t, err)

	_, err = f.timer.CancelRunningTimer(authContext(), &timeloggerv1.CancelRunningTimerRequest{})
	require.NoError(t, err)

	running, err := f.timer.GetRunningTimer(authContext(), &timeloggerv1.GetRunningTimerRequest{})
	require.NoError(t, err)
	assert.Nil(t, running.Entry)

	// The cancelled entry leaves no trace in listings.
	list, err := f.entry.ListEntries(authContext(), &timeloggerv1.ListEntriesRequest{})
	require.NoError(t, err)
	assert.Empty(t, list.GetEntries())

	// And a new timer can start immediately.
	_, err = f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{Description: "for real"})
	assert.NoError(t, err)
}

func TestCancelWithoutARunningTimerFails(t *testing.T) {
	f := newFixtures(t)

	_, err := f.timer.CancelRunningTimer(authContext(), &timeloggerv1.CancelRunningTimerRequest{})
	assertStatusCode(t, err, codes.FailedPrecondition)
}

func TestRunningEntryIsExcludedFromReportTotals(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	f.mustEntry(t, projectID, fixedNow.Add(-3*time.Hour), time.Hour)

	_, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{
		ProjectId: projectID,
		StartTime: timestampOf(fixedNow.Add(-time.Hour)),
	})
	require.NoError(t, err)

	// A running entry has no final duration, so counting it would make the
	// same report return a different total on every call.
	resp, err := f.report.GetDailyReport(authContext(), &timeloggerv1.GetDailyReportRequest{})
	require.NoError(t, err)
	assert.Equal(t, int64(3600), resp.GetReport().GetTotalSeconds())
	assert.Equal(t, int64(1), resp.GetReport().GetEntryCount())
}
