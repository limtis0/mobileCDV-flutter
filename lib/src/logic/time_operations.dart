import 'package:intl/intl.dart';

/// Returns current date formatted for API
String getCurrentDateAPI() {
  final DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

/// Returns first day of currentMonth + months
/// Used for API calls
String getMonthsFromNowFirstDayAPI(int months) {
  final DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + months, 1));
}

/// Returns last day of currentMonth + months
/// Used for API calls
String getMonthsFromNowLastDayAPI(int months) {
  final DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + months + 1, -1));
}

/// Provides date to show for lessons in EventCalendar
DateTime getScheduledDate(String lessonDate) {
  return DateTime.parse(lessonDate).toLocal();
}

/// Returns seconds left until a lesson from schedule, for notifications
int getSecondsUntilScheduledDate(DateTime lessonDate) {
  return lessonDate.difference(DateTime.now()).inSeconds;
}

/// Returns H:mm formatted time to show in notifications and lessons
String formatScheduleTime(DateTime lessonDate) {
  return DateFormat('H:mm').format(lessonDate);
}

extension DateTransform on DateTime {
  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }
}


