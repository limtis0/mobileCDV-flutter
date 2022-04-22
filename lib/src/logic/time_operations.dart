import 'package:intl/intl.dart';

// API
// Returns current date formatted for API
String getCurrentDateAPI() {
  final DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

// Returns first day of currentMonth + months
String getMonthsFromNowFirstDayAPI(int months) {
  final DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + months, 1));
}

// Returns last day of currentMonth + months
String getMonthsFromNowLastDayAPI(int months) {
  final DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + months + 1, -1));
}

// NOTIFICATIONS AND LOGIC
DateTime getScheduledDate(String lessonDate) {
  return DateTime.parse(lessonDate).toLocal();
}

// Returns seconds left until a lesson from schedule (For notifications)
int getSecondsUntilScheduledDate(DateTime lessonDate) {
  return lessonDate.difference(DateTime.now()).inSeconds;
}

// EVENTS
String formatScheduleTime(DateTime lessonDate) {
  return DateFormat('H:mm').format(lessonDate);
}

extension DateTransform on DateTime {
  DateTime toDateOnly()
  {
    return DateTime(year, month, day);
  }
}


