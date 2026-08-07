import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/report_provider.dart';
import '../proto/timelogger/v1/common.pb.dart';
import '../proto/timelogger/v1/report.pb.dart';
import '../ui/common.dart';

/// Summaries: where the week went, how the goals are doing, and streaks.
class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reports'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'This week'),
              Tab(text: 'Goals'),
              Tab(text: 'Streaks'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_WeeklyTab(), _GoalsTab(), _StreaksTab()],
        ),
      ),
    );
  }
}

class _WeeklyTab extends ConsumerWidget {
  const _WeeklyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(weeklyReportProvider);
    final grouping = ref.watch(reportGroupingProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SegmentedButton<GroupBy>(
            segments: const [
              ButtonSegment(
                value: GroupBy.GROUP_BY_PROJECT,
                label: Text('Project'),
              ),
              ButtonSegment(value: GroupBy.GROUP_BY_TASK, label: Text('Task')),
              ButtonSegment(value: GroupBy.GROUP_BY_TAG, label: Text('Tag')),
              ButtonSegment(value: GroupBy.GROUP_BY_DAY, label: Text('Day')),
            ],
            selected: {grouping},
            onSelectionChanged: (selection) =>
                ref.read(reportGroupingProvider.notifier).set(selection.first),
          ),
        ),
        Expanded(
          child: report.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ErrorState(
              error: error,
              onRetry: () => ref.invalidate(weeklyReportProvider),
            ),
            data: (data) => _buildReport(context, data),
          ),
        ),
      ],
    );
  }

  Widget _buildReport(BuildContext context, PeriodReport report) {
    if (report.rows.isEmpty) {
      return const EmptyState(
        icon: Icons.bar_chart,
        message: 'Nothing tracked this week yet.',
      );
    }

    final theme = Theme.of(context);
    // Bars are scaled against the largest row rather than the report total, so
    // the smaller rows stay legible instead of collapsing to a sliver.
    final maxSeconds = report.rows
        .map((r) => r.totalSeconds.toInt())
        .reduce((a, b) => a > b ? a : b);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                formatDuration(report.totalSeconds.toInt()),
                style: theme.textTheme.displaySmall,
              ),
              Text(
                '${report.entryCount} entries · ${report.timezone}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const Divider(),
        for (final row in report.rows)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        row.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      formatDuration(row.totalSeconds.toInt()),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: maxSeconds == 0
                      ? 0
                      : row.totalSeconds.toInt() / maxSeconds,
                ),
                const SizedBox(height: 2),
                Text(
                  '${row.percentage.toStringAsFixed(1)}% · '
                  '${row.entryCount} entries',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _GoalsTab extends ConsumerWidget {
  const _GoalsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(goalReportProvider);

    return report.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState(
        error: error,
        onRetry: () => ref.invalidate(goalReportProvider),
      ),
      data: (data) {
        if (data.progress.isEmpty) {
          return const EmptyState(
            icon: Icons.flag_outlined,
            message: 'No goals are active today.',
          );
        }

        final theme = Theme.of(context);

        return ListView.builder(
          itemCount: data.progress.length,
          itemBuilder: (context, index) {
            final goal = data.progress[index];
            final scope = [
              if (goal.projectName.isNotEmpty) goal.projectName,
              if (goal.taskName.isNotEmpty) goal.taskName,
            ].join(' / ');

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          scope.isEmpty ? 'All work' : scope,
                          style: theme.textTheme.titleMedium,
                        ),
                        if (goal.met)
                          Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      // Clamped so an overshoot renders as a full bar rather
                      // than overflowing the widget.
                      value: (goal.percentage / 100).clamp(0.0, 1.0),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${formatDuration(goal.actualSeconds.toInt())} of '
                      '${formatDuration(goal.targetSeconds.toInt())} '
                      '(${goal.percentage.toStringAsFixed(0)}%)',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      goal.remainingSeconds.toInt() > 0
                          ? '${formatDuration(goal.remainingSeconds.toInt())} to go'
                          : '${formatDuration(-goal.remainingSeconds.toInt())} over target',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _StreaksTab extends ConsumerWidget {
  const _StreaksTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streaks = ref.watch(streaksProvider);

    return streaks.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState(
        error: error,
        onRetry: () => ref.invalidate(streaksProvider),
      ),
      data: (data) => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StreakStat(
                  label: 'Current',
                  value: data.hasCurrent() ? '${data.current.days}' : '0',
                ),
                _StreakStat(
                  label: 'Longest',
                  value: data.hasLongest() ? '${data.longest.days}' : '0',
                ),
                _StreakStat(label: 'Active days', value: '${data.activeDays}'),
              ],
            ),
          ),
          const Divider(),
          if (data.streaks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('No streaks in the last year.')),
            )
          else
            for (final streak in data.streaks)
              ListTile(
                leading: const Icon(Icons.local_fire_department_outlined),
                title: Text('${streak.days} days'),
                subtitle: Text(
                  '${_date(streak.startDate)} to ${_date(streak.endDate)}',
                ),
                trailing: Text(formatDuration(streak.totalSeconds.toInt())),
              ),
        ],
      ),
    );
  }

  static String _date(Date d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

class _StreakStat extends StatelessWidget {
  const _StreakStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineMedium),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
