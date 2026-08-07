package internal

import (
	"sort"
	"time"

	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// entryStats holds the aggregate counters optionally attached to a project,
// task or tag by the List and Get RPCs.
type entryStats struct {
	EntryCount   int64
	TotalSeconds int64
}

func toProtoProject(p database.Project, stats entryStats) *timeloggerv1.Project {
	return &timeloggerv1.Project{
		Id:           uint64(p.ID),
		Name:         p.Name,
		Color:        p.Color,
		Archived:     p.Archived,
		EntryCount:   stats.EntryCount,
		TotalSeconds: stats.TotalSeconds,
	}
}

func toProtoTask(t database.Task, stats entryStats) *timeloggerv1.Task {
	task := &timeloggerv1.Task{
		Id:           uint64(t.ID),
		Name:         t.Name,
		ProjectId:    uint64(t.ProjectID),
		Archived:     t.Archived,
		EntryCount:   stats.EntryCount,
		TotalSeconds: stats.TotalSeconds,
	}
	if t.Project != nil {
		task.ProjectName = t.Project.Name
	}
	return task
}

func toProtoTag(t database.Tag, stats entryStats) *timeloggerv1.Tag {
	return &timeloggerv1.Tag{
		Id:           uint64(t.ID),
		Name:         t.Name,
		EntryCount:   stats.EntryCount,
		TotalSeconds: stats.TotalSeconds,
	}
}

// toProtoEntry converts a stored entry into its wire representation.
//
// now is required because a running entry has no stored duration; its elapsed
// time is computed against the moment the response is built. roundingMinutes
// applies the user's reporting preference without touching what is stored.
func toProtoEntry(e database.TimeEntry, now time.Time, roundingMinutes int) *timeloggerv1.TimeEntry {
	entry := &timeloggerv1.TimeEntry{
		Id:              uint64(e.ID),
		Description:     e.Description,
		StartTime:       timestamppb.New(e.StartTime),
		DurationSeconds: roundUpSeconds(e.ElapsedSeconds(now), roundingMinutes),
		Running:         e.IsRunning(),
		Tags:            tagNames(e.Tags),
		CreatedAt:       timestamppb.New(e.CreatedAt),
		UpdatedAt:       timestamppb.New(e.UpdatedAt),
	}

	if e.EndTime != nil {
		entry.EndTime = timestamppb.New(*e.EndTime)
	}
	if e.ProjectID != nil {
		entry.ProjectId = uint64(*e.ProjectID)
	}
	if e.Project != nil {
		entry.ProjectName = e.Project.Name
	}
	if e.TaskID != nil {
		entry.TaskId = uint64(*e.TaskID)
	}
	if e.Task != nil {
		entry.TaskName = e.Task.Name
	}

	return entry
}

// tagNames extracts and sorts the names of an entry's tags. Sorting makes the
// output deterministic, which matters for the CLI's text and CSV formats and
// for tests.
func tagNames(tags []database.Tag) []string {
	if len(tags) == 0 {
		return nil
	}
	names := make([]string, 0, len(tags))
	for _, t := range tags {
		names = append(names, t.Name)
	}
	sort.Strings(names)
	return names
}

func toProtoGoal(g database.Goal, loc *time.Location) *timeloggerv1.Goal {
	goal := &timeloggerv1.Goal{
		Id:          uint64(g.ID),
		TargetHours: float64(g.TargetSeconds) / 3600,
		Period:      periodToProto(g.Period),
		StartDate:   dateFromTime(g.StartDate.In(loc)),
	}

	if g.ProjectID != nil {
		goal.ProjectId = uint64(*g.ProjectID)
	}
	if g.Project != nil {
		goal.ProjectName = g.Project.Name
	}
	if g.TaskID != nil {
		goal.TaskId = uint64(*g.TaskID)
	}
	if g.Task != nil {
		goal.TaskName = g.Task.Name
	}
	if g.EndDate != nil {
		goal.EndDate = dateFromTime(g.EndDate.In(loc))
	}

	return goal
}

func toProtoSettings(s database.UserSetting, projectName string) *timeloggerv1.Settings {
	settings := &timeloggerv1.Settings{
		Timezone:        s.Timezone,
		WeekStartsOn:    timeloggerv1.DayOfWeek(s.WeekStartsOn),
		RoundingMinutes: int32(s.RoundingMinutes),
	}
	if s.DefaultProjectID != nil {
		settings.DefaultProjectId = uint64(*s.DefaultProjectID)
		settings.DefaultProjectName = projectName
	}
	return settings
}

// uintPtr converts a proto uint64 identifier into the nullable uint the models
// use. Zero is the proto convention for "unset" and maps to nil.
func uintPtr(id uint64) *uint {
	if id == 0 {
		return nil
	}
	v := uint(id)
	return &v
}

// uintSlice converts a repeated uint64 filter field into the uint slice GORM
// expects for an IN clause.
func uintSlice(ids []uint64) []uint {
	if len(ids) == 0 {
		return nil
	}
	out := make([]uint, 0, len(ids))
	for _, id := range ids {
		if id != 0 {
			out = append(out, uint(id))
		}
	}
	return out
}

// timestampOf wraps an instant for embedding in a proto message. It exists so
// call sites do not need to import timestamppb just to build a one-field spec.
func timestampOf(t time.Time) *timestamppb.Timestamp {
	return timestamppb.New(t)
}
