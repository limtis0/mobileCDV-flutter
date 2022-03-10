import 'package:intl/intl.dart';

// API
// Returns current date formatted for API
String getCurrentDateAPI()
{
  final DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

// Returns first day of currentMonth + months
String getMonthsFromNowFirstDayAPI(int months)
{
  final DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + months, 1));
}

// NOTIFICATIONS AND LOGIC
DateTime getScheduledDate(String lessonDate)
{
  return DateTime.parse(lessonDate); // Sets to UTC automatically
}

// Returns seconds left until a lesson from schedule (For notifications)
int getSecondsUntilScheduledDate(String lessonDate)
{
  DateTime lessonTime = getScheduledDate(lessonDate);
  return lessonTime.difference(DateTime.now().toUtc()).inSeconds;
}

// EVENTS
String formatScheduleTime(DateTime lessonDate)
{
  return DateFormat('H:mm').format(lessonDate);
}

