import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../proto/timelogger/v1/project.pb.dart';
import '../proto/timelogger/v1/tag.pb.dart';
import '../proto/timelogger/v1/task.pb.dart';
import 'clients.dart';

/// Projects, served from the server when reachable and from the local cache
/// otherwise.
///
/// The fallback is what makes the app usable on a train: without it, every
/// picker would be empty and no entry could be attributed to anything. A
/// successful fetch refreshes the cache as a side effect, so the cache is
/// always the last thing the server actually said.
class ProjectsNotifier extends AsyncNotifier<List<Project>> {
  @override
  Future<List<Project>> build() => _load();

  Future<List<Project>> _load() async {
    final repository = await ref.read(catalogRepositoryProvider.future);

    try {
      final client = ref.read(projectClientProvider);
      final response = await client.listProjects(
        ListProjectsRequest(includeStats: false),
      );
      await repository.replaceProjects(response.projects);
      return response.projects;
    } catch (_) {
      // Falling back rather than surfacing the error is deliberate: a stale
      // project list is far more useful than an error screen, and the entries
      // page reports the connection problem separately.
      return repository.projects();
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> create(String name, {String color = ''}) async {
    final client = ref.read(projectClientProvider);
    await client.createProject(CreateProjectRequest(name: name, color: color));
    await refresh();
  }

  Future<void> setArchived(Int64 id, {required bool archived}) async {
    final client = ref.read(projectClientProvider);
    await client.setProjectArchived(
      SetProjectArchivedRequest(id: id, archived: archived),
    );
    await refresh();
  }

  Future<void> delete(Int64 id) async {
    final client = ref.read(projectClientProvider);
    await client.deleteProject(DeleteProjectRequest(id: id));
    await refresh();
  }
}

final projectsProvider =
    AsyncNotifierProvider<ProjectsNotifier, List<Project>>(
      ProjectsNotifier.new,
    );

/// Tasks for a given project, or every task when the argument is zero.
final tasksProvider = FutureProvider.family<List<Task>, int>((ref, projectId) async {
  final repository = await ref.read(catalogRepositoryProvider.future);

  try {
    final client = ref.read(taskClientProvider);
    final response = await client.listTasks(
      ListTasksRequest(projectId: Int64(projectId)),
    );
    // Only the unfiltered fetch may replace the cache; a per-project response
    // would otherwise wipe out every other project's tasks.
    if (projectId == 0) {
      await repository.replaceTasks(response.tasks);
    }
    return response.tasks;
  } catch (_) {
    return repository.tasks(projectId: projectId == 0 ? null : projectId);
  }
});

/// Tags, cached the same way as projects.
class TagsNotifier extends AsyncNotifier<List<Tag>> {
  @override
  Future<List<Tag>> build() => _load();

  Future<List<Tag>> _load() async {
    final repository = await ref.read(catalogRepositoryProvider.future);

    try {
      final client = ref.read(tagClientProvider);
      final response = await client.listTags(ListTagsRequest());
      await repository.replaceTags(response.tags);
      return response.tags;
    } catch (_) {
      return repository.tags();
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> delete(Int64 id) async {
    final client = ref.read(tagClientProvider);
    await client.deleteTag(DeleteTagRequest(id: id));
    await refresh();
  }
}

final tagsProvider = AsyncNotifierProvider<TagsNotifier, List<Tag>>(
  TagsNotifier.new,
);
