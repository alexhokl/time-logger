package internal

import (
	"context"
	"errors"
	"log/slog"
	"strings"

	"gorm.io/gorm"

	"github.com/alexhokl/time-logger/database"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// TagService implements the gRPC service of the same name.
type TagService struct {
	timeloggerv1.UnimplementedTagServiceServer
	base
}

func NewTagService(db *gorm.DB) *TagService {
	return &TagService{base: base{db: db}}
}

func (s *TagService) CreateTag(
	ctx context.Context,
	req *timeloggerv1.CreateTagRequest,
) (*timeloggerv1.CreateTagResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	name := normaliseTagName(req.GetName())
	if name == "" {
		return nil, toStatusError(invalid("name is required"))
	}

	ctx, span := startSpan(ctx, "db.create_tag")
	defer span.End()

	tag := database.Tag{Name: name, UserID: user.UserID}
	if err := s.db.WithContext(ctx).Create(&tag).Error; err != nil {
		recordSpanError(span, err)
		if isUniqueViolation(err) {
			return nil, toStatusError(ErrTagAlreadyExists{Name: name})
		}
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	logMutation(ctx, timeloggerv1.TagService_CreateTag_FullMethodName, user.UserID,
		slog.Uint64("tag_id", uint64(tag.ID)))

	return &timeloggerv1.CreateTagResponse{Tag: toProtoTag(tag, entryStats{})}, nil
}

func (s *TagService) ListTags(
	ctx context.Context,
	req *timeloggerv1.ListTagsRequest,
) (*timeloggerv1.ListTagsResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	ctx, span := startSpan(ctx, "db.list_tags")
	defer span.End()

	query := s.db.WithContext(ctx).Model(&database.Tag{}).Where("user_id = ?", user.UserID)

	var total int64
	if err := query.Count(&total).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}

	limit, offset := normalisePage(req.GetPage())

	var tags []database.Tag
	if err := query.Order("name ASC").Limit(limit).Offset(offset).Find(&tags).Error; err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}

	stats := map[uint]entryStats{}
	if req.GetIncludeStats() {
		stats, err = s.tagStats(ctx, user.UserID, tagIDs(tags))
		if err != nil {
			recordSpanError(span, err)
			return nil, toStatusError(err)
		}
	}
	endSpanOk(span)

	out := make([]*timeloggerv1.Tag, 0, len(tags))
	for _, t := range tags {
		out = append(out, toProtoTag(t, stats[t.ID]))
	}

	recordRecordsReturned(ctx, "ListTags", "tag", len(out))

	return &timeloggerv1.ListTagsResponse{
		Tags: out,
		Page: pageResponse(total, offset, len(out)),
	}, nil
}

func (s *TagService) RenameTag(
	ctx context.Context,
	req *timeloggerv1.RenameTagRequest,
) (*timeloggerv1.RenameTagResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	name := normaliseTagName(req.GetName())
	if name == "" {
		return nil, toStatusError(invalid("name is required"))
	}

	tag, err := s.findTag(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.rename_tag")
	defer span.End()

	// Because entries reference the tag through a join table, renaming the row
	// is all that is needed; every entry follows automatically.
	if err := s.db.WithContext(ctx).Model(tag).Update("name", name).Error; err != nil {
		recordSpanError(span, err)
		if isUniqueViolation(err) {
			return nil, toStatusError(ErrTagAlreadyExists{Name: name})
		}
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	logMutation(ctx, timeloggerv1.TagService_RenameTag_FullMethodName, user.UserID,
		slog.Uint64("tag_id", req.GetId()))

	return &timeloggerv1.RenameTagResponse{Tag: toProtoTag(*tag, entryStats{})}, nil
}

// DeleteTag removes the tag and every association with it. The entries keep
// their time and only lose the label.
func (s *TagService) DeleteTag(
	ctx context.Context,
	req *timeloggerv1.DeleteTagRequest,
) (*timeloggerv1.DeleteTagResponse, error) {
	user, err := s.resolveUser(ctx)
	if err != nil {
		return nil, err
	}

	tag, err := s.findTag(ctx, user.UserID, req.GetId())
	if err != nil {
		return nil, toStatusError(err)
	}

	ctx, span := startSpan(ctx, "db.delete_tag")
	defer span.End()

	err = s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		// EntryTag has no soft-delete column, so the join rows are removed
		// outright rather than left dangling behind a deleted tag.
		if err := tx.Where("tag_id = ?", tag.ID).Delete(&database.EntryTag{}).Error; err != nil {
			return err
		}
		return tx.Delete(tag).Error
	})
	if err != nil {
		recordSpanError(span, err)
		return nil, toStatusError(err)
	}
	endSpanOk(span)

	logMutation(ctx, timeloggerv1.TagService_DeleteTag_FullMethodName, user.UserID,
		slog.Uint64("tag_id", req.GetId()))

	return &timeloggerv1.DeleteTagResponse{}, nil
}

func (s *TagService) findTag(ctx context.Context, userID uint, id uint64) (*database.Tag, error) {
	if id == 0 {
		return nil, gorm.ErrRecordNotFound
	}
	var tag database.Tag
	if err := s.db.WithContext(ctx).
		Where("id = ? AND user_id = ?", id, userID).
		First(&tag).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, gorm.ErrRecordNotFound
		}
		return nil, err
	}
	return &tag, nil
}

// tagStats aggregates per-tag usage by joining through the association table.
func (s *TagService) tagStats(ctx context.Context, userID uint, ids []uint) (map[uint]entryStats, error) {
	stats := map[uint]entryStats{}
	if len(ids) == 0 {
		return stats, nil
	}

	var rows []struct {
		TagID        uint
		EntryCount   int64
		TotalSeconds int64
	}
	if err := s.db.WithContext(ctx).
		Table("entry_tags").
		Select("entry_tags.tag_id AS tag_id, COUNT(*) AS entry_count, "+
			"COALESCE(SUM(time_entries.duration_seconds), 0) AS total_seconds").
		Joins("JOIN time_entries ON time_entries.id = entry_tags.time_entry_id").
		Where("time_entries.user_id = ? AND time_entries.deleted_at IS NULL AND entry_tags.tag_id IN ?",
			userID, ids).
		Group("entry_tags.tag_id").
		Scan(&rows).Error; err != nil {
		return nil, err
	}

	for _, r := range rows {
		stats[r.TagID] = entryStats{EntryCount: r.EntryCount, TotalSeconds: r.TotalSeconds}
	}
	return stats, nil
}

// normaliseTagName trims and lowercases a tag so that "Billable", "billable"
// and " billable " are the same tag. Without this the unique index would let
// near-duplicates accumulate and every tag filter would silently miss rows.
func normaliseTagName(name string) string {
	return strings.ToLower(strings.TrimSpace(name))
}

// resolveTags maps tag names onto rows, creating any that do not exist yet.
// Creating on demand is what makes `--tag billable` work without a separate
// setup step. Duplicate and blank names in the input are ignored.
func resolveTags(ctx context.Context, tx *gorm.DB, userID uint, names []string) ([]database.Tag, error) {
	if len(names) == 0 {
		return nil, nil
	}

	seen := map[string]struct{}{}
	tags := make([]database.Tag, 0, len(names))
	for _, raw := range names {
		name := normaliseTagName(raw)
		if name == "" {
			continue
		}
		if _, dup := seen[name]; dup {
			continue
		}
		seen[name] = struct{}{}

		tag := database.Tag{Name: name, UserID: userID}
		if err := tx.WithContext(ctx).
			Where(database.Tag{Name: name, UserID: userID}).
			FirstOrCreate(&tag).Error; err != nil {
			return nil, err
		}
		tags = append(tags, tag)
	}
	return tags, nil
}

func tagIDs(tags []database.Tag) []uint {
	ids := make([]uint, 0, len(tags))
	for _, t := range tags {
		ids = append(ids, t.ID)
	}
	return ids
}
