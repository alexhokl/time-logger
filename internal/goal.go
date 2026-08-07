package internal

import (
	"context"
	"errors"
	"time"

	"gorm.io/gorm"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// GoalService implements the gRPC service of the same name.
type GoalService struct {
	timeloggerv1.UnimplementedGoalServiceServer
	base
}

func NewGoalService(db *gorm.DB) *GoalService {
	return &GoalService{base: base{db: db}}
}

func (s *GoalService) CreateGoal(
	ctx context.Context,
	req *timeloggerv1.CreateGoalRequest,
) (*timeloggerv1.CreateGoalResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	goal, err := s.buildGoal(ctx, user, goalInput{
		ProjectID:   req.GetProjectId(),
		TaskID:      req.GetTaskId(),
		TargetHours: req.GetTargetHours(),
		Period:      req.GetPeriod(),
		StartDate:   req.GetStartDate(),
		EndDate:     req.EndDate,
	})
	if err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.create_goal")
	defer span.End()

	if err := s.db.WithContext(ctx).Create(goal).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	loaded, err := s.findGoal(ctx, user.UserID, uint64(goal.ID))
	if err != nil {
		return nil, toStatusError(err)
	}

	return &timeloggerv1.CreateGoalResponse{Goal: toProtoGoal(*loaded, user.Location)}, nil
}

func (s *GoalService) ListGoals(
	ctx context.Context,
	req *timeloggerv1.ListGoalsRequest,
) (*timeloggerv1.ListGoalsResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	ctx, span := startSpan(ctx, "db.list_goals")
	defer span.End()

	query := s.db.WithContext(ctx).Model(&database.Goal{}).Where("user_id = ?", user.UserID)
	if req.GetProjectId() != 0 {
		query = query.Where("project_id = ?", req.GetProjectId())
	}
	if req.GetActiveOnly() {
		// A goal is active when today falls inside its window; an absent end
		// date means the window is open-ended.
		today := s.clock().In(user.Location)
		midnight := time.Date(today.Year(), today.Month(), today.Day(), 0, 0, 0, 0, user.Location)
		query = query.Where("start_date <= ? AND (end_date IS NULL OR end_date >= ?)",
			midnight, midnight)
	}

	var total int64
	if err := query.Count(&total).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}

	limit, offset := normalisePage(req.GetPage())

	var goals []database.Goal
	if err := query.Preload("Project").Preload("Task").
		Order("start_date DESC").Limit(limit).Offset(offset).
		Find(&goals).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	out := make([]*timeloggerv1.Goal, 0, len(goals))
	for _, g := range goals {
		out = append(out, toProtoGoal(g, user.Location))
	}

	recordRecordsReturned(ctx, "ListGoals", "goal", len(out))

	return &timeloggerv1.ListGoalsResponse{
		Goals: out,
		Page:  pageResponse(total, offset, len(out)),
	}, nil
}

func (s *GoalService) GetGoal(
	ctx context.Context,
	req *timeloggerv1.GetGoalRequest,
) (*timeloggerv1.GetGoalResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	goal, err := s.findGoal(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	return &timeloggerv1.GetGoalResponse{Goal: toProtoGoal(*goal, user.Location)}, nil
}

func (s *GoalService) UpdateGoal(
	ctx context.Context,
	req *timeloggerv1.UpdateGoalRequest,
) (*timeloggerv1.UpdateGoalResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	goal, err := s.findGoal(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	mask := newFieldMask(req.GetUpdateMask())
	updates := map[string]any{}

	if mask.has("project_id") {
		projectID := uintPtr(req.GetProjectId())
		if projectID != nil {
			if _, err := findProjectByID(ctx, s.db, user.UserID, req.GetProjectId()); err != nil {
				return nil, toStatusError(err)
			}
		}
		updates["project_id"] = projectID
	}
	if mask.has("task_id") {
		taskID := uintPtr(req.GetTaskId())
		if taskID != nil {
			if _, err := findTaskByID(ctx, s.db, user.UserID, req.GetTaskId()); err != nil {
				return nil, toStatusError(err)
			}
		}
		updates["task_id"] = taskID
	}
	if mask.has("target_hours") && req.GetTargetHours() > 0 {
		seconds, err := targetSeconds(req.GetTargetHours())
		if err != nil {
			return nil, toStatusError(err)
		}
		updates["target_seconds"] = seconds
	}
	if mask.has("period") && req.GetPeriod() != timeloggerv1.Period_PERIOD_UNSPECIFIED {
		updates["period"] = periodFromProto(req.GetPeriod())
	}
	if mask.has("start_date") && req.GetStartDate() != nil {
		if err := validateDate(req.GetStartDate(), "start_date"); err != nil {
			return nil, toStatusError(err)
		}
		updates["start_date"] = startOfDay(req.GetStartDate(), user.Location).UTC()
	}
	if mask.has("end_date") {
		if req.EndDate == nil {
			// Naming end_date in the mask without a value clears it, which is
			// how a bounded goal is made open-ended.
			updates["end_date"] = nil
		} else {
			if err := validateDate(req.GetEndDate(), "end_date"); err != nil {
				return nil, toStatusError(err)
			}
			updates["end_date"] = startOfDay(req.GetEndDate(), user.Location).UTC()
		}
	}

	if len(updates) > 0 {
		ctx, span := startSpan(ctx, "db.update_goal")
		if err := s.db.WithContext(ctx).Model(goal).Updates(updates).Error; err != nil {
			recordSpanError(span, err)
			span.End()
			return nil, toStatusError(err)
		}
		endSpanOk(span)
	}

	reloaded, err := s.findGoal(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}
	if err := validateGoalWindow(reloaded.StartDate, reloaded.EndDate); err != nil {
		return nil, toStatusError(err)
	}

	return &timeloggerv1.UpdateGoalResponse{Goal: toProtoGoal(*reloaded, user.Location)}, nil
}

func (s *GoalService) DeleteGoal(
	ctx context.Context,
	req *timeloggerv1.DeleteGoalRequest,
) (*timeloggerv1.DeleteGoalResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	goal, err := s.findGoal(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.delete_goal")
	defer span.End()

	if err := s.db.WithContext(ctx).Delete(goal).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	return &timeloggerv1.DeleteGoalResponse{}, nil
}

// goalInput is the subset of a create request the builder needs, so the same
// validation can be reused if another entry point is added later.
type goalInput struct {
	ProjectID   uint64
	TaskID      uint64
	TargetHours float64
	Period      timeloggerv1.Period
	StartDate   *timeloggerv1.Date
	EndDate     *timeloggerv1.Date
}

func (s *GoalService) buildGoal(ctx context.Context, user userContext, in goalInput) (*database.Goal, error) {
	seconds, err := targetSeconds(in.TargetHours)
	if err != nil {
		return nil, err
	}
	if err := validateDate(in.StartDate, "start_date"); err != nil {
		return nil, err
	}

	projectID := uintPtr(in.ProjectID)
	taskID := uintPtr(in.TaskID)

	if projectID != nil {
		if _, err := findProjectByID(ctx, s.db, user.UserID, in.ProjectID); err != nil {
			return nil, err
		}
	}
	if taskID != nil {
		task, err := findTaskByID(ctx, s.db, user.UserID, in.TaskID)
		if err != nil {
			return nil, err
		}
		// A task-scoped goal implies its project, so the report can filter on
		// project alone when it needs to.
		if projectID == nil {
			projectID = &task.ProjectID
		} else if *projectID != task.ProjectID {
			return nil, ErrTaskProjectMismatch{TaskName: task.Name}
		}
	}

	goal := &database.Goal{
		ProjectID:     projectID,
		TaskID:        taskID,
		TargetSeconds: seconds,
		Period:        periodFromProto(in.Period),
		StartDate:     startOfDay(in.StartDate, user.Location).UTC(),
		UserID:        user.UserID,
	}

	if in.EndDate != nil {
		if err := validateDate(in.EndDate, "end_date"); err != nil {
			return nil, err
		}
		end := startOfDay(in.EndDate, user.Location).UTC()
		goal.EndDate = &end
	}

	if err := validateGoalWindow(goal.StartDate, goal.EndDate); err != nil {
		return nil, err
	}

	return goal, nil
}

func (s *GoalService) findGoal(ctx context.Context, userID uint, id uint64) (*database.Goal, error) {
	if id == 0 {
		return nil, gorm.ErrRecordNotFound
	}
	var goal database.Goal
	if err := s.db.WithContext(ctx).Preload("Project").Preload("Task").
		Where("id = ? AND user_id = ?", id, userID).
		First(&goal).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, gorm.ErrRecordNotFound
		}
		return nil, err
	}
	return &goal, nil
}

// targetSeconds converts the API's hours into stored seconds, rejecting values
// that cannot describe a usable target.
func targetSeconds(hours float64) (int64, error) {
	if hours <= 0 {
		return 0, invalid("target_hours must be greater than zero")
	}
	// A weekly target above a full week of wall-clock time is unreachable and
	// almost certainly a units mistake.
	if hours > 24*31 {
		return 0, invalid("target_hours is implausibly large")
	}
	return int64(hours * 3600), nil
}

func validateGoalWindow(start time.Time, end *time.Time) error {
	if end != nil && end.Before(start) {
		return invalid("end_date is before start_date")
	}
	return nil
}
