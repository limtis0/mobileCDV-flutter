import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile_cdv/src/logic/structures/event.dart';
import '../logic/main_activity.dart';
import '../logic/time_operations.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);


  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {

  CalendarFormat _calendarFormat = CalendarFormat.week;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Event>> _selectedEvents;

  LinkedHashMap<DateTime, List<Event>>? kEvents;

  void refreshEvents() {
    kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(setEvents());
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    refreshEvents();
    setState(() {

    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    refreshEvents();
    return kEvents![day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }


  IconData nullIcon = Icons.arrow_drop_down_outlined;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await activitySignIn(prefs.getString('savedEmail')!, prefs.getString('savedPassword')!);
        setState(() {});
      },
      child: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: (day) {
              return _getEventsForDay(day);
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
                formatButtonVisible: false
            ),
          ),
          IconButton(
            icon: Icon(
                nullIcon
            ),
            onPressed: (){
              setState(() {
                switch (_calendarFormat) {
                  case CalendarFormat.week:
                    nullIcon = Icons.arrow_drop_up_outlined;
                    _calendarFormat = CalendarFormat.month;
                    break;
                  case CalendarFormat.month:
                    nullIcon = Icons.arrow_drop_down_outlined;
                    _calendarFormat = CalendarFormat.week;
                    break;
                  default:
                    nullIcon = Icons.arrow_drop_down_outlined;
                    _calendarFormat = CalendarFormat.week;
                    break;
                }
              });
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ValueListenableBuilder <List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: ListTile(
                          onTap: (){

                          },
                          title: Column(
                            children: [
                              Text('${value[index]}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(value[index].room),
                                  Text(value[index].form),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formatScheduleTime(value[index].startDate)),
                                      const Text("-"),
                                      Text(formatScheduleTime(value[index].endDate)),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      )
    );
  }
}