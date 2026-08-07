import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../proto/timelogger/v1/report.pb.dart';
import '../proto/timelogger/v1/settings.pb.dart';
import 'clients.dart';

/// Which dimension the report screen groups by.
class ReportGroupingNotifier extends Notifier<GroupBy> {
  @override
  GroupBy build() => GroupBy.GROUP_BY_PROJECT;

  void set(GroupBy groupBy) => state = groupBy;
}

final reportGroupingProvider =
    NotifierProvider<ReportGroupingNotifier, GroupBy>(
      ReportGroupingNotifier.new,
    );

/// The weekly summary for the current week.
final weeklyReportProvider = FutureProvider<PeriodReport>((ref) async {
  final groupBy = ref.watch(reportGroupingProvider);
  final client = ref.watch(reportClientProvider);

  final response = await client.getWeeklyReport(
    GetWeeklyReportRequest(options: ReportOptions(groupBy: groupBy)),
  );
  return response.report;
});

/// Progress against every goal in force today.
final goalReportProvider = FutureProvider<GetGoalReportResponse>((ref) async {
  final client = ref.watch(reportClientProvider);
  return client.getGoalReport(GetGoalReportRequest());
});

/// Consecutive-day tracking streaks over the past year.
final streaksProvider = FutureProvider<GetStreaksResponse>((ref) async {
  final client = ref.watch(reportClientProvider);
  return client.getStreaks(GetStreaksRequest());
});

/// The user's server-side settings, which govern timezone and rounding.
class SettingsNotifier extends AsyncNotifier<Settings> {
  @override
  Future<Settings> build() async {
    final client = ref.watch(settingsClientProvider);
    final response = await client.getSettings(GetSettingsRequest());
    return response.settings;
  }

  Future<void> updateTimezone(String timezone) =>
      _update(Settings(timezone: timezone), ['timezone']);

  Future<void> updateWeekStart(DayOfWeek day) =>
      _update(Settings(weekStartsOn: day), ['week_starts_on']);

  Future<void> updateRounding(int minutes) =>
      _update(Settings(roundingMinutes: minutes), ['rounding_minutes']);

  Future<void> _update(Settings settings, List<String> mask) async {
    final client = ref.read(settingsClientProvider);
    final response = await client.updateSettings(
      UpdateSettingsRequest(settings: settings, updateMask: mask),
    );
    state = AsyncData(response.settings);
  }
}

final serverSettingsProvider =
    AsyncNotifierProvider<SettingsNotifier, Settings>(SettingsNotifier.new);
