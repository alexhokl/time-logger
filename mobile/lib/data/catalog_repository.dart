import 'package:fixnum/fixnum.dart';
import 'package:sqflite/sqflite.dart';

import '../proto/timelogger/v1/project.pb.dart';
import '../proto/timelogger/v1/tag.pb.dart';
import '../proto/timelogger/v1/task.pb.dart';

/// Local cache of the reference data used to populate pickers.
///
/// The cache is replaced wholesale on every refresh rather than merged. A
/// merge would have to reason about deletions on the server, and getting that
/// wrong would leave a project in the picker that no longer exists; replacing
/// makes the cache trivially consistent with the last successful fetch.
class CatalogRepository {
  const CatalogRepository(this._db);

  final Database _db;

  Future<void> replaceProjects(List<Project> projects) async {
    await _db.transaction((txn) async {
      await txn.delete('projects');
      for (final project in projects) {
        await txn.insert('projects', {
          'id': project.id.toInt(),
          'name': project.name,
          'color': project.color,
          'archived': project.archived ? 1 : 0,
        });
      }
    });
  }

  Future<List<Project>> projects({bool includeArchived = false}) async {
    final rows = await _db.query(
      'projects',
      where: includeArchived ? null : 'archived = 0',
      orderBy: 'name ASC',
    );
    return rows
        .map(
          (row) => Project()
            ..id = Int64(row['id'] as int)
            ..name = row['name'] as String
            ..color = (row['color'] as String?) ?? ''
            ..archived = (row['archived'] as int) == 1,
        )
        .toList();
  }

  Future<void> replaceTasks(List<Task> tasks) async {
    await _db.transaction((txn) async {
      await txn.delete('tasks');
      for (final task in tasks) {
        await txn.insert('tasks', {
          'id': task.id.toInt(),
          'name': task.name,
          'project_id': task.projectId.toInt(),
          'project_name': task.projectName,
          'archived': task.archived ? 1 : 0,
        });
      }
    });
  }

  Future<List<Task>> tasks({int? projectId, bool includeArchived = false}) async {
    final conditions = <String>[];
    final args = <Object?>[];

    if (!includeArchived) conditions.add('archived = 0');
    if (projectId != null) {
      conditions.add('project_id = ?');
      args.add(projectId);
    }

    final rows = await _db.query(
      'tasks',
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'name ASC',
    );

    return rows
        .map(
          (row) => Task()
            ..id = Int64(row['id'] as int)
            ..name = row['name'] as String
            ..projectId = Int64(row['project_id'] as int)
            ..projectName = (row['project_name'] as String?) ?? ''
            ..archived = (row['archived'] as int) == 1,
        )
        .toList();
  }

  Future<void> replaceTags(List<Tag> tags) async {
    await _db.transaction((txn) async {
      await txn.delete('tags');
      for (final tag in tags) {
        await txn.insert('tags', {'id': tag.id.toInt(), 'name': tag.name});
      }
    });
  }

  Future<List<Tag>> tags() async {
    final rows = await _db.query('tags', orderBy: 'name ASC');
    return rows
        .map(
          (row) => Tag()
            ..id = Int64(row['id'] as int)
            ..name = row['name'] as String,
        )
        .toList();
  }

  Future<bool> get isEmpty async {
    final result = await _db.rawQuery('SELECT COUNT(*) AS count FROM projects');
    return (Sqflite.firstIntValue(result) ?? 0) == 0;
  }
}
