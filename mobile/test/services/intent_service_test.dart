import 'package:flutter_test/flutter_test.dart';
import 'package:time_logger/services/intent_service.dart';

void main() {
  group('parseDuration', () {
    final cases = <({String input, Duration? want})>[
      (input: '90', want: const Duration(minutes: 90)),
      (input: '2h', want: const Duration(hours: 2)),
      (input: '1h30m', want: const Duration(minutes: 90)),
      (input: '1h 30m', want: const Duration(minutes: 90)),
      (input: '1.5h', want: const Duration(minutes: 90)),
      (input: '45m', want: const Duration(minutes: 45)),
      (input: '45 min', want: const Duration(minutes: 45)),
      (input: '2 hours', want: const Duration(hours: 2)),
      (input: '0', want: null),
      (input: '-5', want: null),
      (input: 'soon', want: null),
      (input: '', want: null),
    ];

    for (final c in cases) {
      test("'${c.input}' is ${c.want ?? 'rejected'}", () {
        expect(IntentService.parseDuration(c.input), c.want);
      });
    }
  });

  group('parseDate', () {
    test('accepts a real YYYY-MM-DD day', () {
      expect(IntentService.parseDate('2026-10-16'), DateTime(2026, 10, 16));
    });

    for (final input in ['2026-02-30', '16/10/2026', '2026-1-5', 'today']) {
      test("rejects '$input' rather than guessing", () {
        expect(IntentService.parseDate(input), isNull);
      });
    }
  });

  group('parseTime', () {
    test('accepts a 24-hour time', () {
      expect(IntentService.parseTime('9:05'), (hour: 9, minute: 5));
      expect(IntentService.parseTime('23:59'), (hour: 23, minute: 59));
    });

    for (final input in ['24:00', '12:60', '9am', '']) {
      test("rejects '$input'", () {
        expect(IntentService.parseTime(input), isNull);
      });
    }
  });

  group('parseTags', () {
    test('lowercases, trims and de-duplicates like the server does', () {
      expect(IntentService.parseTags(' Billable, deep work ,,billable'), [
        'billable',
        'deep work',
      ]);
    });
  });

  group('parseDeepLink', () {
    test('a timer link carries description, project, task and tags', () {
      final intent = IntentService.parseDeepLink(
        'timelogger://timer?description=Code%20review&project=Acme&task=API&tags=Billable',
      );

      expect(intent, isA<StartTimerIntent>());
      final timer = intent! as StartTimerIntent;
      expect(timer.description, 'Code review');
      expect(timer.project, 'Acme');
      expect(timer.task, 'API');
      expect(timer.tags, ['billable']);
    });

    test('a bare timer link opens the timer with nothing filled in', () {
      final timer =
          IntentService.parseDeepLink('timelogger://timer')! as StartTimerIntent;
      expect(timer.description, isNull);
      expect(timer.project, isNull);
      expect(timer.tags, isEmpty);
    });

    test('an entry link carries every field', () {
      final entry =
          IntentService.parseDeepLink(
                'timelogger://entry/new?description=standup&date=2026-10-16'
                '&start=09:00&end=09:15&duration=1h',
              )!
              as CreateEntryIntent;

      expect(entry.description, 'standup');
      expect(entry.date, DateTime(2026, 10, 16));
      expect(entry.start, (hour: 9, minute: 0));
      expect(entry.end, (hour: 9, minute: 15));
      expect(entry.duration, const Duration(hours: 1));
    });

    test('an invalid parameter is dropped without losing the others', () {
      final entry =
          IntentService.parseDeepLink(
                'timelogger://entry/new?description=review&date=2026-13-01'
                '&start=25:00&duration=forever',
              )!
              as CreateEntryIntent;

      expect(entry.description, 'review');
      expect(entry.date, isNull);
      expect(entry.start, isNull);
      expect(entry.duration, isNull);
    });

    final hosts = <({String link, Type type})>[
      (link: 'timelogger://entries', type: OpenEntriesIntent),
      (link: 'timelogger://reports', type: OpenReportsIntent),
      (link: 'timelogger://entry/new/', type: CreateEntryIntent),
    ];
    for (final h in hosts) {
      test('${h.link} opens ${h.type}', () {
        expect(IntentService.parseDeepLink(h.link).runtimeType, h.type);
      });
    }

    for (final link in [
      'expensetracker://entry/new',
      'timelogger://entry/edit',
      'timelogger://timer/stop',
      'timelogger://settings',
      'not a link',
    ]) {
      test("'$link' is ignored", () {
        expect(IntentService.parseDeepLink(link), isNull);
      });
    }
  });

  group('parseSharedText', () {
    test('text with a duration opens the entry editor', () {
      final entry =
          IntentService.parseSharedText('Code review for acme 1h30m')
              as CreateEntryIntent;

      expect(entry.description, 'Code review for acme');
      expect(entry.duration, const Duration(minutes: 90));
    });

    test('a duration in minutes is found mid-sentence', () {
      final entry =
          IntentService.parseSharedText('standup - 15 min, ran over')
              as CreateEntryIntent;

      expect(entry.description, 'standup - , ran over');
      expect(entry.duration, const Duration(minutes: 15));
    });

    test('text without a duration pre-fills the timer instead', () {
      final timer =
          IntentService.parseSharedText('  PROJ-123 Fix login\n')
              as StartTimerIntent;

      expect(timer.description, 'PROJ-123 Fix login');
    });

    test('a bare number is not mistaken for a duration', () {
      expect(
        IntentService.parseSharedText('Room 404 meeting'),
        isA<StartTimerIntent>(),
      );
    });
  });

  group('resolveSpan', () {
    final now = DateTime(2026, 10, 17, 14, 20);

    final cases =
        <({String name, CreateEntryIntent intent, DateTime start, DateTime end})>[
          (
            name: 'nothing given defaults to an hour ending now',
            intent: const CreateEntryIntent(),
            start: DateTime(2026, 10, 17, 13, 20),
            end: now,
          ),
          (
            name: 'a duration alone ends now',
            intent: const CreateEntryIntent(duration: Duration(minutes: 90)),
            start: DateTime(2026, 10, 17, 12, 50),
            end: now,
          ),
          (
            name: 'a start and duration run forward from the start',
            intent: const CreateEntryIntent(
              start: (hour: 9, minute: 0),
              duration: Duration(minutes: 15),
            ),
            start: DateTime(2026, 10, 17, 9, 0),
            end: DateTime(2026, 10, 17, 9, 15),
          ),
          (
            name: 'an end and duration run back from the end',
            intent: const CreateEntryIntent(
              end: (hour: 18, minute: 0),
              duration: Duration(hours: 2),
            ),
            start: DateTime(2026, 10, 17, 16, 0),
            end: DateTime(2026, 10, 17, 18, 0),
          ),
          (
            name: 'a start and end win over a duration',
            intent: CreateEntryIntent(
              date: DateTime(2026, 10, 16),
              start: (hour: 9, minute: 0),
              end: (hour: 9, minute: 15),
              duration: const Duration(hours: 3),
            ),
            start: DateTime(2026, 10, 16, 9, 0),
            end: DateTime(2026, 10, 16, 9, 15),
          ),
          (
            name: 'a past date with only a duration ends at the current time of day',
            intent: CreateEntryIntent(
              date: DateTime(2026, 10, 16),
              duration: const Duration(hours: 2),
            ),
            start: DateTime(2026, 10, 16, 12, 20),
            end: DateTime(2026, 10, 16, 14, 20),
          ),
        ];

    for (final c in cases) {
      test(c.name, () {
        final span = c.intent.resolveSpan(now);
        expect(span.start, c.start);
        expect(span.end, c.end);
      });
    }
  });

  group('toAppIntent', () {
    test('routes shared and selected text through the text parser', () {
      for (final action in ['send', 'process_text']) {
        expect(
          IntentService.toAppIntent({'action': action, 'text': 'review 30m'}),
          isA<CreateEntryIntent>(),
        );
      }
    });

    test('an unknown action is ignored', () {
      expect(IntentService.toAppIntent({'action': 'dial'}), isNull);
    });
  });
}
