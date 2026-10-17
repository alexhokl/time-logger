import 'package:flutter/services.dart';

/// An action requested by another app through an Android intent (share sheet,
/// text selection menu, deep link or launcher shortcut).
///
/// Every intent only pre-fills a form. Deep links are browsable, so acting on
/// one directly would let any web page start a timer or record an entry.
sealed class AppIntent {
  const AppIntent();
}

/// Switches to the timer tab with the idle form pre-filled.
///
/// Project and task are names rather than IDs because the sender (Tasker, an
/// on-device model) cannot know the IDs; the page resolves them.
class StartTimerIntent extends AppIntent {
  const StartTimerIntent({
    this.description,
    this.project,
    this.task,
    this.tags = const [],
  });

  final String? description;
  final String? project;
  final String? task;
  final List<String> tags;
}

/// Opens the entry editor pre-filled. Any of [start], [end] and [duration]
/// may be missing; the editor fills the gaps.
class CreateEntryIntent extends AppIntent {
  const CreateEntryIntent({
    this.description,
    this.project,
    this.task,
    this.tags = const [],
    this.date,
    this.start,
    this.end,
    this.duration,
  });

  final String? description;
  final String? project;
  final String? task;
  final List<String> tags;

  /// The local day of the entry, at midnight.
  final DateTime? date;

  /// Local wall-clock times.
  final ({int hour, int minute})? start;
  final ({int hour, int minute})? end;

  final Duration? duration;

  /// Works out the entry's start and end from whichever of [date], [start],
  /// [end] and [duration] were given. A missing end means "now" on [date],
  /// and a missing length is an hour, matching the editor's own default of an
  /// hour ending now. An end earlier than the start is left for the editor to
  /// roll over to the next day.
  ({DateTime start, DateTime end}) resolveSpan(DateTime now) {
    final day = date ?? DateTime(now.year, now.month, now.day);
    DateTime at(({int hour, int minute}) t) =>
        DateTime(day.year, day.month, day.day, t.hour, t.minute);
    final length = duration ?? const Duration(hours: 1);

    final s = start;
    final e = end;
    if (s != null && e != null) return (start: at(s), end: at(e));
    if (s != null) return (start: at(s), end: at(s).add(length));

    final endAt =
        e != null ? at(e) : at((hour: now.hour, minute: now.minute));
    return (start: endAt.subtract(length), end: endAt);
  }
}

class OpenEntriesIntent extends AppIntent {
  const OpenEntriesIntent();
}

class OpenReportsIntent extends AppIntent {
  const OpenReportsIntent();
}

/// Receives intents forwarded by MainActivity over a method channel.
class IntentService {
  static const String deepLinkScheme = 'timelogger';
  static const MethodChannel _channel = MethodChannel(
    'dev.alexho.time_logger/intents',
  );

  /// Returns the intent that launched the app, if any.
  Future<AppIntent?> getInitialIntent() async {
    try {
      final raw = await _channel.invokeMapMethod<String, String?>(
        'getInitialIntent',
      );
      return raw == null ? null : toAppIntent(raw);
    } on MissingPluginException {
      // Not running on Android
      return null;
    }
  }

  /// Calls [onIntent] for every intent received while the app is running.
  void listen(void Function(AppIntent) onIntent) {
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'onIntent' || call.arguments is! Map) return;
      final raw = Map<String, String?>.from(call.arguments as Map);
      final intent = toAppIntent(raw);
      if (intent != null) onIntent(intent);
    });
  }

  void dispose() {
    _channel.setMethodCallHandler(null);
  }

  /// Converts the map sent by MainActivity into an [AppIntent].
  static AppIntent? toAppIntent(Map<String, String?> raw) {
    switch (raw['action']) {
      case 'send':
      case 'process_text':
        return parseSharedText(raw['text'] ?? '');
      case 'view':
        return parseDeepLink(raw['uri'] ?? '');
      default:
        return null;
    }
  }

  /// Parses `timelogger://timer`, `timelogger://entry/new`,
  /// `timelogger://entries` and `timelogger://reports`.
  ///
  /// An invalid parameter is dropped on its own rather than rejecting the
  /// link, so one typo in a Tasker task still opens a mostly filled form.
  static AppIntent? parseDeepLink(String link) {
    final uri = Uri.tryParse(link);
    if (uri == null || uri.scheme != deepLinkScheme) return null;
    final params = uri.queryParameters;

    switch (uri.host) {
      case 'timer':
        if (uri.path.isNotEmpty && uri.path != '/') return null;
        return StartTimerIntent(
          description: _nonEmpty(params['description']),
          project: _nonEmpty(params['project']),
          task: _nonEmpty(params['task']),
          tags: parseTags(params['tags']),
        );
      case 'entry':
        if (uri.path != '/new' && uri.path != '/new/') return null;
        return CreateEntryIntent(
          description: _nonEmpty(params['description']),
          project: _nonEmpty(params['project']),
          task: _nonEmpty(params['task']),
          tags: parseTags(params['tags']),
          date: parseDate(params['date']),
          start: parseTime(params['start']),
          end: parseTime(params['end']),
          duration: parseDuration(params['duration']),
        );
      case 'entries':
        return const OpenEntriesIntent();
      case 'reports':
        return const OpenReportsIntent();
      default:
        return null;
    }
  }

  /// Turns shared or selected text into an intent.
  ///
  /// Text with a duration ("code review 1h30m") describes work already done,
  /// so it opens the entry editor. Anything else, typically a ticket title, is
  /// most useful as the description of a timer about to start.
  static AppIntent parseSharedText(String text) {
    final match = _durationInText.firstMatch(text);
    final duration = match == null ? null : parseDuration(match.group(0));
    if (match == null || duration == null) {
      return StartTimerIntent(description: _clean(text));
    }
    return CreateEntryIntent(
      description: _clean(text.replaceRange(match.start, match.end, ' ')),
      duration: duration,
    );
  }

  static final RegExp _hoursMinutes = RegExp(
    r'^(?:(\d+(?:\.\d+)?)\s*h(?:ours?|rs?)?)?\s*(?:(\d+)\s*m(?:in(?:ute)?s?)?)?$',
    caseSensitive: false,
  );

  // Within free text a bare number is too likely to be a ticket or room
  // number, so only numbers with a unit count as a duration.
  static final RegExp _durationInText = RegExp(
    r'\b\d+(?:\.\d+)?\s*h(?:ours?|rs?)?(?:\s*\d+\s*m(?:in(?:ute)?s?)?)?\b'
    r'|\b\d+\s*m(?:in(?:ute)?s?)?\b',
    caseSensitive: false,
  );

  /// Parses a duration the way the CLI does: a bare number is minutes, and
  /// `2h`, `1h30m`, `1.5h`, `45 min` and `2 hours` are also accepted. Returns
  /// null for anything else, including zero.
  static Duration? parseDuration(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;

    final Duration duration;
    final minutes = int.tryParse(text);
    if (minutes != null) {
      duration = Duration(minutes: minutes);
    } else {
      final m = _hoursMinutes.firstMatch(text);
      if (m == null || (m.group(1) == null && m.group(2) == null)) return null;
      final hours = double.parse(m.group(1) ?? '0');
      duration = Duration(
        minutes: (hours * 60).round() + int.parse(m.group(2) ?? '0'),
      );
    }
    return duration > Duration.zero ? duration : null;
  }

  /// Parses `YYYY-MM-DD`, rejecting dates that do not exist rather than
  /// letting [DateTime] roll 2026-02-30 over into March.
  static DateTime? parseDate(String? value) {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value?.trim() ?? '');
    if (m == null) return null;
    final year = int.parse(m.group(1)!);
    final month = int.parse(m.group(2)!);
    final day = int.parse(m.group(3)!);
    final date = DateTime(year, month, day);
    if (date.month != month || date.day != day) return null;
    return date;
  }

  /// Parses a 24-hour `HH:MM`.
  static ({int hour, int minute})? parseTime(String? value) {
    final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(value?.trim() ?? '');
    if (m == null) return null;
    final hour = int.parse(m.group(1)!);
    final minute = int.parse(m.group(2)!);
    if (hour > 23 || minute > 59) return null;
    return (hour: hour, minute: minute);
  }

  /// Splits comma-separated tags, lowercased and trimmed like the server
  /// stores them so that a pre-filled tag matches an existing one.
  static List<String> parseTags(String? value) {
    if (value == null) return const [];
    return value
        .split(',')
        .map((t) => t.trim().toLowerCase())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList();
  }

  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  static String? _clean(String text) => _nonEmpty(
    text
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^[\s,:;\-]+|[\s,:;\-]+$'), ''),
  );
}
