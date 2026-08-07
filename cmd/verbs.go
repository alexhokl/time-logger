package cmd

import "github.com/spf13/cobra"

// The CLI is verb-first: `time-logger create entry`, `time-logger list
// projects`. Grouping by verb keeps the top level small and makes the common
// operations discoverable from `time-logger --help` alone, at the cost of the
// nouns being one level deeper.
//
// The timer verbs (start, stop, status, cancel) are the exception and sit at
// the top level, because they are typed many times a day and reading
// `time-logger start` is worth breaking the pattern for.

var createCmd = &cobra.Command{
	Use:   "create",
	Short: "Create entries, projects, tasks, tags or goals",
}

var listCmd = &cobra.Command{
	Use:     "list",
	Aliases: []string{"ls"},
	Short:   "List entries, projects, tasks, tags or goals",
}

var getCmd = &cobra.Command{
	Use:   "get",
	Short: "Get a single record or the current settings",
}

var updateCmd = &cobra.Command{
	Use:   "update",
	Short: "Update an entry, project, task, goal or the settings",
}

var deleteCmd = &cobra.Command{
	Use:     "delete",
	Aliases: []string{"rm"},
	Short:   "Delete an entry, project, task, tag or goal",
}

var copyCmd = &cobra.Command{
	Use:   "copy",
	Short: "Copy entries onto another date",
}

var reportCmd = &cobra.Command{
	Use:   "report",
	Short: "Summarise tracked time",
}

func init() {
	rootCmd.AddCommand(createCmd, listCmd, getCmd, updateCmd, deleteCmd, copyCmd, reportCmd)
}
