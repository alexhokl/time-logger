import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/entries_page.dart';
import 'pages/home_page.dart';
import 'pages/projects_page.dart';
import 'pages/reports_page.dart';
import 'pages/settings_page.dart';
import 'providers/clients.dart';

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
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

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
