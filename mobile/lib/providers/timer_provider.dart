import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixnum/fixnum.dart';

import '../proto/timelogger/v1/entry.pb.dart';
import '../proto/timelogger/v1/timer.pb.dart';
import 'clients.dart';

/// The running timer, or null when nothing is running.
///
/// This is a [StreamNotifier] rather than a plain future because the elapsed
/// time has to advance once a second on screen. Polling the server that often
/// would be wasteful, so the notifier fetches the entry once and then ticks
/// locally, re-fetching only when something actually changes it.
class RunningTimerNotifier extends AsyncNotifier<TimeEntry?> {
  Timer? _ticker;

  @override
  Future<TimeEntry?> build() async {
    ref.onDispose(() => _ticker?.cancel());

    final entry = await _fetch();
    _syncTicker(entry);
    return entry;
  }

  Future<TimeEntry?> _fetch() async {
    final client = ref.read(timerClientProvider);
    final response = await client.getRunningTimer(GetRunningTimerRequest());
    return response.hasEntry() ? response.entry : null;
  }

  /// Runs a one-second ticker only while a timer is actually running, so an
  /// idle app does no periodic work at all.
  void _syncTicker(TimeEntry? entry) {
    _ticker?.cancel();
    if (entry == null) return;

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state.value;
      if (current == null) {
        _ticker?.cancel();
        return;
      }

      // The duration is recomputed from the start time rather than
      // incremented, so a dropped tick or a suspended app cannot cause the
      // displayed time to drift away from the truth.
      final elapsed = DateTime.now()
          .difference(current.startTime.toDateTime().toLocal())
          .inSeconds;

      state = AsyncData(
        current.deepCopy()..durationSeconds = Int64(elapsed < 0 ? 0 : elapsed),
      );
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final entry = await _fetch();
      _syncTicker(entry);
      return entry;
    });
  }

  Future<void> start({
    String description = '',
    int projectId = 0,
    int taskId = 0,
    List<String> tags = const [],
  }) async {
    final client = ref.read(timerClientProvider);
    final response = await client.startTimer(
      StartTimerRequest(
        description: description,
        projectId: Int64(projectId),
        taskId: Int64(taskId),
        tags: tags,
      ),
    );

    state = AsyncData(response.entry);
    _syncTicker(response.entry);
  }

  Future<TimeEntry> stop({String? description}) async {
    final client = ref.read(timerClientProvider);
    final request = StopTimerRequest();
    if (description != null) request.description = description;

    final response = await client.stopTimer(request);

    _ticker?.cancel();
    state = const AsyncData(null);
    return response.entry;
  }

  Future<void> cancel() async {
    final client = ref.read(timerClientProvider);
    await client.cancelRunningTimer(CancelRunningTimerRequest());

    _ticker?.cancel();
    state = const AsyncData(null);
  }
}

final runningTimerProvider =
    AsyncNotifierProvider<RunningTimerNotifier, TimeEntry?>(
      RunningTimerNotifier.new,
    );
