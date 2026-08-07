package cmd

import (
	"context"
	"fmt"

	"github.com/spf13/cobra"
	"google.golang.org/grpc"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// --- create project --------------------------------------------------------

var createProjectColor string

var createProjectCmd = &cobra.Command{
	Use:   "project <name>",
	Short: "Create a project",
	Args:  cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := projectClient(conn).CreateProject(ctx, &timeloggerv1.CreateProjectRequest{
				Name:  args[0],
				Color: createProjectColor,
			})
			if err != nil {
				return err
			}
			return renderProjects([]*timeloggerv1.Project{resp.GetProject()})
		})
	},
}

// --- list projects ---------------------------------------------------------

type listProjectsOptions struct {
	includeArchived bool
	stats           bool
}

var listProjectsOpts listProjectsOptions

var listProjectsCmd = &cobra.Command{
	Use:     "projects",
	Aliases: []string{"project"},
	Short:   "List projects",
	RunE: func(_ *cobra.Command, _ []string) error {
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := projectClient(conn).ListProjects(ctx, &timeloggerv1.ListProjectsRequest{
				IncludeArchived: listProjectsOpts.includeArchived,
				IncludeStats:    listProjectsOpts.stats,
			})
			if err != nil {
				return err
			}
			return renderProjects(resp.GetProjects())
		})
	},
}

// --- update project --------------------------------------------------------

type updateProjectOptions struct {
	name  string
	color string
}

var updateProjectOpts updateProjectOptions

var updateProjectCmd = &cobra.Command{
	Use:   "project <id>",
	Short: "Rename or recolour a project",
	Args:  cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		id, err := parseID(args[0])
		if err != nil {
			return err
		}

		mask := changedFlags(cmd, map[string]string{"name": "name", "color": "color"})
		if len(mask) == 0 {
			return fmt.Errorf("nothing to update: pass --name or --color")
		}

		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := projectClient(conn).UpdateProject(ctx, &timeloggerv1.UpdateProjectRequest{
				Id:         id,
				UpdateMask: mask,
				Name:       updateProjectOpts.name,
				Color:      updateProjectOpts.color,
			})
			if err != nil {
				return err
			}
			return renderProjects([]*timeloggerv1.Project{resp.GetProject()})
		})
	},
}

// --- archive / delete project ---------------------------------------------

var unarchiveProject bool

var archiveProjectCmd = &cobra.Command{
	Use:   "archive <id>",
	Short: "Archive a project so it stops appearing in pickers",
	Long: `Archive a project.

Archiving is the right way to retire a project that already has tracked time:
it hides the project without touching its history. Use --undo to bring it back.`,
	Args: cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		id, err := parseID(args[0])
		if err != nil {
			return err
		}
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			resp, err := projectClient(conn).SetProjectArchived(
				ctx,
				&timeloggerv1.SetProjectArchivedRequest{Id: id, Archived: !unarchiveProject},
			)
			if err != nil {
				return err
			}
			return renderProjects([]*timeloggerv1.Project{resp.GetProject()})
		})
	},
}

var deleteProjectCmd = &cobra.Command{
	Use:   "project <id>",
	Short: "Delete a project that has no tracked time",
	Args:  cobra.ExactArgs(1),
	RunE: func(_ *cobra.Command, args []string) error {
		id, err := parseID(args[0])
		if err != nil {
			return err
		}
		return withClient(func(ctx context.Context, conn *grpc.ClientConn) error {
			if _, err := projectClient(conn).DeleteProject(
				ctx, &timeloggerv1.DeleteProjectRequest{Id: id},
			); err != nil {
				return err
			}
			fmt.Printf("Deleted project %d.\n", id)
			return nil
		})
	},
}

func init() {
	createCmd.AddCommand(createProjectCmd)
	listCmd.AddCommand(listProjectsCmd)
	updateCmd.AddCommand(updateProjectCmd)
	deleteCmd.AddCommand(deleteProjectCmd)
	rootCmd.AddCommand(archiveProjectCmd)

	createProjectCmd.Flags().StringVar(&createProjectColor, "color", "",
		"hex colour for the UI, e.g. #4285F4")

	listProjectsCmd.Flags().BoolVarP(&listProjectsOpts.includeArchived, "all", "a", false,
		"include archived projects")
	listProjectsCmd.Flags().BoolVar(&listProjectsOpts.stats, "stats", false,
		"include entry counts and total time")

	updateProjectCmd.Flags().StringVar(&updateProjectOpts.name, "name", "", "new name")
	updateProjectCmd.Flags().StringVar(&updateProjectOpts.color, "color", "", "new colour")

	archiveProjectCmd.Flags().BoolVar(&unarchiveProject, "undo", false, "unarchive instead")
}

func renderProjects(projects []*timeloggerv1.Project) error {
	rows := make([]map[string]any, 0, len(projects))
	for _, p := range projects {
		rows = append(rows, map[string]any{
			"id":       p.GetId(),
			"name":     p.GetName(),
			"color":    p.GetColor(),
			"archived": p.GetArchived(),
			"entries":  p.GetEntryCount(),
			"total":    formatDuration(p.GetTotalSeconds()),
			"seconds":  p.GetTotalSeconds(),
		})
	}

	return render(table{
		Columns: []string{"id", "name", "color", "archived", "entries", "total"},
		Rows:    rows,
	})
}
