package internal

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

func TestCreateProjectRejectsADuplicateName(t *testing.T) {
	f := newFixtures(t)
	f.mustProject(t, "acme")

	_, err := f.project.CreateProject(authContext(), &timeloggerv1.CreateProjectRequest{Name: "acme"})
	assertStatusCode(t, err, codes.AlreadyExists)
}

func TestCreateProjectRejectsABlankName(t *testing.T) {
	f := newFixtures(t)

	_, err := f.project.CreateProject(authContext(), &timeloggerv1.CreateProjectRequest{Name: "   "})
	assertStatusCode(t, err, codes.InvalidArgument)
}

func TestDeleteProjectRefusesWhenEntriesExist(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	f.mustEntry(t, projectID, fixedNow.Add(-time.Hour), time.Hour)

	// Cascading would destroy history the user cannot reconstruct, so the
	// server refuses and points at archiving instead.
	_, err := f.project.DeleteProject(authContext(), &timeloggerv1.DeleteProjectRequest{Id: projectID})
	assertStatusCode(t, err, codes.FailedPrecondition)
	assert.Contains(t, err.Error(), "archive")

	list, err := f.entry.ListEntries(authContext(), &timeloggerv1.ListEntriesRequest{})
	require.NoError(t, err)
	assert.Len(t, list.GetEntries(), 1)
}

func TestDeleteProjectSucceedsWhenUnused(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	_, err := f.project.DeleteProject(authContext(), &timeloggerv1.DeleteProjectRequest{Id: projectID})
	require.NoError(t, err)

	_, err = f.project.GetProject(authContext(), &timeloggerv1.GetProjectRequest{Id: projectID})
	assertStatusCode(t, err, codes.NotFound)
}

func TestArchivedProjectsAreHiddenByDefault(t *testing.T) {
	f := newFixtures(t)
	active := f.mustProject(t, "active")
	archived := f.mustProject(t, "archived")

	_, err := f.project.SetProjectArchived(authContext(), &timeloggerv1.SetProjectArchivedRequest{
		Id:       archived,
		Archived: true,
	})
	require.NoError(t, err)

	resp, err := f.project.ListProjects(authContext(), &timeloggerv1.ListProjectsRequest{})
	require.NoError(t, err)
	require.Len(t, resp.GetProjects(), 1)
	assert.Equal(t, active, resp.GetProjects()[0].GetId())

	resp, err = f.project.ListProjects(authContext(), &timeloggerv1.ListProjectsRequest{
		IncludeArchived: true,
	})
	require.NoError(t, err)
	assert.Len(t, resp.GetProjects(), 2)
}

func TestProjectStatsAreOptIn(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	f.mustEntry(t, projectID, fixedNow.Add(-3*time.Hour), 2*time.Hour)

	resp, err := f.project.GetProject(authContext(), &timeloggerv1.GetProjectRequest{Id: projectID})
	require.NoError(t, err)
	assert.Zero(t, resp.GetProject().GetTotalSeconds())

	resp, err = f.project.GetProject(authContext(), &timeloggerv1.GetProjectRequest{
		Id:           projectID,
		IncludeStats: true,
	})
	require.NoError(t, err)
	assert.Equal(t, int64(7200), resp.GetProject().GetTotalSeconds())
	assert.Equal(t, int64(1), resp.GetProject().GetEntryCount())
}

func TestDeleteTaskDetachesItsEntries(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	taskID := f.mustTask(t, projectID, "review")

	seconds := int64(3600)
	created, err := f.entry.CreateEntry(authContext(), &timeloggerv1.CreateEntryRequest{
		TaskId: taskID,
		Time:   &timeloggerv1.TimeSpec{DurationSeconds: &seconds},
	})
	require.NoError(t, err)

	_, err = f.task.DeleteTask(authContext(), &timeloggerv1.DeleteTaskRequest{Id: taskID})
	require.NoError(t, err)

	// The entry keeps its time and project, losing only the finer label.
	resp, err := f.entry.GetEntry(authContext(), &timeloggerv1.GetEntryRequest{
		Id: created.GetEntry().GetId(),
	})
	require.NoError(t, err)
	assert.Zero(t, resp.GetEntry().GetTaskId())
	assert.Equal(t, projectID, resp.GetEntry().GetProjectId())
	assert.Equal(t, seconds, resp.GetEntry().GetDurationSeconds())
}

func TestMovingATaskMovesItsEntries(t *testing.T) {
	f := newFixtures(t)
	projectA := f.mustProject(t, "alpha")
	projectB := f.mustProject(t, "beta")
	taskID := f.mustTask(t, projectA, "review")

	seconds := int64(3600)
	created, err := f.entry.CreateEntry(authContext(), &timeloggerv1.CreateEntryRequest{
		TaskId: taskID,
		Time:   &timeloggerv1.TimeSpec{DurationSeconds: &seconds},
	})
	require.NoError(t, err)

	_, err = f.task.UpdateTask(authContext(), &timeloggerv1.UpdateTaskRequest{
		Id:         taskID,
		UpdateMask: []string{"project_id"},
		ProjectId:  projectB,
	})
	require.NoError(t, err)

	// Leaving the entry behind would make its project and task disagree.
	resp, err := f.entry.GetEntry(authContext(), &timeloggerv1.GetEntryRequest{
		Id: created.GetEntry().GetId(),
	})
	require.NoError(t, err)
	assert.Equal(t, projectB, resp.GetEntry().GetProjectId())
	assert.Equal(t, taskID, resp.GetEntry().GetTaskId())
}

func TestRenameTagPropagatesToEntries(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	created := f.mustEntry(t, projectID, fixedNow.Add(-time.Hour), time.Hour, "billable")

	tags, err := f.tag.ListTags(authContext(), &timeloggerv1.ListTagsRequest{})
	require.NoError(t, err)
	require.Len(t, tags.GetTags(), 1)

	_, err = f.tag.RenameTag(authContext(), &timeloggerv1.RenameTagRequest{
		Id:   tags.GetTags()[0].GetId(),
		Name: "Chargeable",
	})
	require.NoError(t, err)

	// The join table means every entry follows the rename with no rewrite.
	resp, err := f.entry.GetEntry(authContext(), &timeloggerv1.GetEntryRequest{Id: created.GetId()})
	require.NoError(t, err)
	assert.Equal(t, []string{"chargeable"}, resp.GetEntry().GetTags())
}

func TestDeleteTagKeepsTheEntry(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")
	created := f.mustEntry(t, projectID, fixedNow.Add(-time.Hour), time.Hour, "billable", "urgent")

	tags, err := f.tag.ListTags(authContext(), &timeloggerv1.ListTagsRequest{})
	require.NoError(t, err)

	var billableID uint64
	for _, tag := range tags.GetTags() {
		if tag.GetName() == "billable" {
			billableID = tag.GetId()
		}
	}
	require.NotZero(t, billableID)

	_, err = f.tag.DeleteTag(authContext(), &timeloggerv1.DeleteTagRequest{Id: billableID})
	require.NoError(t, err)

	resp, err := f.entry.GetEntry(authContext(), &timeloggerv1.GetEntryRequest{Id: created.GetId()})
	require.NoError(t, err)
	assert.Equal(t, []string{"urgent"}, resp.GetEntry().GetTags())
	assert.Equal(t, int64(3600), resp.GetEntry().GetDurationSeconds())
}

func TestSettingsDefaultsAreMaterialised(t *testing.T) {
	f := newFixtures(t)

	// Reading settings for a user who has never saved any must return the
	// values the server is actually applying, not an empty message.
	resp, err := f.setting.GetSettings(authContext(), &timeloggerv1.GetSettingsRequest{})
	require.NoError(t, err)

	assert.Equal(t, DefaultTimezone, resp.GetSettings().GetTimezone())
	assert.Equal(t, timeloggerv1.DayOfWeek_DAY_OF_WEEK_MONDAY, resp.GetSettings().GetWeekStartsOn())
	assert.Zero(t, resp.GetSettings().GetRoundingMinutes())
}

func TestUpdateSettingsRejectsAnUnknownTimezone(t *testing.T) {
	f := newFixtures(t)

	// Storing an unresolvable zone would shift every later report by an
	// unpredictable amount with no obvious cause.
	_, err := f.setting.UpdateSettings(authContext(), &timeloggerv1.UpdateSettingsRequest{
		UpdateMask: []string{"timezone"},
		Settings:   &timeloggerv1.Settings{Timezone: "Mars/Olympus_Mons"},
	})
	assertStatusCode(t, err, codes.InvalidArgument)

	resp, err := f.setting.GetSettings(authContext(), &timeloggerv1.GetSettingsRequest{})
	require.NoError(t, err)
	assert.Equal(t, DefaultTimezone, resp.GetSettings().GetTimezone())
}

func TestUpdateSettingsRejectsAnUnknownDefaultProject(t *testing.T) {
	f := newFixtures(t)

	_, err := f.setting.UpdateSettings(authContext(), &timeloggerv1.UpdateSettingsRequest{
		UpdateMask: []string{"default_project_id"},
		Settings:   &timeloggerv1.Settings{DefaultProjectId: 9999},
	})
	assertStatusCode(t, err, codes.NotFound)
}

func TestDeletingTheDefaultProjectClearsTheSetting(t *testing.T) {
	f := newFixtures(t)
	projectID := f.mustProject(t, "acme")

	_, err := f.setting.UpdateSettings(authContext(), &timeloggerv1.UpdateSettingsRequest{
		UpdateMask: []string{"default_project_id"},
		Settings:   &timeloggerv1.Settings{DefaultProjectId: projectID},
	})
	require.NoError(t, err)

	_, err = f.project.DeleteProject(authContext(), &timeloggerv1.DeleteProjectRequest{Id: projectID})
	require.NoError(t, err)

	// Leaving a dangling default would break every client that pre-selects it.
	resp, err := f.setting.GetSettings(authContext(), &timeloggerv1.GetSettingsRequest{})
	require.NoError(t, err)
	assert.Zero(t, resp.GetSettings().GetDefaultProjectId())
}

func TestPageSizeIsClamped(t *testing.T) {
	testCases := []struct {
		name           string
		request        *timeloggerv1.PageRequest
		expectedLimit  int
		expectedOffset int
	}{
		{name: "nil uses the default", request: nil, expectedLimit: defaultPageSize},
		{
			name:          "zero means the default rather than nothing",
			request:       &timeloggerv1.PageRequest{PageSize: 0},
			expectedLimit: defaultPageSize,
		},
		{
			name:          "an oversized page is clamped",
			request:       &timeloggerv1.PageRequest{PageSize: 100000},
			expectedLimit: maxPageSize,
		},
		{
			name:           "an explicit page is honoured",
			request:        &timeloggerv1.PageRequest{PageSize: 25, Offset: 50},
			expectedLimit:  25,
			expectedOffset: 50,
		},
		{
			name:          "a negative offset is ignored",
			request:       &timeloggerv1.PageRequest{PageSize: 10, Offset: -5},
			expectedLimit: 10,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			limit, offset := normalisePage(tc.request)
			assert.Equal(t, tc.expectedLimit, limit)
			assert.Equal(t, tc.expectedOffset, offset)
		})
	}
}

func TestFieldMask(t *testing.T) {
	t.Run("an empty mask applies everything", func(t *testing.T) {
		mask := newFieldMask(nil)
		assert.True(t, mask.has("anything"))
		assert.False(t, mask.explicit())
	})

	t.Run("a mask of only blanks applies everything", func(t *testing.T) {
		assert.True(t, newFieldMask([]string{"", "  "}).has("anything"))
	})

	t.Run("an explicit mask is authoritative and case-insensitive", func(t *testing.T) {
		mask := newFieldMask([]string{"Name", " color "})
		assert.True(t, mask.has("name"))
		assert.True(t, mask.has("color"))
		assert.False(t, mask.has("archived"))
		assert.True(t, mask.explicit())
	})
}
