package internal

import (
	"context"
	"errors"
	"strings"

	"gorm.io/gorm"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// TaskService implements the gRPC service of the same name.
type TaskService struct {
	timeloggerv1.UnimplementedTaskServiceServer
	base
}

func NewTaskService(db *gorm.DB) *TaskService {
	return &TaskService{base: base{db: db}}
}

func (s *TaskService) CreateTask(
	ctx context.Context,
	req *timeloggerv1.CreateTaskRequest,
) (*timeloggerv1.CreateTaskResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	name := strings.TrimSpace(req.GetName())
	if name == "" {
		return nil, toStatusError(invalid("name is required"))
	}
	if req.GetProjectId() == 0 {
		return nil, toStatusError(invalid("project_id is required"))
	}

	project, err := findProjectByID(ctx, s.db, user.UserID, req.GetProjectId())
	if err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.create_task")
	defer span.End()

	task := database.Task{
		Name:      name,
		ProjectID: project.ID,
		UserID:    user.UserID,
	}
	if err := s.db.WithContext(ctx).Create(&task).Error; err != nil {
		recordSpanError(span, err)
		if isUniqueViolation(err) {
			return nil, toStatusError(ErrTaskAlreadyExists{Name: name, Project: project.Name})
		}
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	task.Project = project
	return &timeloggerv1.CreateTaskResponse{Task: toProtoTask(task, entryStats{})}, nil
}

func (s *TaskService) ListTasks(
	ctx context.Context,
	req *timeloggerv1.ListTasksRequest,
) (*timeloggerv1.ListTasksResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	ctx, span := startSpan(ctx, "db.list_tasks")
	defer span.End()

	query := s.db.WithContext(ctx).Model(&database.Task{}).Where("user_id = ?", user.UserID)
	if req.GetProjectId() != 0 {
		query = query.Where("project_id = ?", req.GetProjectId())
	}
	if !req.GetIncludeArchived() {
		query = query.Where("archived = ?", false)
	}

	var total int64
	if err := query.Count(&total).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}

	limit, offset := normalisePage(req.GetPage())

	var tasks []database.Task
	if err := query.Preload("Project").
		Order("name ASC").Limit(limit).Offset(offset).
		Find(&tasks).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}

	stats := map[uint]entryStats{}
	if req.GetIncludeStats() {
		stats, err = taskStats(ctx, s.db, user.UserID, taskIDs(tasks))
		if err != nil {
			recordSpanError(span, err)
			return nil, toStatusError(err)
		}
	}
	endSpanOk(span)

	out := make([]*timeloggerv1.Task, 0, len(tasks))
	for _, t := range tasks {
		out = append(out, toProtoTask(t, stats[t.ID]))
	}

	recordRecordsReturned(ctx, "ListTasks", "task", len(out))

	return &timeloggerv1.ListTasksResponse{
		Tasks: out,
		Page:  pageResponse(total, offset, len(out)),
	}, nil
}

func (s *TaskService) GetTask(
	ctx context.Context,
	req *timeloggerv1.GetTaskRequest,
) (*timeloggerv1.GetTaskResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	task, err := s.findTask(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	stats := entryStats{}
	if req.GetIncludeStats() {
		all, err := taskStats(ctx, s.db, user.UserID, []uint{task.ID})
		if err != nil {
			return nil, toStatusError(err)
		}
		stats = all[task.ID]
	}

	return &timeloggerv1.GetTaskResponse{Task: toProtoTask(*task, stats)}, nil
}

func (s *TaskService) UpdateTask(
	ctx context.Context,
	req *timeloggerv1.UpdateTaskRequest,
) (*timeloggerv1.UpdateTaskResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	task, err := s.findTask(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	mask := newFieldMask(req.GetUpdateMask())
	updates := map[string]any{}

	if mask.has("name") {
		name := strings.TrimSpace(req.GetName())
		if name == "" {
			return nil, toStatusError(invalid("name cannot be empty"))
		}
		updates["name"] = name
	}

	// Moving a task between projects would leave its existing entries pointing
	// at a task whose project no longer matches the entry's own project, so
	// the entries are moved along with it inside the same transaction.
	movingProject := mask.has("project_id") && req.GetProjectId() != 0 &&
		uint(req.GetProjectId()) != task.ProjectID
	if movingProject {
		if _, err := findProjectByID(ctx, s.db, user.UserID, req.GetProjectId()); err != nil {
			return nil, toStatusError(err)
		}
		updates["project_id"] = uint(req.GetProjectId())
	}

	if len(updates) == 0 {
		return &timeloggerv1.UpdateTaskResponse{Task: toProtoTask(*task, entryStats{})}, nil
	}

	ctx, span := startSpan(ctx, "db.update_task")
	defer span.End()

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Model(task).Updates(updates).Error; err != nil {
			return err
		}
		if movingProject {
			return tx.Model(&database.TimeEntry{}).
				Where("user_id = ? AND task_id = ?", user.UserID, task.ID).
				Update("project_id", uint(req.GetProjectId())).Error
		}
		return nil
	})
	if err != nil {
		recordSpanError(span, err)
		if isUniqueViolation(err) {
			return nil, toStatusError(ErrTaskAlreadyExists{Name: req.GetName()})
		}
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	reloaded, err := s.findTask(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	return &timeloggerv1.UpdateTaskResponse{Task: toProtoTask(*reloaded, entryStats{})}, nil
}

// DeleteTask removes a task and detaches it from any entry referencing it.
//
// Unlike a project, a task can be deleted while entries reference it: the
// entry keeps its project and its duration, and only loses the finer-grained
// label. Nothing the user cannot reconstruct is lost, so refusing would be
// more annoying than helpful.
func (s *TaskService) DeleteTask(
	ctx context.Context,
	req *timeloggerv1.DeleteTaskRequest,
) (*timeloggerv1.DeleteTaskResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	task, err := s.findTask(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.delete_task")
	defer span.End()

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Model(&database.TimeEntry{}).
			Where("user_id = ? AND task_id = ?", user.UserID, task.ID).
			Update("task_id", nil).Error; err != nil {
			return err
		}
		if err := tx.Where("user_id = ? AND task_id = ?", user.UserID, task.ID).
			Delete(&database.Goal{}).Error; err != nil {
			return err
		}
		return tx.Delete(task).Error
	})
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	return &timeloggerv1.DeleteTaskResponse{}, nil
}

func (s *TaskService) SetTaskArchived(
	ctx context.Context,
	req *timeloggerv1.SetTaskArchivedRequest,
) (*timeloggerv1.SetTaskArchivedResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	task, err := s.findTask(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.set_task_archived")
	defer span.End()

	if err := s.db.WithContext(ctx).Model(task).
		Update("archived", req.GetArchived()).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	return &timeloggerv1.SetTaskArchivedResponse{Task: toProtoTask(*task, entryStats{})}, nil
}

func (s *TaskService) findTask(ctx context.Context, userID uint, id uint64) (*database.Task, error) {
	return findTaskByID(ctx, s.db, userID, id)
}

// findTaskByID loads a task scoped to the user. It is a free function so the
// entry and timer handlers can validate a task reference without depending on
// TaskService.
func findTaskByID(ctx context.Context, db *gorm.DB, userID uint, id uint64) (*database.Task, error) {
	if id == 0 {
		return nil, gorm.ErrRecordNotFound
	}
	var task database.Task
	if err := db.WithContext(ctx).Preload("Project").
		Where("id = ? AND user_id = ?", id, userID).
		First(&task).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, gorm.ErrRecordNotFound
		}
		return nil, err
	}
	return &task, nil
}

// findProjectByID mirrors findTaskByID for projects.
func findProjectByID(ctx context.Context, db *gorm.DB, userID uint, id uint64) (*database.Project, error) {
	if id == 0 {
		return nil, gorm.ErrRecordNotFound
	}
	var project database.Project
	if err := db.WithContext(ctx).
		Where("id = ? AND user_id = ?", id, userID).
		First(&project).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, gorm.ErrRecordNotFound
		}
		return nil, err
	}
	return &project, nil
}

func taskStats(ctx context.Context, db *gorm.DB, userID uint, ids []uint) (map[uint]entryStats, error) {
	stats := map[uint]entryStats{}
	if len(ids) == 0 {
		return stats, nil
	}

	var rows []struct {
		TaskID       uint
		EntryCount   int64
		TotalSeconds int64
	}
	if err := db.WithContext(ctx).
		Model(&database.TimeEntry{}).
		Select("task_id, COUNT(*) AS entry_count, COALESCE(SUM(duration_seconds), 0) AS total_seconds").
		Where("user_id = ? AND task_id IN ?", userID, ids).
		Group("task_id").
		Scan(&rows).Error; err != nil {
		return nil, err
	}

	for _, r := range rows {
		stats[r.TaskID] = entryStats{EntryCount: r.EntryCount, TotalSeconds: r.TotalSeconds}
	}
	return stats, nil
}

func taskIDs(tasks []database.Task) []uint {
	ids := make([]uint, 0, len(tasks))
	for _, t := range tasks {
		ids = append(ids, t.ID)
	}
	return ids
}
