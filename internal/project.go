package internal

import (
	"context"
	"errors"
	"strings"

	"gorm.io/gorm"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// ProjectService implements the gRPC service of the same name.
type ProjectService struct {
	timeloggerv1.UnimplementedProjectServiceServer
	base
}

// NewProjectService constructs the handler with its database dependency.
func NewProjectService(db *gorm.DB) *ProjectService {
	return &ProjectService{base: base{db: db}}
}

func (s *ProjectService) CreateProject(
	ctx context.Context,
	req *timeloggerv1.CreateProjectRequest,
) (*timeloggerv1.CreateProjectResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	name := strings.TrimSpace(req.GetName())
	if name == "" {
		return nil, toStatusError(invalid("name is required"))
	}

	ctx, span := startSpan(ctx, "db.create_project")
	defer span.End()

	project := database.Project{
		Name:   name,
		Color:  strings.TrimSpace(req.GetColor()),
		UserID: user.UserID,
	}
	if err := s.db.WithContext(ctx).Create(&project).Error; err != nil {
		recordSpanError(span, err)
		if isUniqueViolation(err) {
			return nil, toStatusError(ErrProjectAlreadyExists{Name: name})
		}
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	return &timeloggerv1.CreateProjectResponse{
		Project: toProtoProject(project, entryStats{}),
	}, nil
}

func (s *ProjectService) ListProjects(
	ctx context.Context,
	req *timeloggerv1.ListProjectsRequest,
) (*timeloggerv1.ListProjectsResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	ctx, span := startSpan(ctx, "db.list_projects")
	defer span.End()

	query := s.db.WithContext(ctx).Model(&database.Project{}).Where("user_id = ?", user.UserID)
	if !req.GetIncludeArchived() {
		query = query.Where("archived = ?", false)
	}

	var total int64
	if err := query.Count(&total).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}

	limit, offset := normalisePage(req.GetPage())

	var projects []database.Project
	if err := query.Order("name ASC").Limit(limit).Offset(offset).Find(&projects).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}

	stats := map[uint]entryStats{}
	if req.GetIncludeStats() {
		stats, err = s.projectStats(ctx, user.UserID, projectIDs(projects))
		if err != nil {
			recordSpanError(span, err)
			return nil, toStatusError(err)
		}
	}
	endSpanOk(span)

	out := make([]*timeloggerv1.Project, 0, len(projects))
	for _, p := range projects {
		out = append(out, toProtoProject(p, stats[p.ID]))
	}

	recordRecordsReturned(ctx, "ListProjects", "project", len(out))

	return &timeloggerv1.ListProjectsResponse{
		Projects: out,
		Page:     pageResponse(total, offset, len(out)),
	}, nil
}

func (s *ProjectService) GetProject(
	ctx context.Context,
	req *timeloggerv1.GetProjectRequest,
) (*timeloggerv1.GetProjectResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	project, err := s.findProject(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	stats := entryStats{}
	if req.GetIncludeStats() {
		all, err := s.projectStats(ctx, user.UserID, []uint{project.ID})
		if err != nil {
			return nil, toStatusError(err)
		}
		stats = all[project.ID]
	}

	return &timeloggerv1.GetProjectResponse{Project: toProtoProject(*project, stats)}, nil
}

func (s *ProjectService) UpdateProject(
	ctx context.Context,
	req *timeloggerv1.UpdateProjectRequest,
) (*timeloggerv1.UpdateProjectResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	project, err := s.findProject(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	// An empty mask means "apply every field the caller sent", which keeps the
	// CLI simple; an explicit mask lets a client clear a field by omitting its
	// value while still naming it.
	mask := newFieldMask(req.GetUpdateMask())
	updates := map[string]any{}

	if mask.has("name") {
		name := strings.TrimSpace(req.GetName())
		if name == "" {
			return nil, toStatusError(invalid("name cannot be empty"))
		}
		updates["name"] = name
	}
	if mask.has("color") {
		updates["color"] = strings.TrimSpace(req.GetColor())
	}

	if len(updates) == 0 {
		return &timeloggerv1.UpdateProjectResponse{Project: toProtoProject(*project, entryStats{})}, nil
	}

	ctx, span := startSpan(ctx, "db.update_project")
	defer span.End()

	if err := s.db.WithContext(ctx).Model(project).Updates(updates).Error; err != nil {
		recordSpanError(span, err)
		if isUniqueViolation(err) {
			return nil, toStatusError(ErrProjectAlreadyExists{Name: req.GetName()})
		}
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	return &timeloggerv1.UpdateProjectResponse{Project: toProtoProject(*project, entryStats{})}, nil
}

// DeleteProject removes a project that has no tracked time against it.
//
// A project with entries is refused rather than cascaded: the entries carry the
// user's history and silently deleting or orphaning them would lose data the
// user cannot recover. SetProjectArchived is the intended alternative, and the
// error message says so.
func (s *ProjectService) DeleteProject(
	ctx context.Context,
	req *timeloggerv1.DeleteProjectRequest,
) (*timeloggerv1.DeleteProjectResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	project, err := s.findProject(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.delete_project")
	defer span.End()

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var entryCount int64
		if err := tx.Model(&database.TimeEntry{}).
			Where("user_id = ? AND project_id = ?", user.UserID, project.ID).
			Count(&entryCount).Error; err != nil {
			return err
		}
		if entryCount > 0 {
			return ErrProjectHasEntries{Name: project.Name, Count: entryCount}
		}

		// Tasks under the project have no entries either (an entry referencing
		// a task also references its project), so they can go with it.
		if err := tx.Where("user_id = ? AND project_id = ?", user.UserID, project.ID).
			Delete(&database.Task{}).Error; err != nil {
			return err
		}

		// Drop the project from any settings row pointing at it, otherwise the
		// user's default would dangle.
		if err := tx.Model(&database.UserSetting{}).
			Where("user_id = ? AND default_project_id = ?", user.UserID, project.ID).
			Update("default_project_id", nil).Error; err != nil {
			return err
		}

		return tx.Delete(project).Error
	})
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	// The settings cache may now hold a stale default project.
	resetSettingsCacheFor(user.UserID)

	return &timeloggerv1.DeleteProjectResponse{}, nil
}

func (s *ProjectService) SetProjectArchived(
	ctx context.Context,
	req *timeloggerv1.SetProjectArchivedRequest,
) (*timeloggerv1.SetProjectArchivedResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	project, err := s.findProject(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.set_project_archived")
	defer span.End()

	if err := s.db.WithContext(ctx).Model(project).
		Update("archived", req.GetArchived()).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	return &timeloggerv1.SetProjectArchivedResponse{
		Project: toProtoProject(*project, entryStats{}),
	}, nil
}

// findProject loads a project scoped to the user, so that a request naming
// another user's project is indistinguishable from one naming a project that
// does not exist.
func (s *ProjectService) findProject(ctx context.Context, userID uint, id uint64) (*database.Project, error) {
	if id == 0 {
		return nil, gorm.ErrRecordNotFound
	}
	var project database.Project
	if err := s.db.WithContext(ctx).
		Where("id = ? AND user_id = ?", id, userID).
		First(&project).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, gorm.ErrRecordNotFound
		}
		return nil, err
	}
	return &project, nil
}

// projectStats aggregates entry counts and tracked seconds per project in a
// single grouped query, rather than one query per project.
//
// Running entries contribute no seconds because their duration is not yet
// known; they are still counted, so a project with only a running timer does
// not appear entirely empty.
func (s *ProjectService) projectStats(ctx context.Context, userID uint, ids []uint) (map[uint]entryStats, error) {
	stats := map[uint]entryStats{}
	if len(ids) == 0 {
		return stats, nil
	}

	var rows []struct {
		ProjectID    uint
		EntryCount   int64
		TotalSeconds int64
	}
	if err := s.db.WithContext(ctx).
		Model(&database.TimeEntry{}).
		Select("project_id, COUNT(*) AS entry_count, COALESCE(SUM(duration_seconds), 0) AS total_seconds").
		Where("user_id = ? AND project_id IN ?", userID, ids).
		Group("project_id").
		Scan(&rows).Error; err != nil {
		return nil, err
	}

	for _, r := range rows {
		stats[r.ProjectID] = entryStats{EntryCount: r.EntryCount, TotalSeconds: r.TotalSeconds}
	}
	return stats, nil
}

func projectIDs(projects []database.Project) []uint {
	ids := make([]uint, 0, len(projects))
	for _, p := range projects {
		ids = append(ids, p.ID)
	}
	return ids
}
