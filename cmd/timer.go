package cmd

import (
	"context"
	"fmt"

	"github.com/spf13/cobra"
	"google.golang.org/grpc"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

type startOptions struct {
	description string
	project     uint64
	task        uint64
	tags        []string
	at          string
}

var startOpts startOptions

var startCmd = &cobra.Command{
	Use:   "start [description]",
	Short: "Start the timer",
	Long: `Start tracking time.

The description can be given either as a positional argument or with
--description, so both of these work:

  time-logger start "reviewing the migration plan"
  time-logger start -m "reviewing the migration plan" --project 3

Only one timer may run at a time; starting a second one fails rather than
silently stopping the first.`,
	Args: cobra.MaximumNArgs(1),
	RunE: runStart,
}

type stopOptions struct {
	at          string
	description string
}

var stopOpts stopOptions

var stopCmd = &cobra.Command{
	Use:   "stop",
	Short: "Stop the running timer",
	RunE:  runStop,
}

var statusCmd = &cobra.Command{
	Use:     "status",
	Aliases: []string{"st"},
	Short:   "Show the running timer",
	RunE:    runStatus,
}

var cancelCmd = &cobra.Command{
	Use:   "cancel",
	Short: "Discard the running timer without recording it",
	RunE:  runCancel,
}

func init() {
	rootCmd.AddCommand(startCmd, stopCmd, statusCmd, cancelCmd)

	startFlags := startCmd.Flags()
	startFlags.StringVarP(&startOpts.description, "description", "m", "", "what you are working on")
	startFlags.Uint64VarP(&startOpts.project, "project", "p", 0, "project id")
	startFlags.Uint64VarP(&startOpts.task, "task", "t", 0, "task id")
	startFlags.StringSliceVar(&startOpts.tags, "tag", nil, "tag to attach (repeatable)")
	startFlags.StringVar(&startOpts.at, "at", "",
		"backdate the start, e.g. '2026-08-07 09:30' (default now)")

	stopFlags := stopCmd.Flags()
	stopFlags.StringVar(&stopOpts.at, "at", "", "override the stop time (default now)")
	stopFlags.StringVarP(&stopOpts.description, "description", "m", "",
		"set the description while stopping")
}

func runStart(cmd *cobra.Command, args []string) error {
	description := startOpts.description
	if len(args) == 1 && description == "" {
		description = args[0]
	}

	start, err := parseTimestamp(startOpts.at)
	if err != nil {
		return err
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := timerClient(conn).StartTimer(ctx, &timeloggerv1.StartTimerRequest{
			Description: description,
			ProjectId:   startOpts.project,
			TaskId:      startOpts.task,
			Tags:        startOpts.tags,
			StartTime:   start,
		})
		if err != nil {
			return err
		}
		return renderEntries([]*timeloggerv1.TimeEntry{resp.GetEntry()}, 0)
	})
}

func runStop(cmd *cobra.Command, _ []string) error {
	end, err := parseTimestamp(stopOpts.at)
	if err != nil {
		return err
	}

	req := &timeloggerv1.StopTimerRequest{EndTime: end}
	// Only send the description when the flag was actually used, so stopping a
	// timer without -m does not blank out the description it was started with.
	if cmd.Flags().Changed("description") {
		req.Description = &stopOpts.description
	}

	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := timerClient(conn).StopTimer(ctx, req)
		if err != nil {
			return err
		}
		return renderEntries([]*timeloggerv1.TimeEntry{resp.GetEntry()}, 0)
	})
}

func runStatus(_ *cobra.Command, _ []string) error {
	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		resp, err := timerClient(conn).GetRunningTimer(ctx, &timeloggerv1.GetRunningTimerRequest{})
		if err != nil {
			return err
		}

		if resp.GetEntry() == nil {
			// In text mode a sentence is friendlier than an empty table; the
			// machine-readable formats still get a well-formed empty result.
			if rootOpts.format == formatText {
				fmt.Println("No timer is running.")
				return nil
			}
			return renderEntries(nil, 0)
		}

		return renderEntries([]*timeloggerv1.TimeEntry{resp.GetEntry()}, 0)
	})
}

func runCancel(_ *cobra.Command, _ []string) error {
	return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
		if _, err := timerClient(conn).CancelRunningTimer(
			ctx, &timeloggerv1.CancelRunningTimerRequest{},
		); err != nil {
			return err
		}
		fmt.Println("Timer cancelled.")
		return nil
	})
}
