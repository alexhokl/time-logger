package internal

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

func TestCreateEntryDerivesTheMissingField(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	start := fixedNow.Add(-2 * time.Hour)
	seconds := int64(5400)

	resp, err := f.entry.CreateEntry(authContext(), &timeloggerv1.CreateEntryRequest{
		Description: "design review",
		ProjectId:   projectID,
		Time: &timeloggerv1.TimeSpec{
			StartTime:       timestampOf(start),
			DurationSeconds: &seconds,
		},
	})
	require.NoError(t, err)

	entry := resp.GetEntry()
	assert.False(t, entry.GetRunning())
	require.NotNil(t, entry.EndTime)
	assert.True(t, start.Add(90*time.Minute).Equal(entry.GetEndTime().AsTime()))
	assert.Equal(t, seconds, entry.GetDurationSeconds())
}

func TestCreateEntryAdoptsTheTasksProject(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	taskID := f.mustTask(t, projectID, "review")

	seconds := int64(600)
	resp, err := f.entry.CreateEntry(authContext(), &timeloggerv1.CreateEntryRequest{
		// Only the task is named; the project should be inferred rather than
		// the request rejected.
		TaskId: taskID,
		Time:   &timeloggerv1.TimeSpec{DurationSeconds: &seconds},
	})
	require.NoError(t, err)

	assert.Equal(t, projectID, resp.GetEntry().GetProjectId())
	assert.Equal(t, taskID, resp.GetEntry().GetTaskId())
}

func TestCreateEntryRejectsAMismatchedTaskAndProject(t *testing.T) {
	f := newFixtures(t)
	projectA := f.mustProject(t, "acme")
	projectB := f.mustProject(t, "other")
	taskID := f.mustTask(t, projectA, "review")

	seconds := int64(600)
	_, err := f.entry.CreateEntry(authContext(), &timeloggerv1.CreateEntryRequest{
		ProjectId: projectB,
		TaskId:    taskID,
		Time:      &timeloggerv1.TimeSpec{DurationSeconds: &seconds},
	})
	assertStatusCode(t, err, codes.InvalidArgument)
}

func TestCreateEntryWithoutAProjectIsAllowed(t *testing.T) {
	f := newFixtures(t)

	seconds := int64(1800)
	resp, err := f.entry.CreateEntry(authContext(), &timeloggerv1.CreateEntryRequest{
		Description: "ad-hoc",
		Time:        &timeloggerv1.TimeSpec{DurationSeconds: &seconds},
	})
	require.NoError(t, err)
	assert.Zero(t, resp.GetEntry().GetProjectId())
}

func TestCreateEntryUsesTheUserTimezoneForDateOnlyInput(t *testing.T) {
	f := newFixtures(t)
	f.mustSetTimezone(t, "Asia/Hong_Kong")

	seconds := int64(3600)
	resp, err := f.entry.CreateEntry(authContext(), &timeloggerv1.CreateEntryRequest{
		Time: &timeloggerv1.TimeSpec{
			Date:            &timeloggerv1.Date{Year: 2026, Month: 8, Day: 7},
			DurationSeconds: &seconds,
		},
	})
	require.NoError(t, err)

	// Midnight in Hong Kong (UTC+8) is 16:00 UTC on the previous day.
	expected := time.Date(2026, 8, 6, 16, 0, 0, 0, time.UTC)
	assert.True(t, expected.Equal(resp.GetEntry().GetStartTime().AsTime()))
}

func TestCreateEntriesIsAtomic(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	seconds := int64(600)

	_, err := f.entry.CreateEntries(authContext(), &timeloggerv1.CreateEntriesRequest{
		Entries: []*timeloggerv1.CreateEntryRequest{
			{Description: "ok", ProjectId: projectID, Time: &timeloggerv1.TimeSpec{DurationSeconds: &seconds}},
			// A non-existent project must abort the whole batch.
			{Description: "bad", ProjectId: 9999, Time: &timeloggerv1.TimeSpec{DurationSeconds: &seconds}},
		},
	})
	require.Error(t, err)

	// A half-applied import would be much harder to reconcile than a clean
	// failure, so nothing at all should have been written.
	list, err := f.entry.ListEntries(authContext(), &timeloggerv1.ListEntriesRequest{})
	require.NoError(t, err)
	assert.Empty(t, list.GetEntries())
}

func TestListEntriesFiltersByTagConjunctively(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	f.mustEntry(t, projectID, fixedNow.Add(-5*time.Hour), time.Hour, "billable", "urgent")
	f.mustEntry(t, projectID, fixedNow.Add(-4*time.Hour), time.Hour, "billable")
	f.mustEntry(t, projectID, fixedNow.Add(-3*time.Hour), time.Hour, "urgent")

	resp, err := f.entry.ListEntries(authContext(), &timeloggerv1.ListEntriesRequest{
		Filter: &timeloggerv1.EntryFilter{Tags: []string{"billable", "urgent"}},
	})
	require.NoError(t, err)

	// Only the entry carrying both tags qualifies, and the duration is counted
	// once rather than once per matching tag.
	require.Len(t, resp.GetEntries(), 1)
	assert.Equal(t, int64(3600), resp.GetTotalSeconds())
}

func TestListEntriesReportsTotalsAcrossTheWholeFilter(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	for i := range 5 {
		f.mustEntry(t, projectID, fixedNow.Add(-time.Duration(i+1)*time.Hour), time.Hour)
	}

	resp, err := f.entry.ListEntries(authContext(), &timeloggerv1.ListEntriesRequest{
		Page: &timeloggerv1.PageRequest{PageSize: 2},
	})
	require.NoError(t, err)

	assert.Len(t, resp.GetEntries(), 2)
	assert.Equal(t, int64(5), resp.GetPage().GetTotalCount())
	assert.True(t, resp.GetPage().GetHasMore())
	// The total covers every matching entry, not just the returned page, so a
	// client can show "5h today" without fetching everything.
	assert.Equal(t, int64(5*3600), resp.GetTotalSeconds())
}

func TestListEntriesFiltersByRunningState(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	f.mustEntry(t, projectID, fixedNow.Add(-3*time.Hour), time.Hour)

	_, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{ProjectId: projectID})
	require.NoError(t, err)

	running := true
	resp, err := f.entry.ListEntries(authContext(), &timeloggerv1.ListEntriesRequest{
		Filter: &timeloggerv1.EntryFilter{Running: &running},
	})
	require.NoError(t, err)
	require.Len(t, resp.GetEntries(), 1)
	assert.True(t, resp.GetEntries()[0].GetRunning())

	running = false
	resp, err = f.entry.ListEntries(authContext(), &timeloggerv1.ListEntriesRequest{
		Filter: &timeloggerv1.EntryFilter{Running: &running},
	})
	require.NoError(t, err)
	require.Len(t, resp.GetEntries(), 1)
	assert.False(t, resp.GetEntries()[0].GetRunning())
}

func TestUpdateEntryDescriptionDoesNotResetTiming(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	created := f.mustEntry(t, projectID, fixedNow.Add(-2*time.Hour), time.Hour)

	resp, err := f.entry.UpdateEntry(authContext(), &timeloggerv1.UpdateEntryRequest{
		Id:          created.GetId(),
		UpdateMask:  []string{"description"},
		Description: "renamed",
	})
	require.NoError(t, err)

	// Updating an unrelated field must not silently convert a completed entry
	// into a running one.
	assert.Equal(t, "renamed", resp.GetEntry().GetDescription())
	assert.False(t, resp.GetEntry().GetRunning())
	assert.Equal(t, int64(3600), resp.GetEntry().GetDurationSeconds())
}

func TestUpdateEntryReplacesTagsWholesale(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	created := f.mustEntry(t, projectID, fixedNow.Add(-2*time.Hour), time.Hour, "old", "stale")

	resp, err := f.entry.UpdateEntry(authContext(), &timeloggerv1.UpdateEntryRequest{
		Id:         created.GetId(),
		UpdateMask: []string{"tags"},
		Tags:       []string{"fresh"},
	})
	require.NoError(t, err)

	assert.Equal(t, []string{"fresh"}, resp.GetEntry().GetTags())
}

func TestDeleteEntryRemovesItFromListings(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	created := f.mustEntry(t, projectID, fixedNow.Add(-2*time.Hour), time.Hour)

	_, err := f.entry.DeleteEntry(authContext(), &timeloggerv1.DeleteEntryRequest{Id: created.GetId()})
	require.NoError(t, err)

	_, err = f.entry.GetEntry(authContext(), &timeloggerv1.GetEntryRequest{Id: created.GetId()})
	assertStatusCode(t, err, codes.NotFound)
}

func TestCopyEntriesPreservesTimeOfDay(t *testing.T) {
	f := newFixtures(t)
	f.mustSetTimezone(t, "Asia/Hong_Kong")
	projectID := f.mustProject(t, "acme")

	// 09:30 Hong Kong time on 2026-08-05 is 01:30 UTC.
	source := f.mustEntry(t,
		projectID,
		time.Date(2026, 8, 5, 1, 30, 0, 0, time.UTC),
		90*time.Minute,
		"billable",
	)

	resp, err := f.entry.CopyEntries(authContext(), &timeloggerv1.CopyEntriesRequest{
		EntryIds:   []uint64{source.GetId()},
		TargetDate: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 10},
	})
	require.NoError(t, err)

	require.Len(t, resp.GetEntries(), 1)
	copied := resp.GetEntries()[0]

	hongKong, err := time.LoadLocation("Asia/Hong_Kong")
	require.NoError(t, err)
	local := copied.GetStartTime().AsTime().In(hongKong)

	assert.Equal(t, 2026, local.Year())
	assert.Equal(t, time.August, local.Month())
	assert.Equal(t, 10, local.Day())
	// The local wall-clock time of day is what the user recognises.
	assert.Equal(t, 9, local.Hour())
	assert.Equal(t, 30, local.Minute())
	assert.Equal(t, int64(5400), copied.GetDurationSeconds())
	assert.Equal(t, []string{"billable"}, copied.GetTags())
}

func TestCopyEntriesRefusesARunningEntry(t *testing.T) {
	f := newFixtures(t)

	started, err := f.timer.StartTimer(authContext(), &timeloggerv1.StartTimerRequest{})
	require.NoError(t, err)

	_, err = f.entry.CopyEntries(authContext(), &timeloggerv1.CopyEntriesRequest{
		EntryIds:   []uint64{started.GetEntry().GetId()},
		TargetDate: &timeloggerv1.Date{Year: 2026, Month: 8, Day: 10},
	})
	assertStatusCode(t, err, codes.InvalidArgument)
}

func TestEntriesAreScopedPerUser(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	created := f.mustEntry(t, projectID, fixedNow.Add(-time.Hour), time.Hour)

	// Another user must not be able to read the entry by guessing its id;
	// a scoped lookup makes "someone else's" indistinguishable from "absent".
	otherUser := withUserID(t.Context(), 2)
	_, err := f.entry.GetEntry(otherUser, &timeloggerv1.GetEntryRequest{Id: created.GetId()})
	assertStatusCode(t, err, codes.NotFound)
}

func TestUnauthenticatedRequestsAreRejected(t *testing.T) {
	f := newFixtures(t)

	// A request that bypassed the auth interceptor must fail closed.
	_, err := f.entry.ListEntries(t.Context(), &timeloggerv1.ListEntriesRequest{})
	assertStatusCode(t, err, codes.Unauthenticated)
}
