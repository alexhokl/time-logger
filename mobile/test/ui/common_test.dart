import 'package:flutter_test/flutter_test.dart';
import 'package:time_logger/ui/common.dart';

void main() {
  group('formatDuration', () {
    test('renders the compact form used across the app', () {
      expect(formatDuration(0), '0m');
      expect(formatDuration(-10), '0m');
      expect(formatDuration(45), '45s');
      expect(formatDuration(900), '15m');
      expect(formatDuration(3600), '1h');
      expect(formatDuration(5400), '1h30m');
      // Minutes are zero-padded so a column of durations stays aligned.
      expect(formatDuration(3660), '1h01m');
      expect(formatDuration(123456), '34h17m');
    });
  });

  group('formatStopwatch', () {
    test('omits the hour until there is one', () {
      expect(formatStopwatch(const Duration(seconds: 0)), '00:00');
      expect(formatStopwatch(const Duration(seconds: 59)), '00:59');
      expect(formatStopwatch(const Duration(seconds: 60)), '01:00');
      expect(formatStopwatch(const Duration(seconds: 3599)), '59:59');
    });

    test('includes the hour once past it', () {
      expect(formatStopwatch(const Duration(seconds: 3600)), '1:00:00');
      expect(formatStopwatch(const Duration(seconds: 3661)), '1:01:01');
      expect(formatStopwatch(const Duration(seconds: 36000)), '10:00:00');
    });

    test('clamps a negative value rather than rendering a minus sign', () {
      expect(formatStopwatch(const Duration(seconds: -5)), '00:00');
    });
  });

  group('describeError', () {
    test('extracts the message from a gRPC status string', () {
      const raw =
          'gRPC Error (code: 9, codeName: FAILED_PRECONDITION, '
          'message: a timer is already running, details: [], rawResponse: null)';
      expect(describeError(raw), 'a timer is already running');
    });

    test('falls back to the whole string when there is no message field', () {
      expect(describeError('connection refused'), 'connection refused');
    });
  });
}
