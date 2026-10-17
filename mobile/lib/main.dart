import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/entries_page.dart';
import 'pages/entry_editor_page.dart';
import 'pages/home_page.dart';
import 'pages/projects_page.dart';
import 'pages/reports_page.dart';
import 'pages/settings_page.dart';
import 'providers/clients.dart';
import 'providers/intent_provider.dart';
import 'services/intent_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  // The stored connection settings are loaded before the first frame so that
  // no widget ever builds a client against the default host and then has to
  // tear it down a moment later.
  await container.read(appConfigProvider.notifier).loadFromDisk();

  runApp(
    UncontrolledProviderScope(container: container, child: const TimeLoggerApp()),
  );
}

class TimeLoggerApp extends StatelessWidget {
  const TimeLoggerApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Colors.indigo;

    return MaterialApp(
      title: 'Time Logger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const RootShell(),
    );
  }
}

/// The navigation shell.
///
/// An [IndexedStack] is used rather than swapping the body so that each tab
/// keeps its scroll position and state when the user moves between them; on a
/// tracking app the entry list in particular is annoying to lose.
class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {
  static const _timerTab = 0;
  static const _entriesTab = 1;
  static const _reportsTab = 2;

  int _index = _timerTab;
  final IntentService _intentService = IntentService();

  @override
  void initState() {
    super.initState();

    // Shortcuts, deep links and shared text from other apps. The launching
    // intent is read after the first frame so that a pushed editor has a
    // navigator to go on.
    _intentService.listen(_handleIntent);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final intent = await _intentService.getInitialIntent();
      if (intent != null && mounted) _handleIntent(intent);
    });
  }

  @override
  void dispose() {
    _intentService.dispose();
    super.dispose();
  }

  void _handleIntent(AppIntent intent) {
    switch (intent) {
      case StartTimerIntent():
        setState(() => _index = _timerTab);
        ref.read(timerDraftProvider.notifier).set(intent);
      case CreateEntryIntent():
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => EntryEditorPage(initial: intent),
          ),
        );
      case OpenEntriesIntent():
        setState(() => _index = _entriesTab);
      case OpenReportsIntent():
        setState(() => _index = _reportsTab);
    }
  }

  static const _destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.play_circle_outline),
      selectedIcon: Icon(Icons.play_circle),
      label: 'Timer',
    ),
    NavigationDestination(
      icon: Icon(Icons.list_alt_outlined),
      selectedIcon: Icon(Icons.list_alt),
      label: 'Entries',
    ),
    NavigationDestination(
      icon: Icon(Icons.insights_outlined),
      selectedIcon: Icon(Icons.insights),
      label: 'Reports',
    ),
    NavigationDestination(
      icon: Icon(Icons.folder_outlined),
      selectedIcon: Icon(Icons.folder),
      label: 'Projects',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          HomePage(),
          EntriesPage(),
          ReportsPage(),
          ProjectsPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: _destinations,
        onDestinationSelected: (index) => setState(() => _index = index),
      ),
    );
  }
}
