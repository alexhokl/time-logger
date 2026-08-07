package cmd

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"strings"
	"text/tabwriter"
	"time"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// Supported output formats.
const (
	formatText = "text"
	formatJSON = "json"
	formatCSV  = "csv"
)

// validateFormat rejects an unsupported --format value up front, so a command
// does not do the work of fetching data only to fail when printing it.
func validateFormat(format string) error {
	switch format {
	case formatText, formatJSON, formatCSV:
		return nil
	default:
		return fmt.Errorf("format must be one of: %s, %s, %s", formatText, formatJSON, formatCSV)
	}
}

// table is a format-agnostic result set. Commands build one of these and hand
// it to render, which is the only place that knows about the output formats.
type table struct {
	// Columns is the ordered list of column names. It doubles as the key set
	// for each row, so the order is preserved across all three formats.
	Columns []string
	Rows    []map[string]any
	// Summary is printed after the rows in text format only; it carries totals
	// that would be meaningless as a table row.
	Summary []string
}

// render writes the table in the format selected by the --format flag,
// honouring --fields.
func render(t table) error {
	columns := filterColumns(t.Columns, selectableColumns(t), rootOpts.fields)

	switch rootOpts.format {
	case formatJSON:
		return renderJSON(t.Rows, columns)
	case formatCSV:
		return renderCSV(os.Stdout, t.Rows, columns)
	default:
		return renderText(os.Stdout, t, columns)
	}
}

// selectableColumns returns every column name --fields may name.
//
// It is the union of the declared display columns and any additional keys the
// rows carry. Commands deliberately include machine-friendly values such as
// raw `seconds` alongside the pretty `duration` without showing them in the
// default text table; those are still legitimate --fields targets, and
// silently ignoring them would make scripted use frustrating.
func selectableColumns(t table) map[string]struct{} {
	allowed := make(map[string]struct{}, len(t.Columns))
	for _, c := range t.Columns {
		allowed[c] = struct{}{}
	}
	for _, row := range t.Rows {
		for key := range row {
			allowed[key] = struct{}{}
		}
	}
	return allowed
}

// filterColumns narrows and reorders the columns to those named by --fields.
// Unknown names are ignored rather than rejected so that a single --fields
// value can be reused across commands with differing column sets. An empty or
// fully unmatched selection falls back to the default columns, because
// printing nothing at all is never what the user wanted.
func filterColumns(defaults []string, allowed map[string]struct{}, fields []string) []string {
	if len(fields) == 0 {
		return defaults
	}

	selected := make([]string, 0, len(fields))
	for _, f := range fields {
		f = strings.TrimSpace(f)
		if _, ok := allowed[f]; ok {
			selected = append(selected, f)
		}
	}
	if len(selected) == 0 {
		return defaults
	}
	return selected
}

// filterFields returns a copy of record containing only the given keys.
func filterFields(record map[string]any, fields []string) map[string]any {
	if len(fields) == 0 {
		return record
	}
	out := make(map[string]any, len(fields))
	for _, f := range fields {
		if v, ok := record[f]; ok {
			out[f] = v
		}
	}
	return out
}

func renderJSON(rows []map[string]any, columns []string) error {
	filtered := make([]map[string]any, len(rows))
	for i, r := range rows {
		filtered[i] = filterFields(r, columns)
	}

	encoded, err := json.MarshalIndent(filtered, "", "  ")
	if err != nil {
		return fmt.Errorf("failed to marshal JSON: %w", err)
	}
	fmt.Println(string(encoded))
	return nil
}

func renderCSV(w io.Writer, rows []map[string]any, columns []string) error {
	writer := csv.NewWriter(w)
	defer writer.Flush()

	if err := writer.Write(columns); err != nil {
		return fmt.Errorf("failed to write CSV header: %w", err)
	}
	for _, row := range rows {
		record := make([]string, 0, len(columns))
		for _, c := range columns {
			record = append(record, stringify(row[c]))
		}
		if err := writer.Write(record); err != nil {
			return fmt.Errorf("failed to write CSV row: %w", err)
		}
	}

	writer.Flush()
	return writer.Error()
}

func renderText(w io.Writer, t table, columns []string) error {
	if len(t.Rows) == 0 {
		if _, err := fmt.Fprintln(w, "No results."); err != nil {
			return err
		}
		return printSummary(w, t.Summary)
	}

	tw := tabwriter.NewWriter(w, 0, 0, 2, ' ', 0)

	headers := make([]string, 0, len(columns))
	for _, c := range columns {
		headers = append(headers, strings.ToUpper(strings.ReplaceAll(c, "_", " ")))
	}
	if _, err := fmt.Fprintln(tw, strings.Join(headers, "\t")); err != nil {
		return err
	}

	for _, row := range t.Rows {
		cells := make([]string, 0, len(columns))
		for _, c := range columns {
			cells = append(cells, stringify(row[c]))
		}
		if _, err := fmt.Fprintln(tw, strings.Join(cells, "\t")); err != nil {
			return err
		}
	}

	if err := tw.Flush(); err != nil {
		return err
	}
	return printSummary(w, t.Summary)
}

func printSummary(w io.Writer, summary []string) error {
	if len(summary) == 0 {
		return nil
	}
	if _, err := fmt.Fprintln(w); err != nil {
		return err
	}
	for _, line := range summary {
		if _, err := fmt.Fprintln(w, line); err != nil {
			return err
		}
	}
	return nil
}

// stringify renders a cell value. Values are kept as native types in the row
// maps so that JSON output stays typed, and are only flattened to strings here
// for the text and CSV formats.
func stringify(v any) string {
	switch value := v.(type) {
	case nil:
		return ""
	case string:
		return value
	case bool:
		if value {
			return "yes"
		}
		return "no"
	case float64:
		return fmt.Sprintf("%.2f", value)
	case time.Time:
		return value.Format(time.RFC3339)
	default:
		return fmt.Sprintf("%v", value)
	}
}

// --- Domain-specific formatting -------------------------------------------

// formatDuration renders a number of seconds as a compact human-readable
// duration such as "2h30m" or "45m". Seconds are only shown for durations
// under a minute, where they are the only meaningful unit.
func formatDuration(seconds int64) string {
	if seconds <= 0 {
		return "0m"
	}

	hours := seconds / 3600
	minutes := (seconds % 3600) / 60

	switch {
	case hours > 0 && minutes > 0:
		return fmt.Sprintf("%dh%02dm", hours, minutes)
	case hours > 0:
		return fmt.Sprintf("%dh", hours)
	case minutes > 0:
		return fmt.Sprintf("%dm", minutes)
	default:
		return fmt.Sprintf("%ds", seconds)
	}
}

// formatDate renders a proto Date as an ISO calendar date.
func formatDate(d *timeloggerv1.Date) string {
	if d == nil {
		return ""
	}
	return fmt.Sprintf("%04d-%02d-%02d", d.GetYear(), d.GetMonth(), d.GetDay())
}
