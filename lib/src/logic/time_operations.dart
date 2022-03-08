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

// Returns seconds left until a lesson from schedule ()
int getSecondsUntilScheduleDate(String lessonDate)
{
  DateFormat f = DateFormat('yyyy-MM-ddTHH:mm:ss');
  DateTime lessonTime = f.parse(lessonDate).toUtc();
  print(lessonTime.toUtc());
  print(DateTime.now().toUtc());
  return lessonTime.difference(DateTime.now().toUtc()).inSeconds;
}
