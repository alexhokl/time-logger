package cmd

import (
	"context"
	"fmt"
	"strings"

	"github.com/spf13/cobra"
	"google.golang.org/grpc"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

type reportOptions struct {
	date     string
	from     string
	to       string
	groupBy  string
	projects []uint
	tasks    []uint
	tags     []string
}

var reportOpts reportOptions

var reportDailyCmd = &cobra.Command{
	Use:     "daily",
	Aliases: []string{"day", "today"},
	Short:   "Summarise a single day",
	RunE:    runReportDaily,
}

var reportWeeklyCmd = &cobra.Command{
	Use:     "weekly",
	Aliases: []string{"week"},
	Short:   "Summarise a week",
	RunE:    runReportWeekly,
}

var reportMonthlyCmd = &cobra.Command{
	Use:     "monthly",
	Aliases: []string{"month"},
	Short:   "Summarise a calendar month",
	RunE:    runReportMonthly,
}

var reportRangeCmd = &cobra.Command{
	Use:   "range",
	Short: "Summarise an arbitrary date range",
	RunE:  runReportRange,
}

var reportGoalsCmd = &cobra.Command{
	Use:   "goals",
	Short: "Compare tracked time against your goals",
	RunE:  runReportGoals,
}

var reportHeatmapCmd = &cobra.Command{
	Use:   "heatmap",
	Short: "Show tracked time per day across a range",
	RunE:  runReportHeatmap,
}

var reportStreaksCmd = &cobra.Command{
	Use:   "streaks",
	Short: "Show runs of consecutive days with tracked time",
	RunE:  runReportStreaks,
}

var streakMinimum string

func init() {
	reportCmd.AddCommand(
		reportDailyCmd, reportWeeklyCmd, reportMonthlyCmd, reportRangeCmd,
		reportGoalsCmd, reportHeatmapCmd, reportStreaksCmd,
	)

	// The period reports share a flag set, registered once per command so each
	// keeps its own help text.
	for _, cmd := range []*cobra.Command{
		reportDailyCmd, reportWeeklyCmd, reportMonthlyCmd,
	} {
		cmd.Flags().StringVar(&reportOpts.date, "date", "",
			"any date inside the period (default today)")
		addGroupingFlags(cmd)
	}

	reportRangeCmd.Flags().StringVar(&reportOpts.from, "from", "", "first day (inclusive)")
	reportRangeCmd.Flags().StringVar(&reportOpts.to, "to", "", "last day (inclusive)")
	_ = reportRangeCmd.MarkFlagRequired("from")
	_ = reportRangeCmd.MarkFlagRequired("to")
	addGroupingFlags(reportRangeCmd)

	reportGoalsCmd.Flags().StringVar(&reportOpts.date, "date", "",
		"date to evaluate the goals on (default today)")
	reportGoalsCmd.Flags().UintSliceVarP(&reportOpts.projects, "project", "p", nil,
		"restrict to one project")

	reportHeatmapCmd.Flags().StringVar(&reportOpts.from, "from", "", "first day (inclusive)")
	reportHeatmapCmd.Flags().StringVar(&reportOpts.to, "to", "today", "last day (inclusive)")
	reportHeatmapCmd.Flags().UintSliceVarP(&reportOpts.projects, "project", "p", nil,
		"restrict to these projects")
	_ = reportHeatmapCmd.MarkFlagRequired("from")

	reportStreaksCmd.Flags().StringVar(&reportOpts.from, "from", "",
		"first day to search (default a year back)")
	reportStreaksCmd.Flags().StringVar(&reportOpts.to, "to", "", "last day to search (default today)")
	reportStreaksCmd.Flags().StringVar(&streakMinimum, "minimum", "",
		"minimum time per day for it to count, e.g. 30 or 1h")
}

func addGroupingFlags(cmd *cobra.Command) {
	cmd.Flags().StringVarP(&reportOpts.groupBy, "group-by", "g", "project",
		"group by project, task, tag or day")
	cmd.Flags().UintSliceVarP(&reportOpts.projects, "project", "p", nil, "filter by project id")
	cmd.Flags().UintSliceVarP(&reportOpts.tasks, "task", "t", nil, "filter by task id")
	cmd.Flags().StringSliceVar(&reportOpts.tags, "tag", nil, "filter by tag")
}

// buildReportOptions assembles the shared grouping and filtering options.
func buildReportOptions() (*timeloggerv1.ReportOptions, error) {
	groupBy, err := parseGroupBy(reportOpts.groupBy)
	if err != nil {
		return nil, err
	}
	return &timeloggerv1.ReportOptions{
		GroupBy:    groupBy,
		ProjectIds: toUint64Slice(reportOpts.projects),
		TaskIds:    toUint64Slice(reportOpts.tasks),
		Tags:       reportOpts.tags,
	}, nil
}

// optionalDate parses the --date flag, returning nil when it was not given so
// the server applies its own "today" default in the user's timezone.
func optionalDate(value string) (*timeloggerv1.Date, error) {
	if value == "" {
		return nil, nil
	}
	return parseDate(value)
}

func runReportDaily(_ *cobra.Command, _ []string) error {
	options, err := buildReportOptions()
	if err != nil {
		return err
	}
	date, err := optionalDate(reportOpts.date)
	if err != nil {
		return err
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := reportClient(conn).GetDailyReport(ctx, &timeloggerv1.GetDailyReportRequest{
			Date:    date,
			Options: options,
		})
		if err != nil {
			return err
		}
		return renderPeriodReport(resp.GetReport())
	})
}

func runReportWeekly(_ *cobra.Command, _ []string) error {
	options, err := buildReportOptions()
	if err != nil {
		return err
	}
	date, err := optionalDate(reportOpts.date)
	if err != nil {
		return err
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := reportClient(conn).GetWeeklyReport(ctx, &timeloggerv1.GetWeeklyReportRequest{
			Date:    date,
			Options: options,
		})
		if err != nil {
			return err
		}
		return renderPeriodReport(resp.GetReport())
	})
}

func runReportMonthly(_ *cobra.Command, _ []string) error {
	options, err := buildReportOptions()
	if err != nil {
		return err
	}
	date, err := optionalDate(reportOpts.date)
	if err != nil {
		return err
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := reportClient(conn).GetMonthlyReport(ctx, &timeloggerv1.GetMonthlyReportRequest{
			Date:    date,
			Options: options,
		})
		if err != nil {
			return err
		}
		return renderPeriodReport(resp.GetReport())
	})
}

func runReportRange(_ *cobra.Command, _ []string) error {
	options, err := buildReportOptions()
	if err != nil {
		return err
	}
	from, err := parseDate(reportOpts.from)
	if err != nil {
		return err
	}
	to, err := parseDate(reportOpts.to)
	if err != nil {
		return err
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := reportClient(conn).GetRangeReport(ctx, &timeloggerv1.GetRangeReportRequest{
			From:    from,
			To:      to,
			Options: options,
		})
		if err != nil {
			return err
		}
		return renderPeriodReport(resp.GetReport())
	})
}

func renderPeriodReport(report *timeloggerv1.PeriodReport) error {
	rows := make([]map[string]any, 0, len(report.GetRows()))
	for _, r := range report.GetRows() {
		rows = append(rows, map[string]any{
			"id":         r.GetId(),
			"label":      r.GetLabel(),
			"duration":   formatDuration(r.GetTotalSeconds()),
			"seconds":    r.GetTotalSeconds(),
			"entries":    r.GetEntryCount(),
			"percentage": r.GetPercentage(),
		})
	}

	return render(table{
		Columns: []string{"label", "duration", "entries", "percentage"},
		Rows:    rows,
		Summary: []string{
			fmt.Sprintf("%s to %s (%s)",
				formatDate(report.GetFrom()), formatDate(report.GetTo()), report.GetTimezone()),
			fmt.Sprintf("Total: %s across %d entries",
				formatDuration(report.GetTotalSeconds()), report.GetEntryCount()),
		},
	})
}

func runReportGoals(_ *cobra.Command, _ []string) error {
	date, err := optionalDate(reportOpts.date)
	if err != nil {
		return err
	}

	var projectID uint64
	if len(reportOpts.projects) > 0 {
		projectID = uint64(reportOpts.projects[0])
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := reportClient(conn).GetGoalReport(ctx, &timeloggerv1.GetGoalReportRequest{
			Date:      date,
			ProjectId: projectID,
		})
		if err != nil {
			return err
		}

		rows := make([]map[string]any, 0, len(resp.GetProgress()))
		for _, p := range resp.GetProgress() {
			scope := p.GetProjectName()
			if p.GetTaskName() != "" {
				scope = fmt.Sprintf("%s / %s", scope, p.GetTaskName())
			}
			if scope == "" {
				scope = "(all work)"
			}

			remaining := formatDuration(p.GetRemainingSeconds())
			if p.GetRemainingSeconds() < 0 {
				remaining = "+" + formatDuration(-p.GetRemainingSeconds())
			}

			rows = append(rows, map[string]any{
				"goal":       p.GetGoalId(),
				"scope":      scope,
				"period":     periodLabel(p.GetPeriod()),
				"window":     formatDate(p.GetPeriodStart()) + " to " + formatDate(p.GetPeriodEnd()),
				"target":     formatDuration(p.GetTargetSeconds()),
				"actual":     formatDuration(p.GetActualSeconds()),
				"remaining":  remaining,
				"percentage": p.GetPercentage(),
				"met":        p.GetMet(),
			})
		}

		return render(table{
			Columns: []string{
				"goal", "scope", "period", "window",
				"target", "actual", "remaining", "percentage", "met",
			},
			Rows: rows,
		})
	})
}

func runReportHeatmap(_ *cobra.Command, _ []string) error {
	from, err := parseDate(reportOpts.from)
	if err != nil {
		return err
	}
	to, err := parseDate(reportOpts.to)
	if err != nil {
		return err
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := reportClient(conn).GetActivityHeatmap(
			ctx,
			&timeloggerv1.GetActivityHeatmapRequest{
				From:       from,
				To:         to,
				ProjectIds: toUint64Slice(reportOpts.projects),
			},
		)
		if err != nil {
			return err
		}

		rows := make([]map[string]any, 0, len(resp.GetDays()))
		for _, d := range resp.GetDays() {
			rows = append(rows, map[string]any{
				"date":     formatDate(d.GetDate()),
				"duration": formatDuration(d.GetTotalSeconds()),
				"seconds":  d.GetTotalSeconds(),
				"entries":  d.GetEntryCount(),
				"level":    d.GetLevel(),
				// A block-character bar makes the shape of the data visible in
				// a terminal without needing a chart.
				"bar": strings.Repeat("█", int(d.GetLevel())),
			})
		}

		return render(table{
			Columns: []string{"date", "duration", "entries", "level", "bar"},
			Rows:    rows,
			Summary: []string{
				fmt.Sprintf("Total: %s, busiest day %s (%s)",
					formatDuration(resp.GetTotalSeconds()),
					formatDuration(resp.GetMaxSeconds()),
					resp.GetTimezone()),
			},
		})
	})
}

func runReportStreaks(_ *cobra.Command, _ []string) error {
	req := &timeloggerv1.GetStreaksRequest{}

	if reportOpts.from != "" {
		from, err := parseDate(reportOpts.from)
		if err != nil {
			return err
		}
		req.From = from
	}
	if reportOpts.to != "" {
		to, err := parseDate(reportOpts.to)
		if err != nil {
			return err
		}
		req.To = to
	}
	if streakMinimum != "" {
		minimum, err := parseDuration(streakMinimum)
		if err != nil {
			return err
		}
		req.MinimumSeconds = int64(minimum.Seconds())
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := reportClient(conn).GetStreaks(ctx, req)
		if err != nil {
			return err
		}

		rows := make([]map[string]any, 0, len(resp.GetStreaks()))
		for _, s := range resp.GetStreaks() {
			rows = append(rows, map[string]any{
				"from":     formatDate(s.GetStartDate()),
				"to":       formatDate(s.GetEndDate()),
				"days":     s.GetDays(),
				"duration": formatDuration(s.GetTotalSeconds()),
				"seconds":  s.GetTotalSeconds(),
			})
		}

		summary := []string{fmt.Sprintf("Active days: %d", resp.GetActiveDays())}
		if resp.GetCurrent() != nil {
			summary = append(summary,
				fmt.Sprintf("Current streak: %d days", resp.GetCurrent().GetDays()))
		} else {
			summary = append(summary, "Current streak: none")
		}
		if resp.GetLongest() != nil {
			summary = append(summary,
				fmt.Sprintf("Longest streak: %d days", resp.GetLongest().GetDays()))
		}

		return render(table{
			Columns: []string{"from", "to", "days", "duration"},
			Rows:    rows,
			Summary: summary,
		})
	})
}
