import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/entries_provider.dart';
import '../providers/sync_service.dart';
import '../proto/timelogger/v1/entry.pb.dart';
import '../ui/common.dart';
import 'entry_editor_page.dart';

/// The timesheet: entries grouped by day, newest first.
class EntriesPage extends ConsumerWidget {
  const EntriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entriesProvider);
    final range = ref.watch(entryRangeProvider);
    final pending = ref.watch(pendingCountProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
        actions: [
          PopupMenuButton<DateRange>(
            icon: const Icon(Icons.calendar_today),
            onSelected: (value) =>
                ref.read(entryRangeProvider.notifier).set(value),
            itemBuilder: (context) => [
              PopupMenuItem(value: DateRange.today(), child: const Text('Today')),
              PopupMenuItem(
                value: DateRange.thisWeek(),
                child: const Text('Last 7 days'),
              ),
              PopupMenuItem(
                value: _lastDays(30),
                child: const Text('Last 30 days'),
              ),
            ],
          ),
        ],
        bottom: pending > 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: _PendingBanner(count: pending),
              )
            : null,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context, null),
        child: const Icon(Icons.add),
      ),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.read(entriesProvider.notifier).refresh(),
        ),
        data: (page) => _buildList(context, ref, page, range),
      ),
    );
  }

  static DateRange _lastDays(int days) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateRange(today.subtract(Duration(days: days - 1)), today);
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    EntryPage page,
    DateRange range,
  ) {
    if (page.entries.isEmpty) {
      return const EmptyState(
        icon: Icons.event_busy,
        message: 'No time logged in this period.',
      );
    }

    // Entries arrive newest first and already sorted, so grouping is a single
    // pass rather than a sort plus a group.
    final groups = <DateTime, List<TimeEntry>>{};
    for (final entry in page.entries) {
      final local = entry.startTime.toDateTime().toLocal();
      final day = DateTime(local.year, local.month, local.day);
      groups.putIfAbsent(day, () => []).add(entry);
    }

    final days = groups.keys.toList();

    return RefreshIndicator(
      onRefresh: () => ref.read(entriesProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          for (final day in days) ...[
            SliverStickyHeader(
              header: DayHeader(
                date: day,
                totalSeconds: groups[day]!.fold<int>(
                  0,
                  (sum, e) => sum + e.durationSeconds.toInt(),
                ),
              ),
              entries: groups[day]!,
              onTap: (entry) => _openEditor(context, entry),
              onDelete: (entry) =>
                  ref.read(entriesProvider.notifier).delete(entry.id),
            ),
          ],
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Total ${formatDuration(page.totalSeconds)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openEditor(BuildContext context, TimeEntry? entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => EntryEditorPage(entry: entry)),
    );
  }
}

/// A day heading followed by its entries.
class SliverStickyHeader extends StatelessWidget {
  const SliverStickyHeader({
    super.key,
    required this.header,
    required this.entries,
    required this.onTap,
    required this.onDelete,
  });

  final Widget header;
  final List<TimeEntry> entries;
  final void Function(TimeEntry) onTap;
  final void Function(TimeEntry) onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: entries.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return header;

        final entry = entries[index - 1];
        return Dismissible(
          key: ValueKey(entry.id.toInt()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Theme.of(context).colorScheme.errorContainer,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(Icons.delete),
          ),
          confirmDismiss: (_) async {
            onDelete(entry);
            return true;
          },
          child: _EntryTile(entry: entry, onTap: () => onTap(entry)),
        );
      },
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry, required this.onTap});

  final TimeEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final start = entry.startTime.toDateTime().toLocal();
    final subtitle = [
      if (entry.projectName.isNotEmpty) entry.projectName,
      if (entry.taskName.isNotEmpty) entry.taskName,
      ...entry.tags,
    ].join(' · ');

    return ListTile(
      onTap: onTap,
      title: Text(
        entry.description.isEmpty ? '(no description)' : entry.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      leading: Text(formatTime(start)),
      trailing: Text(
        formatDuration(entry.durationSeconds.toInt()),
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}

/// Tells the user that work is queued locally and offers to retry now.
class _PendingBanner extends ConsumerWidget {
  const _PendingBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.tertiaryContainer,
      child: InkWell(
        onTap: () async {
          final result = await ref.read(syncServiceProvider).sync();
          if (!context.mounted) return;
          showMessage(
            context,
            result.failed > 0
                ? 'Uploaded ${result.uploaded}, ${result.failed} still pending'
                : 'Uploaded ${result.uploaded} entries',
            kind: result.failed > 0 ? MessageKind.error : MessageKind.info,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.cloud_upload_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$count entry${count == 1 ? '' : 's'} waiting to upload',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const Text('Sync now'),
            ],
          ),
        ),
      ),
    );
  }
}
