import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formats a number of seconds the way the rest of the app does: "2h30m",
/// "45m", "30s". Kept in one place so the timer, the entry list and the
/// reports cannot drift apart.
String formatDuration(int seconds) {
  if (seconds <= 0) return '0m';

  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;

  if (hours > 0 && minutes > 0) {
    return '${hours}h${minutes.toString().padLeft(2, '0')}m';
  }
  if (hours > 0) return '${hours}h';
  if (minutes > 0) return '${minutes}m';
  return '${seconds}s';
}

/// Formats a duration as a stopwatch reading, "1:23:45" or "23:45". Used only
/// for the running timer, where a monospaced ticking clock reads better than
/// the compact form.
String formatStopwatch(int seconds) {
  if (seconds < 0) seconds = 0;

  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainder = seconds % 60;

  final mm = minutes.toString().padLeft(2, '0');
  final ss = remainder.toString().padLeft(2, '0');

  return hours > 0 ? '$hours:$mm:$ss' : '$mm:$ss';
}

final _dayFormat = DateFormat('EEE d MMM');
final _timeFormat = DateFormat('HH:mm');

String formatDay(DateTime date) => _dayFormat.format(date);
String formatTime(DateTime date) => _timeFormat.format(date);

/// Renders a day heading such as "Today" or "Fri 7 Aug" with the day's total.
class DayHeader extends StatelessWidget {
  const DayHeader({super.key, required this.date, required this.totalSeconds});

  final DateTime date;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);

    String label;
    if (day == today) {
      label = 'Today';
    } else if (day == today.subtract(const Duration(days: 1))) {
      label = 'Yesterday';
    } else {
      label = formatDay(day);
    }

    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.titleSmall),
          Text(
            formatDuration(totalSeconds),
            style: theme.textTheme.titleSmall?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// A consistent empty state, so every list looks the same when there is
/// nothing to show.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

/// A consistent error state that keeps the underlying message visible.
///
/// The raw error is shown rather than a generic apology because the most
/// common failure here is a connection problem, and the actual message tells
/// the user whether the server is down or the address is wrong.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Could not reach the server',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              describeError(error),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

}

/// Trims a gRPC error down to its message. The full toString includes the
/// status code and transport details, which are noise on a phone screen but
/// hide the one line the user can act on.
String describeError(Object error) {
  final text = error.toString();
  final match = RegExp(r'message:\s*(.+?)(?:,\s*details|$)').firstMatch(text);
  return match?.group(1)?.trim() ?? text;
}

/// Shows a message in a snack bar, guarding against a widget that has been
/// disposed while an await was in flight.
void showMessage(BuildContext context, String message, {bool isError = false}) {
  if (!context.mounted) return;

  final theme = Theme.of(context);
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? theme.colorScheme.errorContainer : null,
      ),
    );
}
