package cmd

import (
	"context"
	"fmt"

	"github.com/spf13/cobra"
	"google.golang.org/grpc"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// --- tasks -----------------------------------------------------------------

var createTaskProject uint64

var createTaskCmd = &cobra.Command{
	Use:   "task <name>",
	Short: "Create a task under a project",
	Args:  cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := taskClient(conn).CreateTask(ctx, &timeloggerv1.CreateTaskRequest{
				Name:      args[0],
				ProjectId: createTaskProject,
			})
			if err != nil {
				return err
			}
			return renderTasks([]*timeloggerv1.Task{resp.GetTask()})
		})
	},
}

type listTasksOptions struct {
	project         uint64
	includeArchived bool
	stats           bool
}

var listTasksOpts listTasksOptions

var listTasksCmd = &cobra.Command{
	Use:     "tasks",
	Aliases: []string{"task"},
	Short:   "List tasks",
	RunE: func(_ *cobra.Command, _ []string) error {
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := taskClient(conn).ListTasks(ctx, &timeloggerv1.ListTasksRequest{
				ProjectId:       listTasksOpts.project,
				IncludeArchived: listTasksOpts.includeArchived,
				IncludeStats:    listTasksOpts.stats,
			})
			if err != nil {
				return err
			}
			return renderTasks(resp.GetTasks())
		})
	},
}

type updateTaskOptions struct {
	name    string
	project uint64
}

var updateTaskOpts updateTaskOptions

var updateTaskCmd = &cobra.Command{
	Use:   "task <id>",
	Short: "Rename a task or move it to another project",
	Long: `Rename a task or move it to another project.

Moving a task carries its existing time entries with it, so the entries never
end up pointing at a project the task no longer belongs to.`,
	Args: cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		id, err := parseID(args[0])
		if err != nil {
			return err
		}

		mask := changedFlags(cmd, map[string]string{"name": "name", "project": "project_id"})
		if len(mask) == 0 {
			return fmt.Errorf("nothing to update: pass --name or --project")
		}

		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := taskClient(conn).UpdateTask(ctx, &timeloggerv1.UpdateTaskRequest{
				Id:         id,
				UpdateMask: mask,
				Name:       updateTaskOpts.name,
				ProjectId:  updateTaskOpts.project,
			})
			if err != nil {
				return err
			}
			return renderTasks([]*timeloggerv1.Task{resp.GetTask()})
		})
	},
}

var deleteTaskCmd = &cobra.Command{
	Use:   "task <id>",
	Short: "Delete a task; its entries keep their project and time",
	Args:  cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		id, err := parseID(args[0])
		if err != nil {
			return err
		}
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			if _, err := taskClient(conn).DeleteTask(
				ctx, &timeloggerv1.DeleteTaskRequest{Id: id},
			); err != nil {
				return err
			}
			fmt.Printf("Deleted task %d.\n", id)
			return nil
		})
	},
}

// --- tags ------------------------------------------------------------------

var createTagCmd = &cobra.Command{
	Use:   "tag <name>",
	Short: "Create a tag",
	Long: `Create a tag.

Tags are also created automatically the first time they are used on an entry,
so this is only needed to pre-register one.`,
	Args: cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := tagClient(conn).CreateTag(ctx, &timeloggerv1.CreateTagRequest{Name: args[0]})
			if err != nil {
				return err
			}
			return renderTags([]*timeloggerv1.Tag{resp.GetTag()})
		})
	},
}

var listTagsStats bool

var listTagsCmd = &cobra.Command{
	Use:     "tags",
	Aliases: []string{"tag"},
	Short:   "List tags",
	RunE: func(_ *cobra.Command, _ []string) error {
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := tagClient(conn).ListTags(ctx, &timeloggerv1.ListTagsRequest{
				IncludeStats: listTagsStats,
			})
			if err != nil {
				return err
			}
			return renderTags(resp.GetTags())
		})
	},
}

var renameTagName string

var renameTagCmd = &cobra.Command{
	Use:   "tag <id>",
	Short: "Rename a tag everywhere it is used",
	Args:  cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		id, err := parseID(args[0])
		if err != nil {
			return err
		}
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := tagClient(conn).RenameTag(ctx, &timeloggerv1.RenameTagRequest{
				Id:   id,
				Name: renameTagName,
			})
			if err != nil {
				return err
			}
			return renderTags([]*timeloggerv1.Tag{resp.GetTag()})
		})
	},
}

var deleteTagCmd = &cobra.Command{
	Use:   "tag <id>",
	Short: "Delete a tag; entries keep their time and lose only the label",
	Args:  cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		id, err := parseID(args[0])
		if err != nil {
			return err
		}
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			if _, err := tagClient(conn).DeleteTag(
				ctx, &timeloggerv1.DeleteTagRequest{Id: id},
			); err != nil {
				return err
			}
			fmt.Printf("Deleted tag %d.\n", id)
			return nil
		})
	},
}

func init() {
	createCmd.AddCommand(createTaskCmd, createTagCmd)
	listCmd.AddCommand(listTasksCmd, listTagsCmd)
	updateCmd.AddCommand(updateTaskCmd, renameTagCmd)
	deleteCmd.AddCommand(deleteTaskCmd, deleteTagCmd)

	createTaskCmd.Flags().Uint64VarP(&createTaskProject, "project", "p", 0, "project id")
	_ = createTaskCmd.MarkFlagRequired("project")

	listTasksCmd.Flags().Uint64VarP(&listTasksOpts.project, "project", "p", 0,
		"restrict to one project")
	listTasksCmd.Flags().BoolVarP(&listTasksOpts.includeArchived, "all", "a", false,
		"include archived tasks")
	listTasksCmd.Flags().BoolVar(&listTasksOpts.stats, "stats", false,
		"include entry counts and total time")

	updateTaskCmd.Flags().StringVar(&updateTaskOpts.name, "name", "", "new name")
	updateTaskCmd.Flags().Uint64VarP(&updateTaskOpts.project, "project", "p", 0,
		"move to this project")

	listTagsCmd.Flags().BoolVar(&listTagsStats, "stats", false,
		"include entry counts and total time")

	renameTagCmd.Flags().StringVar(&renameTagName, "name", "", "new name")
	_ = renameTagCmd.MarkFlagRequired("name")
}

func renderTasks(tasks []*timeloggerv1.Task) error {
	rows := make([]map[string]any, 0, len(tasks))
	for _, t := range tasks {
		rows = append(rows, map[string]any{
			"id":       t.GetId(),
			"name":     t.GetName(),
			"project":  t.GetProjectName(),
			"archived": t.GetArchived(),
			"entries":  t.GetEntryCount(),
			"total":    formatDuration(t.GetTotalSeconds()),
			"seconds":  t.GetTotalSeconds(),
		})
	}

	return render(table{
		Columns: []string{"id", "name", "project", "archived", "entries", "total"},
		Rows:    rows,
	})
}

func renderTags(tags []*timeloggerv1.Tag) error {
	rows := make([]map[string]any, 0, len(tags))
	for _, t := range tags {
		rows = append(rows, map[string]any{
			"id":      t.GetId(),
			"name":    t.GetName(),
			"entries": t.GetEntryCount(),
			"total":   formatDuration(t.GetTotalSeconds()),
			"seconds": t.GetTotalSeconds(),
		})
	}

	return render(table{
		Columns: []string{"id", "name", "entries", "total"},
		Rows:    rows,
	})
}
