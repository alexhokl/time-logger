import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import '../proto/timelogger/v1/entry.pb.dart';
import 'clients.dart';
import 'entries_provider.dart';

/// Outcome of a sync run, so the UI can report what happened rather than
/// silently succeeding or failing.
class SyncResult {
  const SyncResult({required this.uploaded, required this.failed});

  final int uploaded;
  final int failed;

  bool get didAnything => uploaded > 0 || failed > 0;
}

/// Drains the offline queue back to the server.
///
/// Entries are uploaded one at a time rather than as a batch. A batch is
/// atomic on the server, so a single malformed entry — say one referencing a
/// project that has since been deleted — would block every other queued entry
/// behind it indefinitely. Uploading individually lets the good entries
/// through and leaves only the genuinely broken one behind with its error
/// recorded.
class SyncService {
  const SyncService(this._ref);

  final Ref _ref;

  Future<SyncResult> sync() async {
    final repository = await _ref.read(pendingEntryRepositoryProvider.future);
    final queued = await repository.pending();
    if (queued.isEmpty) {
      return const SyncResult(uploaded: 0, failed: 0);
    }

    final client = _ref.read(entryClientProvider);
    var uploaded = 0;
    var failed = 0;

    for (final entry in queued) {
      try {
        await client.createEntry(
          CreateEntryRequest(
            description: entry.description,
            projectId: Int64(entry.projectId ?? 0),
            taskId: Int64(entry.taskId ?? 0),
            tags: entry.tags,
            time: TimeSpec(
              startTime: Timestamp.fromDateTime(entry.startTime.toUtc()),
              endTime: Timestamp.fromDateTime(entry.endTime.toUtc()),
            ),
          ),
        );
        await repository.markSynced(entry.id!);
        uploaded++;
      } catch (error) {
        // The entry stays queued: losing the user's work because the server
        // was briefly unhappy would be far worse than a stuck queue item.
        await repository.markFailed(entry.id!, error.toString());
        failed++;
      }
    }

    _ref.invalidate(pendingCountProvider);
    if (uploaded > 0) {
      _ref.invalidate(entriesProvider);
    }

    return SyncResult(uploaded: uploaded, failed: failed);
  }
}

final syncServiceProvider = Provider((ref) => SyncService(ref));
