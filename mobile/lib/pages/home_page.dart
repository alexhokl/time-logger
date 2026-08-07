import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/catalog_provider.dart';
import '../providers/entries_provider.dart';
import '../providers/timer_provider.dart';
import '../proto/timelogger/v1/entry.pb.dart';
import '../proto/timelogger/v1/project.pb.dart';
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
      onChanged: (value) => setState(() => _projectId = value ?? 0),
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
              formatStopwatch(entry.durationSeconds.toInt()),
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
          );
      _descriptionController.clear();
    } catch (error) {
      if (mounted) {
        showMessage(context, describeError(error), isError: true);
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
        showMessage(context, describeError(error), isError: true);
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
        showMessage(context, describeError(error), isError: true);
      }
    }
  }
}
