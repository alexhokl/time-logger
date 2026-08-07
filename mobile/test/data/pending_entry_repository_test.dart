import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:time_logger/data/local_database.dart';
import 'package:time_logger/data/pending_entry_repository.dart';

void main() {
  // sqflite has no implementation on the desktop test runner, so the FFI
  // variant backs these tests against a real in-memory SQLite database rather
  // than a mock. The queue is the one place where a storage bug would lose the
  // user's work, so exercising the real engine is worth it.
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late PendingEntryRepository repository;

  setUp(() async {
    db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: LocalDatabase.createSchema,
      ),
    );
    repository = PendingEntryRepository(db);
  });

  tearDown(() async => db.close());

  PendingEntry sample({String description = 'work', DateTime? createdAt}) {
    final start = DateTime(2026, 8, 7, 9);
    return PendingEntry(
      description: description,
      projectId: 3,
      tags: const ['billable', 'focus'],
      startTime: start,
      endTime: start.add(const Duration(hours: 2)),
      durationSeconds: 7200,
      createdAt: createdAt ?? DateTime(2026, 8, 7, 11),
    );
  }

  test('an enqueued entry round-trips with every field intact', () async {
    await repository.enqueue(sample());

    final pending = await repository.pending();
    expect(pending, hasLength(1));

    final entry = pending.single;
    expect(entry.description, 'work');
    expect(entry.projectId, 3);
    expect(entry.taskId, isNull);
    expect(entry.tags, ['billable', 'focus']);
    expect(entry.durationSeconds, 7200);
    expect(entry.startTime, DateTime(2026, 8, 7, 9));
    expect(entry.endTime, DateTime(2026, 8, 7, 11));
  });

  test('entries are replayed in the order the user created them', () async {
    await repository.enqueue(
      sample(description: 'second', createdAt: DateTime(2026, 8, 7, 12)),
    );
    await repository.enqueue(
      sample(description: 'first', createdAt: DateTime(2026, 8, 7, 10)),
    );

    final pending = await repository.pending();
    expect(pending.map((e) => e.description), ['first', 'second']);
  });

  test('count reflects the queue length', () async {
    expect(await repository.count(), 0);
    await repository.enqueue(sample());
    await repository.enqueue(sample());
    expect(await repository.count(), 2);
  });

  test('markSynced is the only thing that removes queued work', () async {
    final id = await repository.enqueue(sample());
    expect(await repository.count(), 1);

    await repository.markSynced(id);
    expect(await repository.count(), 0);
  });

  test('a failed upload keeps the entry and records why', () async {
    final id = await repository.enqueue(sample());

    await repository.markFailed(id, 'project 3 does not exist');

    // Losing the user's work because the server was briefly unhappy would be
    // far worse than a stuck queue item, so the entry must survive.
    final pending = await repository.pending();
    expect(pending, hasLength(1));
    expect(pending.single.lastError, 'project 3 does not exist');
  });

  test('an entry with no tags round-trips as an empty list', () async {
    await repository.enqueue(
      PendingEntry(
        startTime: DateTime(2026, 8, 7, 9),
        endTime: DateTime(2026, 8, 7, 10),
        durationSeconds: 3600,
        createdAt: DateTime(2026, 8, 7, 10),
      ),
    );

    final entry = (await repository.pending()).single;
    expect(entry.tags, isEmpty);
    expect(entry.description, '');
  });
}
