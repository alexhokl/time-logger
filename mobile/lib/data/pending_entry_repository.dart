import 'package:sqflite/sqflite.dart';

/// An entry the user created while the server was unreachable.
///
/// A pending entry is always a completed block of work: a running timer cannot
/// be queued, because the server enforces that only one may exist and the
/// client has no way to reserve that slot while offline.
class PendingEntry {
  const PendingEntry({
    this.id,
    this.description = '',
    this.projectId,
    this.taskId,
    this.tags = const [],
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
    required this.createdAt,
    this.lastError,
  });

  final int? id;
  final String description;
  final int? projectId;
  final int? taskId;
  final List<String> tags;
  final DateTime startTime;
  final DateTime endTime;
  final int durationSeconds;
  final DateTime createdAt;

  /// The error from the most recent failed sync attempt, kept so the user can
  /// see why an item is stuck rather than watching it sit in the queue.
  final String? lastError;

  Map<String, Object?> toRow() => {
    if (id != null) 'id': id,
    'description': description,
    'project_id': projectId,
    'task_id': taskId,
    'tags': tags.join(','),
    'start_time_ms': startTime.millisecondsSinceEpoch,
    'end_time_ms': endTime.millisecondsSinceEpoch,
    'duration_seconds': durationSeconds,
    'created_at_ms': createdAt.millisecondsSinceEpoch,
    'last_error': lastError,
  };

  static PendingEntry fromRow(Map<String, Object?> row) {
    final rawTags = (row['tags'] as String?) ?? '';
    return PendingEntry(
      id: row['id'] as int?,
      description: (row['description'] as String?) ?? '',
      projectId: row['project_id'] as int?,
      taskId: row['task_id'] as int?,
      tags: rawTags.isEmpty ? const [] : rawTags.split(','),
      startTime: DateTime.fromMillisecondsSinceEpoch(
        row['start_time_ms'] as int,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(row['end_time_ms'] as int),
      durationSeconds: (row['duration_seconds'] as int?) ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row['created_at_ms'] as int,
      ),
      lastError: row['last_error'] as String?,
    );
  }
}

/// Persistent queue of entries awaiting upload.
class PendingEntryRepository {
  const PendingEntryRepository(this._db);

  final Database _db;

  Future<int> enqueue(PendingEntry entry) {
    return _db.insert('pending_entries', entry.toRow());
  }

  /// Returns the queue oldest first, so entries are replayed in the order the
  /// user created them.
  Future<List<PendingEntry>> pending() async {
    final rows = await _db.query('pending_entries', orderBy: 'created_at_ms ASC');
    return rows.map(PendingEntry.fromRow).toList();
  }

  Future<int> count() async {
    final result = await _db.rawQuery(
      'SELECT COUNT(*) AS count FROM pending_entries',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Removes an entry once the server has confirmed it stored it. This is the
  /// only path that deletes queued work.
  Future<void> markSynced(int id) {
    return _db.delete('pending_entries', where: 'id = ?', whereArgs: [id]);
  }

  /// Records why an upload failed without dropping the entry, so a transient
  /// server error does not cost the user their work.
  Future<void> markFailed(int id, String error) {
    return _db.update(
      'pending_entries',
      {'last_error': error},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> discard(int id) {
    return _db.delete('pending_entries', where: 'id = ?', whereArgs: [id]);
  }
}
