import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/catalog_provider.dart';
import '../proto/timelogger/v1/project.pb.dart';
import '../ui/common.dart';

/// Manages projects and, through them, tags.
class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final tags = ref.watch(tagsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Projects'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Projects'), Tab(text: 'Tags')],
          ),
          actions: [
            IconButton(
              tooltip: _showArchived ? 'Hide archived' : 'Show archived',
              icon: Icon(
                _showArchived ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () => setState(() => _showArchived = !_showArchived),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createProject,
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            projects.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorState(
                error: error,
                onRetry: () => ref.read(projectsProvider.notifier).refresh(),
              ),
              data: _buildProjectList,
            ),
            tags.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorState(
                error: error,
                onRetry: () => ref.read(tagsProvider.notifier).refresh(),
              ),
              data: (list) => list.isEmpty
                  ? const EmptyState(
                      icon: Icons.label_outline,
                      message:
                          'No tags yet.\nThey are created automatically the '
                          'first time you use one on an entry.',
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final tag = list[index];
                        return ListTile(
                          leading: const Icon(Icons.label_outline),
                          title: Text(tag.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => ref
                                .read(tagsProvider.notifier)
                                .delete(tag.id),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList(List<Project> projects) {
    final visible = _showArchived
        ? projects
        : projects.where((p) => !p.archived).toList();

    if (visible.isEmpty) {
      return const EmptyState(
        icon: Icons.folder_open,
        message: 'No projects yet.\nCreate one to start grouping your work.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(projectsProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount: visible.length,
        itemBuilder: (context, index) {
          final project = visible[index];
          return ListTile(
            leading: Icon(
              Icons.folder,
              color: _parseColor(project.color, context),
            ),
            title: Text(project.name),
            subtitle: project.archived ? const Text('Archived') : null,
            trailing: PopupMenuButton<String>(
              onSelected: (action) => _handleAction(action, project),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'archive',
                  child: Text(project.archived ? 'Unarchive' : 'Archive'),
                ),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Parses the stored hex colour, falling back to the theme when it is empty
  /// or malformed rather than throwing on a value the server treats as free
  /// text.
  Color? _parseColor(String hex, BuildContext context) {
    if (hex.isEmpty) return null;
    final cleaned = hex.replaceFirst('#', '');
    final value = int.tryParse(cleaned, radix: 16);
    if (value == null) return null;
    return Color(cleaned.length <= 6 ? 0xFF000000 | value : value);
  }

  Future<void> _handleAction(String action, Project project) async {
    final notifier = ref.read(projectsProvider.notifier);

    try {
      if (action == 'archive') {
        await notifier.setArchived(project.id, archived: !project.archived);
        return;
      }

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete ${project.name}?'),
          content: const Text(
            'A project with tracked time cannot be deleted. '
            'Archive it instead to keep its history.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await notifier.delete(project.id);
      }
    } catch (error) {
      if (mounted) showMessage(context, describeError(error), isError: true);
    }
  }

  Future<void> _createProject() async {
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New project'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    controller.dispose();

    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return;

    try {
      await ref.read(projectsProvider.notifier).create(trimmed);
    } catch (error) {
      if (mounted) showMessage(context, describeError(error), isError: true);
    }
  }
}
