import 'dart:collection';

import 'package:mobile_cdv/src/logic/structures/event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile_cdv/src/logic/globals.dart' as globals;

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(eventsList);

final eventsList = setEvents();

Map<DateTime, List<Event>> setEvents(){
  Map<DateTime, List<Event>> mapEvents = {};

  for (int i = 0; i != globals.schedule.list().length; i++) {
    mapEvents.addAll({DateTime(globals.schedule.list()[i].startDate.year, globals.schedule.list()[i].startDate.month, globals.schedule.list()[i].startDate.day) : getEvents(globals.schedule.list()[i].startDate)});
  }
  
  return mapEvents;
}

List<Event> getEvents(DateTime time){
  List<Event> events = [];

  for (int i = 0; i != globals.schedule.list().length; i++) {
    if (DateTime(
        globals.schedule.list()[i].startDate.year,
        globals.schedule.list()[i].startDate.month,
        globals.schedule.list()[i].startDate.day) == DateTime(time.year, time.month, time.day)) {

      events.add(Event.fromScheduleItem(globals.schedule.list()[i]));
    }
  }
  return events;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);