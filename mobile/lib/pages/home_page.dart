import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/catalog_provider.dart';
import '../providers/entries_provider.dart';
import '../providers/intent_provider.dart';
import '../providers/timer_provider.dart';
import '../proto/timelogger/v1/entry.pb.dart';
import '../proto/timelogger/v1/project.pb.dart';
import '../services/intent_service.dart';
import '../ui/common.dart';

/// The stopwatch screen: start, watch, stop.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _descriptionController = TextEditingController();
  int _projectId = 0;
  int _taskId = 0;
  String _taskName = '';

  /// Task and tags only ever arrive with a pre-fill from another app; the
  /// form has no fields of its own for them, so they are shown as removable
  /// chips instead.
  List<String> _tags = const [];

  @override
  void initState() {
    super.initState();
    // fireImmediately covers a draft set before this page first built.
    ref.listenManual(timerDraftProvider, (_, draft) {
      if (draft != null) _applyDraft(draft);
    }, fireImmediately: true);
  }

  Future<void> _applyDraft(StartTimerIntent draft) async {
    ref.read(timerDraftProvider.notifier).clear();

    final running = await ref.read(runningTimerProvider.future);
    if (!mounted) return;
    if (running != null) {
      showMessage(context, 'A timer is already running', kind: MessageKind.error);
      return;
    }

    final resolved = await resolveNames(
      ref,
      project: draft.project,
      task: draft.task,
    );
    if (!mounted) return;

    setState(() {
      _descriptionController.text = draft.description ?? '';
      _projectId = resolved.projectId;
      _taskId = resolved.taskId;
      _taskName = resolved.taskName;
      _tags = draft.tags;
    });
    if (resolved.missing.isNotEmpty) {
      showMessage(
        context,
        '${resolved.missing.join(', ')} not found',
        kind: MessageKind.error,
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final running = ref.watch(runningTimerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(runningTimerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: running.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.read(runningTimerProvider.notifier).refresh(),
        ),
        data: (entry) =>
            entry == null ? _buildIdle(context) : _buildRunning(context, entry),
      ),
    );
  }

  Widget _buildIdle(BuildContext context) {
    final projects = ref.watch(projectsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Icon(
            Icons.timer_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'What are you working on?',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _start(),
          ),
          const SizedBox(height: 16),
          projects.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const Text('Projects unavailable'),
            data: (list) => _buildProjectPicker(list),
          ),
          if (_taskId != 0 || _tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                if (_taskId != 0)
                  InputChip(
                    avatar: const Icon(Icons.task_alt),
                    label: Text(_taskName),
                    onDeleted: () => setState(() => _taskId = 0),
                  ),
                for (final tag in _tags)
                  InputChip(
                    label: Text(tag),
                    onDeleted: () => setState(
                      () => _tags = _tags.where((t) => t != tag).toList(),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _start,
            icon: const Icon(Icons.play_arrow),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Start'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectPicker(List<Project> projects) {
    return DropdownButtonFormField<int>(
      // Keyed on the value so a pre-fill from another app replaces the
      // selection; initialValue alone is only read once.
      key: ValueKey(_projectId),
      initialValue: _projectId,
      decoration: const InputDecoration(
        labelText: 'Project',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(value: 0, child: Text('No project')),
        ...projects.map(
          (p) => DropdownMenuItem(value: p.id.toInt(), child: Text(p.name)),
        ),
      ],
      onChanged: (value) => setState(() {
        _projectId = value ?? 0;
        // A task from a pre-fill belongs to the previous project.
        _taskId = 0;
      }),
    );
  }

  Widget _buildRunning(BuildContext context, TimeEntry entry) {
    final theme = Theme.of(context);
    final start = entry.startTime.toDateTime().toLocal();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Center(
            child: Text(
              formatStopwatch(Duration(seconds: entry.durationSeconds.toInt())),
              style: theme.textTheme.displayLarge?.copyWith(
                // Tabular figures stop the clock jittering as the digits
                // change width each second.
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Started at ${formatTime(start)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: ListTile(
              title: Text(
                entry.description.isEmpty
                    ? '(no description)'
                    : entry.description,
              ),
              subtitle: Text(
                [
                  if (entry.projectName.isNotEmpty) entry.projectName,
                  if (entry.taskName.isNotEmpty) entry.taskName,
                  ...entry.tags,
                ].join(' · '),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _stop,
            icon: const Icon(Icons.stop),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Stop'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _confirmCancel,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  Future<void> _start() async {
    try {
      await ref
          .read(runningTimerProvider.notifier)
          .start(
            description: _descriptionController.text.trim(),
            projectId: _projectId,
            taskId: _taskId,
            tags: _tags,
          );
      _descriptionController.clear();
      setState(() {
        _taskId = 0;
        _tags = const [];
      });
    } catch (error) {
      if (mounted) {
        showMessage(context, describeError(error), kind: MessageKind.error);
      }
    }
  }

  Future<void> _stop() async {
    try {
      final entry = await ref.read(runningTimerProvider.notifier).stop();
      // The entry list is stale the moment a timer stops, so refresh it rather
      // than leaving the user to pull down.
      ref.invalidate(entriesProvider);
      if (mounted) {
        showMessage(
          context,
          'Recorded ${formatDuration(entry.durationSeconds.toInt())}',
        );
      }
    } catch (error) {
      if (mounted) {
        showMessage(context, describeError(error), kind: MessageKind.error);
      }
    }
  }

  Future<void> _confirmCancel() async {
    // Discarding loses work irrecoverably, so it is the one action that asks
    // first.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard this timer?'),
        content: const Text('The elapsed time will not be recorded.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(runningTimerProvider.notifier).cancel();
    } catch (error) {
      if (mounted) {
        showMessage(context, describeError(error), kind: MessageKind.error);
      }
    }
  }
}
