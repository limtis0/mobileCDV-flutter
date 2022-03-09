import 'dart:collection';

import 'package:mobile_cdv/src/logic/structures/event.dart';
import 'package:mobile_cdv/src/logic/structures/schedule.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:mobile_cdv/src/logic/globals.dart' as globals;



final kEvents = <DateTime, List<Event>>{}..addAll(setEvents());


Map<DateTime, List<Event>> setEvents(){
  Map<DateTime, List<Event>> _eventData = {DateTime.now() : [Event.fromScheduleItem(globals.schedule.list()[1])]};

  //_eventData?.addAll({DateTime.now() : [Event.fromScheduleItem(globals.schedule.list()[0])]});
  
  for(ScheduleTableItem item in globals.schedule.list()){
    _eventData[item.startDate] = [Event.fromScheduleItem(item)];
  }
  return _eventData;
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