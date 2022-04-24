import '../logic/time_operations.dart';
import 'package:mobile_cdv/src/logic/structures/schedule.dart';

final eventsList = setEvents();

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

Map<DateTime, List<ScheduleTableItem>> setEvents() {
  Map<DateTime, List<ScheduleTableItem>> mapEvents = {};
  List<ScheduleTableItem> schedule = Schedule().list();

  for (int i = 0; i < schedule.length; i++) {
    // Calendar events are stored by days, so this is the only reliable option
    DateTime scheduledDate = schedule[i].startDate.toDateOnly();

    // Null safety
    if (mapEvents[scheduledDate] == null) {
      mapEvents[scheduledDate] = [];
    }

    mapEvents[scheduledDate]!.add(schedule[i]);
  }
  return mapEvents;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate
  (
    dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 12, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 12, kToday.day);