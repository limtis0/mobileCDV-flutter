import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/widgets/utils.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
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


class LoadingIndicator extends StatelessWidget{
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(getTextFromKey("Profile.Loading")),
        content: const SizedBox(
          width: 50,
          height: 5,
          child: LinearProgressIndicator(
          ),
        )
    );
  }
}

class _EventCalendarState extends State<EventCalendar> {

  DateTime _currentPage = DateTime(DateTime.now().year, DateTime.now().month);
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<DateTime>? _eventDays;
  LinkedHashMap<DateTime, List<Event>>? kEvents;

  void refreshEvents(){
    kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(setEvents());
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _eventDays = _getDateTimes();
    refreshEvents();
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DateTime> _getDateTimes() {
    List<DateTime> list = [];
    kEvents?.forEach((key, value) {
      if(DateTime(key.year, key.month) == _currentPage){
        list.add(key);
      }
    });

    return list;
  }

  List<Event> _getEventsForDay(DateTime day) {
    refreshEvents();
    return kEvents![day] ?? [];
  }

  bool checkDay(DateTime day){
    for(var item in _eventDays!){
      if(item.day == day.day){
        return true;
      }
    }
    return false;
  }
  int getIndex(DateTime day){
    int i = 0;
    for(var item in _eventDays!){
      if(item.day == day.day){
        return i;
      }else{
        i++;
      }
    }
    return 0;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        if(checkDay(selectedDay)){
          listScrollController.scrollToIndex(getIndex(selectedDay), preferPosition: AutoScrollPosition.begin);
          _calendarFormat = CalendarFormat.week;
          nullIcon = Icons.arrow_drop_down_outlined;
        }
      });
    }
  }

  Color markerColor(Object? obj)
  {
    obj as Event;
    return setColor(obj.form)!;
  }

  Color? setColor(String type){
    switch(type){
      case "W":
        return Colors.green;
      case "WR":
        return Colors.blue[200];
      case "L":
        return Colors.blue;
      case "LK":
        return Colors.purpleAccent;
      case "C":
        return Colors.orange;
        //TODO Сделать цвета
      /*case "W":
        return Colors.teal;
      case "W":
        return Colors.teal;
      case "W":
        return Colors.teal;
      case "W":
        return Colors.teal;
      case "W":
        return Colors.teal;*/
        //TODO Сделать цвета
      default:
        return Colors.grey;
    }
  }

  IconData nullIcon = Icons.arrow_drop_down_outlined;

  final List<String> _weekdays = [
    getTextFromKey('Calendar.monday'),
    getTextFromKey('Calendar.tuesday'),
    getTextFromKey('Calendar.wednesday'),
    getTextFromKey('Calendar.thursday'),
    getTextFromKey('Calendar.friday'),
    getTextFromKey('Calendar.saturday'),
    getTextFromKey('Calendar.sunday'),
  ];

  final List<String> _months = [
    getTextFromKey('Calendar.january'),
    getTextFromKey('Calendar.february'),
    getTextFromKey('Calendar.march'),
    getTextFromKey('Calendar.april'),
    getTextFromKey('Calendar.may'),
    getTextFromKey('Calendar.june'),
    getTextFromKey('Calendar.july'),
    getTextFromKey('Calendar.august'),
    getTextFromKey('Calendar.september'),
    getTextFromKey('Calendar.october'),
    getTextFromKey('Calendar.november'),
    getTextFromKey('Calendar.december'),
  ];

  AutoScrollController listScrollController = AutoScrollController();
  PageController controller = PageController();

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
            onCalendarCreated: (controller){
              _eventDays = _getDateTimes();
              //TODO refactor???
              for(int i = 0; i != _eventDays?.length; i++){
                if(!checkDay(DateTime.now())){
                  if(getIndex(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + i)) != 0){
                    listScrollController.scrollToIndex(getIndex(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + i)), preferPosition: AutoScrollPosition.begin);
                    break;
                  }
                }
              }
            },
            locale: calendarLocalization,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: (day) {
              return _getEventsForDay(day);
            },
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, day, event){
                return Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: markerColor(event),//
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
              _currentPage = DateTime(focusedDay.year, focusedDay.month);
              setState(() {
                refreshEvents();
                _eventDays = _getDateTimes();
                if(_calendarFormat == CalendarFormat.month || focusedDay.month != DateTime.now().month) {
                  listScrollController.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
                }
              });
              _focusedDay = focusedDay;
            },
            daysOfWeekStyle: const DaysOfWeekStyle(
              //weekdayStyle: TextStyle(color: Colors.white),
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
          Expanded(
            child: ListView.builder(
              controller: listScrollController,
              itemCount: _getDateTimes().length,
              itemBuilder: (context, index) {
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: listScrollController,
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                "${_months[_eventDays![index].month-1]}, ${_eventDays![index].day.toString()}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text(
                                _weekdays[_eventDays![index].weekday-1],
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          thickness: 1.5,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _getEventsForDay(_eventDays![index]).length,
                          itemBuilder: (context, evIndex) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: setColor(_getEventsForDay(_eventDays![index])[evIndex].form)!,
                                    width: 5,
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              child: ListTile(
                                  onTap: (){

                                  },
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  formatScheduleTime(_getEventsForDay(_eventDays![index])[evIndex].startDate),
                                                  style: TextStyle(
                                                      color: Colors.grey[700]
                                                  ),
                                                ),
                                                Text(
                                                  " - ",
                                                  style: TextStyle(
                                                      color: Colors.grey[700]
                                                  ),
                                                ),
                                                Text(
                                                  formatScheduleTime(_getEventsForDay(_eventDays![index])[evIndex].endDate),
                                                  style: TextStyle(
                                                      color: Colors.grey[700]
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            _getEventsForDay(_eventDays![index])[evIndex].room,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.grey[700]
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 110),
                                        child: Text(
                                          '${_getEventsForDay(_eventDays![index])[evIndex]}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.grey[700]
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          )
        ],
      )
    );
  }
}

/*
Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  "${_months[_eventDays![index].month-1]}, ${_eventDays![index].day.toString()}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    //fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  _weekdays[_eventDays![index].weekday-1],
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      const Divider(
                        thickness: 1.5,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _getEventsForDay(_eventDays![index]).length,
                        itemBuilder: (context, evIndex) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: setColor(_getEventsForDay(_eventDays![index])[evIndex].form)!,
                                  width: 5,
                                ),
                              ),
                              color: Colors.grey[200],
                            ),
                            child: ListTile(
                                onTap: (){

                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                formatScheduleTime(_getEventsForDay(_eventDays![index])[evIndex].startDate),
                                                style: TextStyle(
                                                    color: Colors.grey[700]
                                                ),
                                              ),
                                              Text(
                                                  " - ",
                                                style: TextStyle(
                                                    color: Colors.grey[700]
                                                ),
                                              ),
                                              Text(
                                                formatScheduleTime(_getEventsForDay(_eventDays![index])[evIndex].endDate),
                                                style: TextStyle(
                                                  color: Colors.grey[700]
                                                ),
                                              ),
                                              Text(
                                                _getEventsForDay(_eventDays![index])[evIndex].form,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.grey[700]
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          _getEventsForDay(_eventDays![index])[evIndex].room,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Colors.grey[700]
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 110),
                                      child: Text(
                                        '${_getEventsForDay(_eventDays![index])[evIndex]}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.grey[700]
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
 */