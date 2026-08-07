import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';
import 'package:time_logger/pages/home_page.dart';
import 'package:time_logger/providers/catalog_provider.dart';
import 'package:time_logger/providers/timer_provider.dart';
import 'package:time_logger/proto/timelogger/v1/entry.pb.dart';
import 'package:time_logger/proto/timelogger/v1/project.pb.dart';

/// A stand-in for the real notifier so the widget can be exercised without a
/// server. Overriding at the provider boundary keeps the test focused on what
/// the page renders rather than on transport behaviour.
class _FakeRunningTimer extends RunningTimerNotifier {
  _FakeRunningTimer(this._entry);

  final TimeEntry? _entry;

  @override
  Future<TimeEntry?> build() async => _entry;
}

class _FakeProjects extends ProjectsNotifier {
  @override
  Future<List<Project>> build() async => [
    Project(id: Int64(1), name: 'acme'),
  ];
}

TimeEntry runningEntry() {
  final start = DateTime.now().subtract(const Duration(minutes: 30));
  return TimeEntry(
    id: Int64(7),
    description: 'writing tests',
    projectName: 'acme',
    startTime: Timestamp.fromDateTime(start.toUtc()),
    durationSeconds: Int64(1800),
    running: true,
    tags: ['billable'],
  );
}

Widget wrap(TimeEntry? entry) {
  return ProviderScope(
    overrides: [
      runningTimerProvider.overrideWith(() => _FakeRunningTimer(entry)),
      projectsProvider.overrideWith(_FakeProjects.new),
    ],
    child: const MaterialApp(home: HomePage()),
  );
}

void main() {
  testWidgets('offers to start a timer when none is running', (tester) async {
    await tester.pumpWidget(wrap(null));
    await tester.pumpAndSettle();

    expect(find.text('Start'), findsOneWidget);
    expect(find.text('What are you working on?'), findsOneWidget);
    expect(find.text('Stop'), findsNothing);
  });

  testWidgets('shows the elapsed time and stop action while running', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(runningEntry()));
    await tester.pumpAndSettle();

    // 1800 seconds renders as a stopwatch rather than the compact form.
    expect(find.text('30:00'), findsOneWidget);
    expect(find.text('writing tests'), findsOneWidget);
    expect(find.text('Stop'), findsOneWidget);
    expect(find.text('Discard'), findsOneWidget);
    expect(find.text('Start'), findsNothing);
  });

  testWidgets('discarding asks for confirmation first', (tester) async {
    await tester.pumpWidget(wrap(runningEntry()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    // Discarding loses work irrecoverably, so it must never happen on a single
    // stray tap.
    expect(find.text('Discard this timer?'), findsOneWidget);
    expect(find.text('Keep'), findsOneWidget);
  });

  testWidgets('project picker lists the available projects', (tester) async {
    await tester.pumpWidget(wrap(null));
    await tester.pumpAndSettle();

    expect(find.text('No project'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();

    expect(find.text('acme'), findsWidgets);
  });
}
