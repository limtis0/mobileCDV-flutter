import '../logic/time_operations.dart';
import 'package:mobile_cdv/src/logic/structures/event.dart';
import 'package:mobile_cdv/src/logic/globals.dart' as globals;
import 'package:mobile_cdv/src/logic/structures/schedule.dart';

final eventsList = setEvents();

Map<DateTime, List<Event>> setEvents()
{
  Map<DateTime, List<Event>> mapEvents = {};
  List<ScheduleTableItem> schedule = globals.schedule.list();

  for (int i = 0; i < schedule.length; i++)
  {
    // Calendar events are stored by days, so this is the only reliable option
    DateTime scheduledDate = schedule[i].startDate.toDateOnly();

    // Null safety
    if (mapEvents[scheduledDate] == null)
    {
      mapEvents[scheduledDate] = [];
    }

    mapEvents[scheduledDate]!.add(Event.fromScheduleItem(schedule[i]));
  }
  if(globals.isLoggined) {
    return mapEvents;
  } else {
    return {};
  }
}

int getHashCode(DateTime key)
{
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last)
{
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