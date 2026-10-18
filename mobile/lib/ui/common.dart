import 'package:flutter/material.dart';
import 'package:flutter_helper/format.dart';

// The formatting helpers, empty and error states and showMessage are shared
// with the other apps through flutter_helper. They are re-exported so pages
// import one UI library.
export 'package:flutter_helper/format.dart';
export 'package:flutter_helper/grpc.dart' show describeError;
export 'package:flutter_helper/ui.dart';

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
