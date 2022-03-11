import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
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

  Color setColor(String type){
    switch(type){
      case "W":
        return Colors.teal;
      default:
        return Colors.blue;
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
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, day, _){
                return Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                  ), //Change color
                  width: 5.0,
                  height: 5.0,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                );
              },
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
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
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.red),
            ),
            headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
                formatButtonVisible: false,
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
                        border: Border(
                          left: BorderSide(
                            color: setColor(value[index].form),
                            width: 5,
                          ),
                        ),
                        color: Colors.grey[200],
                      ),
                      child: ListTile(
                          onTap: (){

                          },
                          title: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formatScheduleTime(value[index].startDate)),
                                      const Text("-"),
                                      Text(formatScheduleTime(value[index].endDate)),
                                    ],
                                  ),
                                  Text(
                                    value[index].room,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 110),
                                child: Text(
                                  '${value[index]}',
                                  textAlign: TextAlign.left,
                                ),
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