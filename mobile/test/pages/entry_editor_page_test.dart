import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_logger/pages/entry_editor_page.dart';
import 'package:time_logger/providers/catalog_provider.dart';
import 'package:time_logger/proto/timelogger/v1/project.pb.dart';
import 'package:time_logger/proto/timelogger/v1/task.pb.dart';
import 'package:time_logger/services/intent_service.dart';

class _FakeProjects extends ProjectsNotifier {
  @override
  Future<List<Project>> build() async => [
    Project(id: Int64(1), name: 'acme'),
  ];
}

Widget wrap(CreateEntryIntent initial) {
  return ProviderScope(
    overrides: [
      projectsProvider.overrideWith(_FakeProjects.new),
      tasksProvider.overrideWith(
        (ref, projectId) async => [
          Task(id: Int64(5), name: 'api', projectId: Int64(1)),
        ],
      ),
    ],
    child: MaterialApp(home: EntryEditorPage(initial: initial)),
  );
}

void main() {
  testWidgets('a pre-fill from another app fills the form', (tester) async {
    await tester.pumpWidget(
      wrap(
        CreateEntryIntent(
          description: 'code review',
          project: 'ACME',
          task: 'API',
          tags: const ['billable'],
          date: DateTime(2026, 10, 16),
          start: (hour: 9, minute: 0),
          duration: const Duration(minutes: 90),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('code review'), findsOneWidget);
    expect(find.text('billable'), findsOneWidget);
    expect(find.text('Fri 16 Oct'), findsOneWidget);
    expect(find.text('Duration: 1h30m'), findsOneWidget);
    expect(find.text('acme'), findsOneWidget);
    expect(find.text('api'), findsOneWidget);
  });

  testWidgets('an unknown project is reported and left unset', (tester) async {
    await tester.pumpWidget(
      wrap(const CreateEntryIntent(project: 'nowhere')),
    );
    await tester.pumpAndSettle();

    expect(find.text('No project'), findsOneWidget);
    expect(find.text("Project 'nowhere' not found"), findsOneWidget);
  });
}
