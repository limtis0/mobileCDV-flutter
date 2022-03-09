import 'package:intl/intl.dart';

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

DateTime getScheduledDate(String lessonDate)
{
  DateTime lessonTime = DateTime.parse(lessonDate); // Sets to UTC automatically
  return lessonTime;
}

// Returns seconds left until a lesson from schedule (For notifications)
int getSecondsUntilScheduledDate(String lessonDate)
{
  DateTime lessonTime = getScheduledDate(lessonDate);
<<<<<<< HEAD
  // TODO Check if toUtc in needed. Maybe it is done automatically
=======
  // TODO Test whether toUtc() is needed, maybe it sets automatically?
>>>>>>> origin/f
  int difference = lessonTime.difference(DateTime.now().toUtc()).inSeconds;
  return difference;
}
