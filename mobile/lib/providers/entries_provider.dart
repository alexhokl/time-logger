import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import '../data/pending_entry_repository.dart';
import '../proto/timelogger/v1/common.pb.dart';
import '../proto/timelogger/v1/entry.pb.dart';
import 'clients.dart';

/// The inclusive day range an entry list covers.
class DateRange {
  const DateRange(this.from, this.to);

  final DateTime from;
  final DateTime to;

  /// The seven days ending today, which is the default view.
  factory DateRange.thisWeek() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateRange(today.subtract(const Duration(days: 6)), today);
  }

  factory DateRange.today() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateRange(today, today);
  }

  @override
  bool operator ==(Object other) =>
      other is DateRange && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}

/// The range the entry list currently covers. Riverpod 3 removed
/// StateProvider, so this is a small Notifier instead.
class EntryRangeNotifier extends Notifier<DateRange> {
  @override
  DateRange build() => DateRange.thisWeek();

  void set(DateRange range) => state = range;
}

final entryRangeProvider = NotifierProvider<EntryRangeNotifier, DateRange>(
  EntryRangeNotifier.new,
);

/// Result of an entry query, carrying the total alongside the page so the UI
/// can show "6h15m this week" without summing the visible rows itself, which
/// would be wrong whenever the result is paginated.
class EntryPage {
  const EntryPage({required this.entries, required this.totalSeconds});

  final List<TimeEntry> entries;
  final int totalSeconds;

  static const empty = EntryPage(entries: [], totalSeconds: 0);
}

class EntriesNotifier extends AsyncNotifier<EntryPage> {
  @override
  Future<EntryPage> build() async {
    // Rebuilds whenever the range changes or the timer stops, so a freshly
    // finished entry appears without the user pulling to refresh.
    final range = ref.watch(entryRangeProvider);
    return _load(range);
  }

  Future<EntryPage> _load(DateRange range) async {
    final client = ref.read(entryClientProvider);
    final config = ref.read(appConfigProvider);

    final filter = EntryFilter(
      from: Timestamp.fromDateTime(range.from),
      // The upper bound is exclusive on the server, so the day after the last
      // day requested is what makes the range inclusive at both ends.
      to: Timestamp.fromDateTime(range.to.add(const Duration(days: 1))),
    );

    final response = await client.listEntries(
      ListEntriesRequest(
        filter: filter,
        order: SortOrder.SORT_ORDER_DESC,
        page: PageRequest(pageSize: config.pageSize),
      ),
    );

    return EntryPage(
      entries: response.entries,
      totalSeconds: response.totalSeconds.toInt(),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(ref.read(entryRangeProvider)));
  }

  /// Creates an entry, falling back to the offline queue when the server
  /// cannot be reached.
  ///
  /// Returns true when the entry reached the server and false when it was
  /// queued, so the caller can tell the user which happened rather than
  /// implying success either way.
  Future<bool> create({
    required String description,
    required DateTime start,
    required DateTime end,
    int projectId = 0,
    int taskId = 0,
    List<String> tags = const [],
  }) async {
    final durationSeconds = end.difference(start).inSeconds;

    final request = CreateEntryRequest(
      description: description,
      projectId: Int64(projectId),
      taskId: Int64(taskId),
      tags: tags,
      time: TimeSpec(
        startTime: Timestamp.fromDateTime(start.toUtc()),
        endTime: Timestamp.fromDateTime(end.toUtc()),
      ),
    );

    try {
      await ref.read(entryClientProvider).createEntry(request);
      await refresh();
      return true;
    } catch (_) {
      final repository = await ref.read(pendingEntryRepositoryProvider.future);
      await repository.enqueue(
        PendingEntry(
          description: description,
          projectId: projectId == 0 ? null : projectId,
          taskId: taskId == 0 ? null : taskId,
          tags: tags,
          startTime: start,
          endTime: end,
          durationSeconds: durationSeconds,
          createdAt: DateTime.now(),
        ),
      );
      ref.invalidate(pendingCountProvider);
      return false;
    }
  }

  Future<void> updateEntry(
    TimeEntry entry, {
    String? description,
    DateTime? start,
    DateTime? end,
    int? projectId,
    int? taskId,
    List<String>? tags,
  }) async {
    final request = UpdateEntryRequest(id: entry.id);
    final mask = <String>[];

    if (description != null) {
      request.description = description;
      mask.add('description');
    }
    if (projectId != null) {
      request.projectId = Int64(projectId);
      mask.add('project_id');
    }
    if (taskId != null) {
      request.taskId = Int64(taskId);
      mask.add('task_id');
    }
    if (tags != null) {
      request.tags.addAll(tags);
      mask.add('tags');
    }
    if (start != null || end != null) {
      final spec = TimeSpec();
      if (start != null) {
        spec.startTime = Timestamp.fromDateTime(start.toUtc());
        mask.add('start_time');
      }
      if (end != null) {
        spec.endTime = Timestamp.fromDateTime(end.toUtc());
        mask.add('end_time');
      }
      request.time = spec;
    }

    request.updateMask.addAll(mask);

    await ref.read(entryClientProvider).updateEntry(request);
    await refresh();
  }

  Future<void> delete(Int64 id) async {
    await ref.read(entryClientProvider).deleteEntry(DeleteEntryRequest(id: id));
    await refresh();
  }

  Future<void> copyToToday(List<Int64> ids) async {
    final now = DateTime.now();
    await ref
        .read(entryClientProvider)
        .copyEntries(
          CopyEntriesRequest(
            entryIds: ids,
            targetDate: Date(year: now.year, month: now.month, day: now.day),
          ),
        );
    await refresh();
  }
}

final entriesProvider = AsyncNotifierProvider<EntriesNotifier, EntryPage>(
  EntriesNotifier.new,
);

/// How many entries are waiting to be uploaded. Surfaced in the UI so queued
/// work is never invisible to the user.
final pendingCountProvider = FutureProvider<int>((ref) async {
  final repository = await ref.read(pendingEntryRepositoryProvider.future);
  return repository.count();
});
