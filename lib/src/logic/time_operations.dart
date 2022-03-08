import 'package:intl/intl.dart';

// Returns current date formatted for API
String getCurrentDate()
{
  final DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

// Returns first day of currentMonth + months
String getDateWithAddedMonths(int months)
{
  final DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + months, 1));
}

// TODO Function to get seconds until the date in format of (2022-04-13T14:15:00+02:00)
