import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../providers/clients.dart';
import '../providers/entries_provider.dart';
import '../providers/report_provider.dart';
import '../providers/sync_service.dart';
import '../proto/timelogger/v1/settings.pb.dart';
import '../ui/common.dart';

/// Connection settings (stored on the device) and account settings (stored on
/// the server), kept visually separate because they behave very differently:
/// one takes effect immediately and locally, the other needs a round trip.
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late final TextEditingController _hostController;
  late final TextEditingController _portController;

  @override
  void initState() {
    super.initState();
    final config = ref.read(appConfigProvider);
    _hostController = TextEditingController(text: config.host);
    _portController = TextEditingController(text: config.port.toString());
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final serverSettings = ref.watch(serverSettingsProvider);
    final pending = ref.watch(pendingCountProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader('Connection'),
          TextField(
            controller: _hostController,
            decoration: const InputDecoration(
              labelText: 'Server host',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _portController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Port',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Use TLS'),
            subtitle: const Text('Turn off only for a local server'),
            value: config.useTls,
            onChanged: (value) => ref
                .read(appConfigProvider.notifier)
                .update(config.copyWith(useTls: value)),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _saveConnection,
            child: const Text('Save connection'),
          ),

          const SizedBox(height: 24),
          _SectionHeader('Account'),
          serverSettings.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ErrorState(
              error: error,
              onRetry: () => ref.invalidate(serverSettingsProvider),
            ),
            data: _buildServerSettings,
          ),

          const SizedBox(height: 24),
          _SectionHeader('Offline'),
          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined),
            title: Text('$pending entries waiting to upload'),
            trailing: pending > 0
                ? TextButton(onPressed: _sync, child: const Text('Sync'))
                : null,
          ),

          const SizedBox(height: 24),
          _SectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Build'),
            subtitle: Text(AppConfig.gitCommit),
          ),
        ],
      ),
    );
  }

  Widget _buildServerSettings(Settings settings) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.public),
          title: const Text('Timezone'),
          subtitle: Text(settings.timezone),
          // The timezone is deliberately read-only here: it decides which day
          // every entry and report falls into, and a free-text field would
          // invite typos that quietly shift a whole history. It is changed
          // from the CLI, where the value can be checked against the host's
          // zoneinfo database.
          trailing: const Icon(Icons.lock_outline, size: 16),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_view_week),
          title: const Text('Week starts on'),
          subtitle: Text(_weekdayName(settings.weekStartsOn)),
          onTap: () => _pickWeekStart(settings),
        ),
        ListTile(
          leading: const Icon(Icons.timelapse),
          title: const Text('Rounding'),
          subtitle: Text(
            settings.roundingMinutes == 0
                ? 'Off'
                : '${settings.roundingMinutes} minutes',
          ),
          onTap: () => _pickRounding(settings),
        ),
      ],
    );
  }

  Future<void> _saveConnection() async {
    final port = int.tryParse(_portController.text.trim());
    if (port == null || port <= 0 || port > 65535) {
      showMessage(context, 'Port must be between 1 and 65535', isError: true);
      return;
    }

    final config = ref.read(appConfigProvider);
    await ref
        .read(appConfigProvider.notifier)
        .update(
          config.copyWith(host: _hostController.text.trim(), port: port),
        );

    // Every client is derived from the channel, which is derived from the
    // config, so Riverpod rebuilds them all; the data providers still need
    // invalidating to actually re-fetch.
    ref.invalidate(serverSettingsProvider);
    ref.invalidate(entriesProvider);

    if (mounted) showMessage(context, 'Connection updated');
  }

  Future<void> _sync() async {
    final result = await ref.read(syncServiceProvider).sync();
    if (!mounted) return;
    showMessage(
      context,
      result.failed > 0
          ? 'Uploaded ${result.uploaded}, ${result.failed} failed'
          : 'Uploaded ${result.uploaded} entries',
      isError: result.failed > 0,
    );
  }

  Future<void> _pickWeekStart(Settings settings) async {
    final choice = await showDialog<DayOfWeek>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Week starts on'),
        children: [
          for (final day in [
            DayOfWeek.DAY_OF_WEEK_MONDAY,
            DayOfWeek.DAY_OF_WEEK_SATURDAY,
            DayOfWeek.DAY_OF_WEEK_SUNDAY,
          ])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, day),
              child: Text(_weekdayName(day)),
            ),
        ],
      ),
    );

    if (choice == null) return;

    try {
      await ref.read(serverSettingsProvider.notifier).updateWeekStart(choice);
      ref.invalidate(weeklyReportProvider);
    } catch (error) {
      if (mounted) showMessage(context, describeError(error), isError: true);
    }
  }

  Future<void> _pickRounding(Settings settings) async {
    final choice = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Round durations up to'),
        children: [
          for (final minutes in [0, 5, 6, 10, 15, 30])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, minutes),
              child: Text(minutes == 0 ? 'Off' : '$minutes minutes'),
            ),
        ],
      ),
    );

    if (choice == null) return;

    try {
      await ref.read(serverSettingsProvider.notifier).updateRounding(choice);
      ref.invalidate(entriesProvider);
      ref.invalidate(weeklyReportProvider);
    } catch (error) {
      if (mounted) showMessage(context, describeError(error), isError: true);
    }
  }

  static String _weekdayName(DayOfWeek day) => switch (day) {
    DayOfWeek.DAY_OF_WEEK_MONDAY => 'Monday',
    DayOfWeek.DAY_OF_WEEK_TUESDAY => 'Tuesday',
    DayOfWeek.DAY_OF_WEEK_WEDNESDAY => 'Wednesday',
    DayOfWeek.DAY_OF_WEEK_THURSDAY => 'Thursday',
    DayOfWeek.DAY_OF_WEEK_FRIDAY => 'Friday',
    DayOfWeek.DAY_OF_WEEK_SATURDAY => 'Saturday',
    DayOfWeek.DAY_OF_WEEK_SUNDAY => 'Sunday',
    _ => 'Monday',
  };
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
