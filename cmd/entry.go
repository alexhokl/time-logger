package cmd

import (
	"context"
	"fmt"
	"time"

	"github.com/spf13/cobra"
	"google.golang.org/grpc"
	"google.golang.org/protobuf/types/known/timestamppb"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// renderEntries prints a set of entries in the selected output format. It is
// shared by every command that produces entries so the columns stay identical
// between `list entries`, `start`, `stop` and `copy`.
func renderEntries(entries []*timeloggerv1.TimeEntry, totalSeconds int64) error {
	rows := make([]map[string]any, 0, len(entries))
	for _, e := range entries {
		start := e.GetStartTime().AsTime().Local()

		row := map[string]any{
			"id":          e.GetId(),
			"description": e.GetDescription(),
			"project":     e.GetProjectName(),
			"task":        e.GetTaskName(),
			"tags":        joinTags(e.GetTags()),
			"date":        start.Format(dateLayout),
			"start":       start.Format("15:04"),
			"end":         "",
			"duration":    formatDuration(e.GetDurationSeconds()),
			"seconds":     e.GetDurationSeconds(),
			"running":     e.GetRunning(),
		}
		if e.EndTime != nil {
			row["end"] = e.GetEndTime().AsTime().Local().Format("15:04")
		}
		rows = append(rows, row)
	}

	t := table{
		Columns: []string{
			"id", "date", "start", "end", "duration",
			"project", "task", "description", "tags", "running",
		},
		Rows: rows,
	}

	if totalSeconds > 0 {
		t.Summary = []string{
			fmt.Sprintf("Total: %s across %d entries",
				formatDuration(totalSeconds), len(entries)),
		}
	}

	return render(t)
}

func joinTags(tags []string) string {
	out := ""
	for i, tag := range tags {
		if i > 0 {
			out += ","
		}
		out += tag
	}
	return out
}

// --- create entry ----------------------------------------------------------

type createEntryOptions struct {
	description string
	project     uint64
	task        uint64
	tags        []string
	start       string
	end         string
	duration    string
	date        string
}

var createEntryOpts createEntryOptions

var createEntryCmd = &cobra.Command{
	Use:     "entry [description]",
	Aliases: []string{"entries"},
	Short:   "Record a completed block of work",
	Long: `Record time that has already been spent.

Supply any two of --start, --end and --duration and the third is derived, or
combine --date with --duration to log a whole block against a day:

  time-logger create entry "code review" --duration 90
  time-logger create entry "standup" --start '2026-08-07 09:00' --end '2026-08-07 09:15'
  time-logger create entry "planning" --date yesterday --duration 2h

A bare number is read as minutes, so --duration 90 means an hour and a half.`,
	Args: cobra.MaximumNArgs(1),
	RunE: runCreateEntry,
}

func init() {
	createCmd.AddCommand(createEntryCmd)

	flags := createEntryCmd.Flags()
	flags.StringVarP(&createEntryOpts.description, "description", "m", "", "what the work was")
	flags.Uint64VarP(&createEntryOpts.project, "project", "p", 0, "project id")
	flags.Uint64VarP(&createEntryOpts.task, "task", "t", 0, "task id")
	flags.StringSliceVar(&createEntryOpts.tags, "tag", nil, "tag to attach (repeatable)")
	flags.StringVar(&createEntryOpts.start, "start", "", "start time, e.g. '2026-08-07 09:00'")
	flags.StringVar(&createEntryOpts.end, "end", "", "end time")
	flags.StringVarP(&createEntryOpts.duration, "duration", "D", "",
		"duration: bare numbers are minutes, or use 1h30m / 1.5h")
	flags.StringVar(&createEntryOpts.date, "date", "",
		"calendar date, used with --duration; accepts today/yesterday")
}

func runCreateEntry(_ *cobra.Command, args []string) error {
	description := createEntryOpts.description
	if len(args) == 1 && description == "" {
		description = args[0]
	}

	spec, err := buildTimeSpec(
		createEntryOpts.start,
		createEntryOpts.end,
		createEntryOpts.duration,
		createEntryOpts.date,
	)
	if err != nil {
		return err
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := entryClient(conn).CreateEntry(ctx, &timeloggerv1.CreateEntryRequest{
			Description: description,
			ProjectId:   createEntryOpts.project,
			TaskId:      createEntryOpts.task,
			Tags:        createEntryOpts.tags,
			Time:        spec,
		})
		if err != nil {
			return err
		}
		return renderEntries([]*timeloggerv1.TimeEntry{resp.GetEntry()}, 0)
	})
}

// --- list entries ----------------------------------------------------------

type listEntriesOptions struct {
	from      string
	to        string
	projects  []uint
	tasks     []uint
	tags      []string
	search    string
	limit     int32
	offset    int32
	ascending bool
}

var listEntriesOpts listEntriesOptions

var listEntriesCmd = &cobra.Command{
	Use:     "entries",
	Aliases: []string{"entry"},
	Short:   "List time entries",
	Long: `List time entries, newest first.

  time-logger list entries --from today
  time-logger list entries --from 2026-08-01 --to 2026-08-08 --tag billable
  time-logger list entries --from today --format csv > timesheet.csv`,
	RunE: runListEntries,
}

func init() {
	listCmd.AddCommand(listEntriesCmd)

	flags := listEntriesCmd.Flags()
	flags.StringVar(&listEntriesOpts.from, "from", "", "earliest date to include (inclusive)")
	flags.StringVar(&listEntriesOpts.to, "to", "", "latest date to include (inclusive)")
	flags.UintSliceVarP(&listEntriesOpts.projects, "project", "p", nil, "filter by project id")
	flags.UintSliceVarP(&listEntriesOpts.tasks, "task", "t", nil, "filter by task id")
	flags.StringSliceVar(&listEntriesOpts.tags, "tag", nil,
		"filter by tag; entries must carry every tag given")
	flags.StringVar(&listEntriesOpts.search, "search", "", "match against the description")
	flags.Int32VarP(&listEntriesOpts.limit, "limit", "n", 50, "maximum entries to return")
	flags.Int32Var(&listEntriesOpts.offset, "offset", 0, "records to skip")
	flags.BoolVar(&listEntriesOpts.ascending, "asc", false, "oldest first")
}

func runListEntries(_ *cobra.Command, _ []string) error {
	filter := &timeloggerv1.EntryFilter{
		ProjectIds: toUint64Slice(listEntriesOpts.projects),
		TaskIds:    toUint64Slice(listEntriesOpts.tasks),
		Tags:       listEntriesOpts.tags,
		Search:     listEntriesOpts.search,
	}

	// A date filter names whole local days, so --from is the start of that day
	// and --to is the start of the following one, keeping the range inclusive
	// at both ends as a user would expect.
	if listEntriesOpts.from != "" {
		date, err := parseDate(listEntriesOpts.from)
		if err != nil {
			return err
		}
		filter.From = timestampFromDate(date, 0)
	}
	if listEntriesOpts.to != "" {
		date, err := parseDate(listEntriesOpts.to)
		if err != nil {
			return err
		}
		filter.To = timestampFromDate(date, 1)
	}

	order := timeloggerv1.SortOrder_SORT_ORDER_DESC
	if listEntriesOpts.ascending {
		order = timeloggerv1.SortOrder_SORT_ORDER_ASC
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := entryClient(conn).ListEntries(ctx, &timeloggerv1.ListEntriesRequest{
			Filter: filter,
			Order:  order,
			Page: &timeloggerv1.PageRequest{
				PageSize: listEntriesOpts.limit,
				Offset:   listEntriesOpts.offset,
			},
		})
		if err != nil {
			return err
		}
		return renderEntries(resp.GetEntries(), resp.GetTotalSeconds())
	})
}

// timestampFromDate converts a calendar date into an instant at local midnight,
// optionally offset by a number of days.
func timestampFromDate(d *timeloggerv1.Date, dayOffset int) *timestamppb.Timestamp {
	if d == nil {
		return nil
	}
	midnight := time.Date(
		int(d.GetYear()), time.Month(d.GetMonth()), int(d.GetDay()),
		0, 0, 0, 0, time.Local,
	).AddDate(0, 0, dayOffset)
	return timestampOf(midnight)
}

// --- get entry -------------------------------------------------------------

var getEntryCmd = &cobra.Command{
	Use:   "entry <id>",
	Short: "Show a single time entry",
	Args:  cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		id, err := parseID(args[0])
		if err != nil {
			return err
		}
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := entryClient(conn).GetEntry(ctx, &timeloggerv1.GetEntryRequest{Id: id})
			if err != nil {
				return err
			}
			return renderEntries([]*timeloggerv1.TimeEntry{resp.GetEntry()}, 0)
		})
	},
}

func init() { getCmd.AddCommand(getEntryCmd) }

// --- update entry ----------------------------------------------------------

type updateEntryOptions struct {
	description string
	project     uint64
	task        uint64
	tags        []string
	start       string
	end         string
	duration    string
	date        string
}

var updateEntryOpts updateEntryOptions

var updateEntryCmd = &cobra.Command{
	Use:   "entry <id>",
	Short: "Change a time entry",
	Args:  cobra.ExactArgs(1),
	RunE:  runUpdateEntry,
}

func init() {
	updateCmd.AddCommand(updateEntryCmd)

	flags := updateEntryCmd.Flags()
	flags.StringVarP(&updateEntryOpts.description, "description", "m", "", "new description")
	flags.Uint64VarP(&updateEntryOpts.project, "project", "p", 0, "new project id (0 clears it)")
	flags.Uint64VarP(&updateEntryOpts.task, "task", "t", 0, "new task id (0 clears it)")
	flags.StringSliceVar(&updateEntryOpts.tags, "tag", nil, "replace the tags with these")
	flags.StringVar(&updateEntryOpts.start, "start", "", "new start time")
	flags.StringVar(&updateEntryOpts.end, "end", "", "new end time")
	flags.StringVarP(&updateEntryOpts.duration, "duration", "D", "", "new duration")
	flags.StringVar(&updateEntryOpts.date, "date", "", "new date")
}

func runUpdateEntry(cmd *cobra.Command, args []string) error {
	id, err := parseID(args[0])
	if err != nil {
		return err
	}

	spec, err := buildTimeSpec(
		updateEntryOpts.start,
		updateEntryOpts.end,
		updateEntryOpts.duration,
		updateEntryOpts.date,
	)
	if err != nil {
		return err
	}

	// The mask is built from the flags the user actually set, so an unset flag
	// leaves its field alone while an explicitly empty one clears it.
	mask := changedFlags(cmd, map[string]string{
		"description": "description",
		"project":     "project_id",
		"task":        "task_id",
		"tag":         "tags",
		"start":       "start_time",
		"end":         "end_time",
		"duration":    "duration_seconds",
		"date":        "start_time",
	})
	if len(mask) == 0 {
		return fmt.Errorf("nothing to update: pass at least one field flag")
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := entryClient(conn).UpdateEntry(ctx, &timeloggerv1.UpdateEntryRequest{
			Id:          id,
			UpdateMask:  mask,
			Description: updateEntryOpts.description,
			ProjectId:   updateEntryOpts.project,
			TaskId:      updateEntryOpts.task,
			Tags:        updateEntryOpts.tags,
			Time:        spec,
		})
		if err != nil {
			return err
		}
		return renderEntries([]*timeloggerv1.TimeEntry{resp.GetEntry()}, 0)
	})
}

// --- delete entry ----------------------------------------------------------

var deleteEntryCmd = &cobra.Command{
	Use:   "entry <id>",
	Short: "Delete a time entry",
	Args:  cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		id, err := parseID(args[0])
		if err != nil {
			return err
		}
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			if _, err := entryClient(conn).DeleteEntry(
				ctx, &timeloggerv1.DeleteEntryRequest{Id: id},
			); err != nil {
				return err
			}
			fmt.Printf("Deleted entry %d.\n", id)
			return nil
		})
	},
}

func init() { deleteCmd.AddCommand(deleteEntryCmd) }

// --- copy entries ----------------------------------------------------------

var copyToDate string

var copyEntriesCmd = &cobra.Command{
	Use:   "entries <id> [id...]",
	Short: "Copy entries onto another date",
	Long: `Duplicate entries onto another date, keeping their time of day,
duration, project, task and tags.

  time-logger copy entries 12 13 --to today`,
	Args: cobra.MinimumNArgs(1),
	RunE: runCopyEntries,
}

func init() {
	copyCmd.AddCommand(copyEntriesCmd)
	copyEntriesCmd.Flags().StringVar(&copyToDate, "to", "today", "date to copy onto")
	_ = copyEntriesCmd.MarkFlagRequired("to")
}

func runCopyEntries(_ *cobra.Command, args []string) error {
	ids := make([]uint64, 0, len(args))
	for _, arg := range args {
		id, err := parseID(arg)
		if err != nil {
			return err
		}
		ids = append(ids, id)
	}

	target, err := parseDate(copyToDate)
	if err != nil {
		return err
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := entryClient(conn).CopyEntries(ctx, &timeloggerv1.CopyEntriesRequest{
			EntryIds:   ids,
			TargetDate: target,
		})
		if err != nil {
			return err
		}
		return renderEntries(resp.GetEntries(), 0)
	})
}
