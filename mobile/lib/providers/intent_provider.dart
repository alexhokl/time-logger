import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../proto/timelogger/v1/project.pb.dart';
import '../proto/timelogger/v1/task.pb.dart';
import '../services/intent_service.dart';
import 'catalog_provider.dart';

/// A timer pre-fill waiting to be picked up by the timer page.
///
/// The timer page is a const child of the navigation shell's IndexedStack, so
/// the shell cannot hand it a constructor argument; the draft travels through
/// a provider instead and the page clears it once applied.
class TimerDraftNotifier extends Notifier<StartTimerIntent?> {
  @override
  StartTimerIntent? build() => null;

  void set(StartTimerIntent draft) => state = draft;

  void clear() => state = null;
}

final timerDraftProvider =
    NotifierProvider<TimerDraftNotifier, StartTimerIntent?>(
      TimerDraftNotifier.new,
    );

/// Finds a project by name, ignoring case. An active project wins over an
/// archived one of the same name, since that is the one being worked on.
Project? findProjectByName(List<Project> projects, String name) {
  final matches = projects
      .where((p) => p.name.toLowerCase() == name.trim().toLowerCase())
      .toList()
    ..sort((a, b) => (a.archived ? 1 : 0).compareTo(b.archived ? 1 : 0));
  return matches.firstOrNull;
}

/// Finds a task by name, ignoring case, with the same preference as
/// [findProjectByName].
Task? findTaskByName(List<Task> tasks, String name) {
  final matches = tasks
      .where((t) => t.name.toLowerCase() == name.trim().toLowerCase())
      .toList()
    ..sort((a, b) => (a.archived ? 1 : 0).compareTo(b.archived ? 1 : 0));
  return matches.firstOrNull;
}

/// Project and task IDs resolved from names sent by another app. [missing]
/// describes each name that matched nothing, so the page can say so rather
/// than silently dropping it.
typedef ResolvedNames = ({
  int projectId,
  int taskId,
  String taskName,
  List<String> missing,
});

/// Resolves [project] and [task] names against the catalog. A task decides
/// the project, since the server rejects a task from another project.
Future<ResolvedNames> resolveNames(
  WidgetRef ref, {
  String? project,
  String? task,
}) async {
  var projectId = 0;
  var taskId = 0;
  var taskName = '';
  final missing = <String>[];

  if (project != null) {
    final found = findProjectByName(
      await ref.read(projectsProvider.future),
      project,
    );
    if (found == null) {
      missing.add("Project '$project'");
    } else {
      projectId = found.id.toInt();
    }
  }
  if (task != null) {
    final found = findTaskByName(
      await ref.read(tasksProvider(projectId).future),
      task,
    );
    if (found == null) {
      missing.add("Task '$task'");
    } else {
      taskId = found.id.toInt();
      taskName = found.name;
      projectId = found.projectId.toInt();
    }
  }
  return (
    projectId: projectId,
    taskId: taskId,
    taskName: taskName,
    missing: missing,
  );
}
