import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _displayFormat = DateFormat('EEE, MMM d, yyyy');
  static final DateFormat _shortFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _timeFormat = DateFormat('h:mm a');

  /// e.g. Mon, Jan 15, 2026
  static String display(DateTime date) => _displayFormat.format(date);

  /// e.g. Jan 15, 2026
  static String short(DateTime date) => _shortFormat.format(date);

  /// e.g. 9:30 AM
  static String time(DateTime date) => _timeFormat.format(date);

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
