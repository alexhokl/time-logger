package cmd

import (
	"context"
	"fmt"

	"github.com/spf13/cobra"
	"google.golang.org/grpc"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// --- goals -----------------------------------------------------------------

type createGoalOptions struct {
	project uint64
	task    uint64
	hours   float64
	period  string
	from    string
	until   string
}

var createGoalOpts createGoalOptions

var createGoalCmd = &cobra.Command{
	Use:   "goal",
	Short: "Set a target number of hours per period",
	Long: `Set a recurring target.

  time-logger create goal --project 3 --hours 10 --period weekly
  time-logger create goal --hours 2 --period daily --from 2026-09-01 --until 2026-12-31

Omitting --project targets all tracked time; omitting --until leaves the goal
open-ended.`,
	RunE: runCreateGoal,
}

type listGoalsOptions struct {
	project    uint64
	activeOnly bool
}

var listGoalsOpts listGoalsOptions

var listGoalsCmd = &cobra.Command{
	Use:     "goals",
	Aliases: []string{"goal"},
	Short:   "List goals",
	RunE: func(_ *cobra.Command, _ []string) error {
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := goalClient(conn).ListGoals(ctx, &timeloggerv1.ListGoalsRequest{
				ProjectId:  listGoalsOpts.project,
				ActiveOnly: listGoalsOpts.activeOnly,
			})
			if err != nil {
				return err
			}
			return renderGoals(resp.GetGoals())
		})
	},
}

var deleteGoalCmd = &cobra.Command{
	Use:   "goal <id>",
	Short: "Delete a goal",
	Args:  cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		id, err := parseID(args[0])
		if err != nil {
			return err
		}
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			if _, err := goalClient(conn).DeleteGoal(
				ctx, &timeloggerv1.DeleteGoalRequest{Id: id},
			); err != nil {
				return err
			}
			fmt.Printf("Deleted goal %d.\n", id)
			return nil
		})
	},
}

func init() {
	createCmd.AddCommand(createGoalCmd)
	listCmd.AddCommand(listGoalsCmd)
	deleteCmd.AddCommand(deleteGoalCmd)

	flags := createGoalCmd.Flags()
	flags.Uint64VarP(&createGoalOpts.project, "project", "p", 0,
		"project the goal applies to (omit for all)")
	flags.Uint64VarP(&createGoalOpts.task, "task", "t", 0, "task the goal applies to")
	flags.Float64Var(&createGoalOpts.hours, "hours", 0, "target hours per period")
	flags.StringVar(&createGoalOpts.period, "period", "weekly", "daily, weekly or monthly")
	flags.StringVar(&createGoalOpts.from, "from", "today", "first date the goal applies")
	flags.StringVar(&createGoalOpts.until, "until", "", "last date the goal applies")
	_ = createGoalCmd.MarkFlagRequired("hours")

	listGoalsCmd.Flags().Uint64VarP(&listGoalsOpts.project, "project", "p", 0,
		"restrict to one project")
	listGoalsCmd.Flags().BoolVar(&listGoalsOpts.activeOnly, "active", false,
		"only goals in force today")
}

func runCreateGoal(_ *cobra.Command, _ []string) error {
	period, err := parsePeriod(createGoalOpts.period)
	if err != nil {
		return err
	}

	from, err := parseDate(createGoalOpts.from)
	if err != nil {
		return err
	}

	req := &timeloggerv1.CreateGoalRequest{
		ProjectId:   createGoalOpts.project,
		TaskId:      createGoalOpts.task,
		TargetHours: createGoalOpts.hours,
		Period:      period,
		StartDate:   from,
	}

	if createGoalOpts.until != "" {
		until, err := parseDate(createGoalOpts.until)
		if err != nil {
			return err
		}
		req.EndDate = until
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := goalClient(conn).CreateGoal(ctx, req)
		if err != nil {
			return err
		}
		return renderGoals([]*timeloggerv1.Goal{resp.GetGoal()})
	})
}

func renderGoals(goals []*timeloggerv1.Goal) error {
	rows := make([]map[string]any, 0, len(goals))
	for _, g := range goals {
		scope := g.GetProjectName()
		if g.GetTaskName() != "" {
			scope = fmt.Sprintf("%s / %s", scope, g.GetTaskName())
		}
		if scope == "" {
			scope = "(all work)"
		}

		rows = append(rows, map[string]any{
			"id":     g.GetId(),
			"scope":  scope,
			"target": fmt.Sprintf("%.1fh", g.GetTargetHours()),
			"period": periodLabel(g.GetPeriod()),
			"from":   formatDate(g.GetStartDate()),
			"until":  formatDate(g.GetEndDate()),
		})
	}

	return render(table{
		Columns: []string{"id", "scope", "target", "period", "from", "until"},
		Rows:    rows,
	})
}

func periodLabel(p timeloggerv1.Period) string {
	switch p {
	case timeloggerv1.Period_PERIOD_DAILY:
		return "daily"
	case timeloggerv1.Period_PERIOD_MONTHLY:
		return "monthly"
	default:
		return "weekly"
	}
}

// --- settings --------------------------------------------------------------

var getSettingsCmd = &cobra.Command{
	Use:   "settings",
	Short: "Show your settings",
	RunE: func(_ *cobra.Command, _ []string) error {
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := settingsClient(conn).GetSettings(ctx, &timeloggerv1.GetSettingsRequest{})
			if err != nil {
				return err
			}
			return renderSettings(resp.GetSettings())
		})
	},
}

type updateSettingsOptions struct {
	timezone       string
	weekStartsOn   string
	rounding       int32
	defaultProject uint64
}

var updateSettingsOpts updateSettingsOptions

var updateSettingsCmd = &cobra.Command{
	Use:   "settings",
	Short: "Change your settings",
	Long: `Change your settings.

The timezone governs how days are bounded in every report, so setting it
correctly matters more than it might appear: an entry at 00:30 belongs to a
different day depending on it.`,
	RunE: runUpdateSettings,
}

func init() {
	getCmd.AddCommand(getSettingsCmd)
	updateCmd.AddCommand(updateSettingsCmd)

	flags := updateSettingsCmd.Flags()
	flags.StringVar(&updateSettingsOpts.timezone, "timezone", "",
		"IANA timezone, e.g. Asia/Hong_Kong")
	flags.StringVar(&updateSettingsOpts.weekStartsOn, "week-starts-on", "",
		"weekday reports treat as the start of the week")
	flags.Int32Var(&updateSettingsOpts.rounding, "rounding", 0,
		"round reported durations up to a multiple of this many minutes (0 disables)")
	flags.Uint64Var(&updateSettingsOpts.defaultProject, "default-project", 0,
		"project clients pre-select (0 clears it)")
}

func runUpdateSettings(cmd *cobra.Command, _ []string) error {
	settings := &timeloggerv1.Settings{
		Timezone:         updateSettingsOpts.timezone,
		RoundingMinutes:  updateSettingsOpts.rounding,
		DefaultProjectId: updateSettingsOpts.defaultProject,
	}

	if cmd.Flags().Changed("week-starts-on") {
		day, err := parseDayOfWeek(updateSettingsOpts.weekStartsOn)
		if err != nil {
			return err
		}
		settings.WeekStartsOn = day
	}

	mask := changedFlags(cmd, map[string]string{
		"timezone":        "timezone",
		"week-starts-on":  "week_starts_on",
		"rounding":        "rounding_minutes",
		"default-project": "default_project_id",
	})
	if len(mask) == 0 {
		return fmt.Errorf("nothing to update: pass at least one setting flag")
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := settingsClient(conn).UpdateSettings(ctx, &timeloggerv1.UpdateSettingsRequest{
			UpdateMask: mask,
			Settings:   settings,
		})
		if err != nil {
			return err
		}
		return renderSettings(resp.GetSettings())
	})
}

func renderSettings(s *timeloggerv1.Settings) error {
	rounding := "off"
	if s.GetRoundingMinutes() > 0 {
		rounding = fmt.Sprintf("%d minutes", s.GetRoundingMinutes())
	}

	defaultProject := "(none)"
	if s.GetDefaultProjectId() != 0 {
		defaultProject = fmt.Sprintf("%s (%d)", s.GetDefaultProjectName(), s.GetDefaultProjectId())
	}

	return render(table{
		Columns: []string{"timezone", "week_starts_on", "rounding", "default_project"},
		Rows: []map[string]any{{
			"timezone":        s.GetTimezone(),
			"week_starts_on":  weekdayLabel(s.GetWeekStartsOn()),
			"rounding":        rounding,
			"default_project": defaultProject,
		}},
	})
}

func weekdayLabel(d timeloggerv1.DayOfWeek) string {
	names := map[timeloggerv1.DayOfWeek]string{
		timeloggerv1.DayOfWeek_DAY_OF_WEEK_MONDAY:    "Monday",
		timeloggerv1.DayOfWeek_DAY_OF_WEEK_TUESDAY:   "Tuesday",
		timeloggerv1.DayOfWeek_DAY_OF_WEEK_WEDNESDAY: "Wednesday",
		timeloggerv1.DayOfWeek_DAY_OF_WEEK_THURSDAY:  "Thursday",
		timeloggerv1.DayOfWeek_DAY_OF_WEEK_FRIDAY:    "Friday",
		timeloggerv1.DayOfWeek_DAY_OF_WEEK_SATURDAY:  "Saturday",
		timeloggerv1.DayOfWeek_DAY_OF_WEEK_SUNDAY:    "Sunday",
	}
	if name, ok := names[d]; ok {
		return name
	}
	return "Monday"
}
