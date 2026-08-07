import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/catalog_provider.dart';
import '../providers/entries_provider.dart';
import '../proto/timelogger/v1/entry.pb.dart';
import '../proto/timelogger/v1/project.pb.dart';
import '../ui/common.dart';

/// Creates or edits a single entry.
///
/// The form is expressed as a start time plus an end time rather than a
/// duration, because that is what the user is reconstructing when they log
/// work after the fact. The server accepts either, but a single consistent
/// form is less confusing than offering both here.
class EntryEditorPage extends ConsumerStatefulWidget {
  const EntryEditorPage({super.key, this.entry});

  /// The entry being edited, or null when creating a new one.
  final TimeEntry? entry;

  @override
  ConsumerState<EntryEditorPage> createState() => _EntryEditorPageState();
}

class _EntryEditorPageState extends ConsumerState<EntryEditorPage> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagsController;

  late DateTime _date;
  late TimeOfDay _start;
  late TimeOfDay _end;
  late int _projectId;
  late int _taskId;

  bool _saving = false;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();

    final entry = widget.entry;
    final now = DateTime.now();

    if (entry != null) {
      final start = entry.startTime.toDateTime().toLocal();
      final end = entry.hasEndTime()
          ? entry.endTime.toDateTime().toLocal()
          : start;

      _date = DateTime(start.year, start.month, start.day);
      _start = TimeOfDay.fromDateTime(start);
      _end = TimeOfDay.fromDateTime(end);
      _projectId = entry.projectId.toInt();
      _taskId = entry.taskId.toInt();
      _descriptionController = TextEditingController(text: entry.description);
      _tagsController = TextEditingController(text: entry.tags.join(', '));
    } else {
      // A new entry defaults to an hour ending now, which is the most common
      // thing someone is about to log.
      final start = now.subtract(const Duration(hours: 1));
      _date = DateTime(now.year, now.month, now.day);
      _start = TimeOfDay.fromDateTime(start);
      _end = TimeOfDay.fromDateTime(now);
      _projectId = 0;
      _taskId = 0;
      _descriptionController = TextEditingController();
      _tagsController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final tasks = ref.watch(tasksProvider(_projectId));

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit entry' : 'New entry'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving...' : 'Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(4),
            ),
            title: const Text('Date'),
            subtitle: Text(formatDay(_date)),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _TimeField(
                  label: 'Start',
                  value: _start,
                  onTap: () => _pickTime(isStart: true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _TimeField(
                  label: 'End',
                  value: _end,
                  onTap: () => _pickTime(isStart: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Duration: ${formatDuration(_durationSeconds)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          projects.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const Text('Projects unavailable'),
            data: _buildProjectPicker,
          ),
          const SizedBox(height: 16),
          tasks.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (list) => list.isEmpty
                ? const SizedBox.shrink()
                : DropdownButtonFormField<int>(
                    initialValue: _taskId,
                    decoration: const InputDecoration(
                      labelText: 'Task',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(value: 0, child: Text('No task')),
                      ...list.map(
                        (t) => DropdownMenuItem(
                          value: t.id.toInt(),
                          child: Text(t.name),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _taskId = value ?? 0),
                  ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tagsController,
            decoration: const InputDecoration(
              labelText: 'Tags',
              helperText: 'Comma separated',
              border: OutlineInputBorder(),
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
      onChanged: (value) => setState(() {
        _projectId = value ?? 0;
        // The selected task almost certainly belongs to the previous project,
        // and the server would reject the mismatch, so clear it.
        _taskId = 0;
      }),
    );
  }

  DateTime get _startDateTime => DateTime(
    _date.year,
    _date.month,
    _date.day,
    _start.hour,
    _start.minute,
  );

  /// The end instant, rolled to the next day when the end time is earlier than
  /// the start. That is how an overnight session reads to a user writing
  /// "23:00 to 01:00", and treating it as a negative duration would just be a
  /// validation error they would have to work around.
  DateTime get _endDateTime {
    var end = DateTime(_date.year, _date.month, _date.day, _end.hour, _end.minute);
    if (!end.isAfter(_startDateTime)) {
      end = end.add(const Duration(days: 1));
    }
    return end;
  }

  int get _durationSeconds =>
      _endDateTime.difference(_startDateTime).inSeconds;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : _end,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
      } else {
        _end = picked;
      }
    });
  }

  List<String> get _tags => _tagsController.text
      .split(',')
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .toList();

  Future<void> _save() async {
    setState(() => _saving = true);

    final notifier = ref.read(entriesProvider.notifier);
    final description = _descriptionController.text.trim();

    try {
      if (_isEditing) {
        await notifier.updateEntry(
          widget.entry!,
          description: description,
          start: _startDateTime,
          end: _endDateTime,
          projectId: _projectId,
          taskId: _taskId,
          tags: _tags,
        );
        if (mounted) {
          showMessage(context, 'Entry updated');
          Navigator.of(context).pop();
        }
        return;
      }

      final stored = await notifier.create(
        description: description,
        start: _startDateTime,
        end: _endDateTime,
        projectId: _projectId,
        taskId: _taskId,
        tags: _tags,
      );

      if (mounted) {
        // The user is told which of the two things happened; implying the
        // entry reached the server when it is only queued locally would be a
        // lie they might act on.
        showMessage(
          context,
          stored ? 'Entry saved' : 'Saved locally; will upload when connected',
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) showMessage(context, describeError(error), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final TimeOfDay value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(value.format(context)),
      ),
    );
  }
}
