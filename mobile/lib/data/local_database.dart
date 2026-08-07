import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Local SQLite storage backing the app's offline behaviour.
///
/// Two distinct things live here and it is worth keeping them apart mentally:
///
///  * cached reference data (projects, tasks, tags) so the pickers can be drawn
///    without a round trip, and so the app is usable at all when disconnected;
///  * a queue of entries the user created while offline, which is drained back
///    to the server once it becomes reachable.
///
/// The cache is disposable — it is refreshed wholesale from the server and may
/// be deleted at any time. The queue is not: it is the only copy of that work
/// until it syncs, so it is never cleared except when an item is confirmed
/// stored by the server.
class LocalDatabase {
  LocalDatabase._();

  static final LocalDatabase instance = LocalDatabase._();

  static const _databaseName = 'time_logger.db';
  static const _version = 1;

  Database? _database;

  /// Overrides the database for tests, which supply an in-memory FFI instance.
  // ignore: use_setters_to_change_properties
  void overrideDatabase(Database database) => _database = database;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) return existing;

    final path = p.join(await getDatabasesPath(), _databaseName);
    final opened = await openDatabase(
      path,
      version: _version,
      onCreate: createSchema,
    );
    _database = opened;
    return opened;
  }

  /// Creates the schema. Exposed so tests can build an in-memory database with
  /// exactly the same shape as the real one.
  static Future<void> createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        color TEXT,
        archived INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        project_id INTEGER NOT NULL,
        project_name TEXT,
        archived INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    // Pending entries carry the full description of the work rather than a
    // reference to it, so the queue can still be drained after the cache has
    // been refreshed or cleared.
    await db.execute('''
      CREATE TABLE pending_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL DEFAULT '',
        project_id INTEGER,
        task_id INTEGER,
        tags TEXT NOT NULL DEFAULT '',
        start_time_ms INTEGER NOT NULL,
        end_time_ms INTEGER,
        duration_seconds INTEGER,
        created_at_ms INTEGER NOT NULL,
        last_error TEXT
      )
    ''');
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
