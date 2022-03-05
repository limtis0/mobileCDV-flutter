import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class EventCalendar extends StatelessWidget {
  const EventCalendar({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Calendar(
        //eventsList: _eventList,
        startOnMonday: true,
        weekDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fr', 'Sat', 'Sun'],
        isExpandable: true,
        eventDoneColor: Colors.green,
        selectedColor: Colors.blue,
        todayColor: Colors.blue,
        eventColor: null,
        locale: 'en_US',
        isExpanded: false,
        expandableDateFormat: 'EEEE, dd. MMMM yyyy',
        datePickerType: DatePickerType.date,
        dayOfWeekStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 11
      )
    );
  }
}

class Timetable extends StatefulWidget {

  Timetable({Key? key}) : super(key: key);

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          "Hi"
        )
      ],
    );
  }
}
