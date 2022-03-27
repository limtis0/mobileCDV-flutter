/*
  TODO В помойку
 */
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/logic/structures/schedule.dart';
import 'package:mobile_cdv/src/widgets/utils.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../logic/main_activity.dart';
import '../logic/time_operations.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);


  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class RoomText extends StatelessWidget {
  ScheduleTableItem event;
  RoomText({Key? key, required this.event}) : super(key: key);

  bool isCancelled = false;

  String getCanceledText(ScheduleTableItem _event) {
    if(_event.status == "CANCELLED"){
      isCancelled = true;
      return getTextFromKey("Event.CANCELLED");
    }
    isCancelled = false;
    return _event.room;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getCanceledText(event),
      textAlign: TextAlign.right,
      style: TextStyle(
        color: isCancelled ? Colors.red : Theme.of(context).primaryColor,
      ),
    );
  }
}

class _EventCalendarState extends State<EventCalendar> {

  DateTime _currentPage = DateTime(DateTime.now().year, DateTime.now().month);
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _lastTime;
  List<DateTime>? _eventDays;
  LinkedHashMap<DateTime, List<ScheduleTableItem>>? kEvents;

  void refreshEvents(){
    kEvents = LinkedHashMap<DateTime, List<ScheduleTableItem>>(
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

  List<ScheduleTableItem> _getEventsForDay(DateTime day) {
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
    setState(() {
      _focusedDay = focusedDay;
      if(checkDay(selectedDay)){
        listScrollController.scrollToIndex(getIndex(selectedDay), preferPosition: AutoScrollPosition.begin);
        _calendarFormat = CalendarFormat.week;
        nullIcon = Icons.arrow_drop_down_outlined;
      }
    });
  }

  Color markerColor(Object? obj)
  {
    obj as ScheduleTableItem;
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
      case "EGSAM":
        return Colors.purple;
        //TODO Сделать цвета
      /*case "W":
        return Colors.teal;
      case "W":
        return Colors.teal;
      case "W":
        return Colors.teal;
      case "W":
        return Colors.teal;*/
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

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Color _checkButton(ScheduleTableItem _event){
    if(_event.meetLink != ""){
      return setColor(_event.form)!;
    }else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await activitySignIn(prefs.getString('savedEmail')!, prefs.getString('savedPassword')!, false);
      },
      child: Column(
        children: [
          TableCalendar(
            onCalendarCreated: (controller){
              _eventDays = _getDateTimes();
              for(int i = 0; i != _eventDays?.length; i++){
                if(!checkDay(DateTime.now())){
                  if(getIndex(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + i)) != 0){
                    listScrollController.scrollToIndex(
                        getIndex(
                            DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day + i)
                        ), preferPosition: AutoScrollPosition.begin);
                    break;
                  }
                }else {
                  listScrollController.scrollToIndex(
                      getIndex(
                          DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day)
                      ), preferPosition: AutoScrollPosition.begin);
                  break;
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
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: Theme.of(context).focusColor,
                shape: BoxShape.circle
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).focusColor,
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
                  if(_lastTime != focusedDay.month) {
                    _lastTime = focusedDay.month;
                    listScrollController.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
                  }
                }
              });
              _focusedDay = focusedDay;
            },
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Theme.of(context).primaryColorLight),
              weekendStyle: const TextStyle(color: Colors.red),
            ),
            headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(
                  //color: Theme.of(context).colorScheme.primary,
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
                                color: Theme.of(context).backgroundColor,
                              ),
                              child: ListTile(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context).cardColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              side: BorderSide(
                                                color: setColor(_getEventsForDay(_eventDays![index])[evIndex].form)!,
                                                width: 3
                                              )
                                            ),
                                            content: Container(
                                              color: Theme.of(context).cardColor,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    _getEventsForDay(_eventDays![index])[evIndex].subjectName,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  Text(
                                                    _getEventsForDay(_eventDays![index])[evIndex].subject,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const Divider(
                                                    thickness: 1.5,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 16),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          '${getTextFromKey("Schedule.date")}: ${_months[_eventDays![index].month-1]}, ${_getEventsForDay(_eventDays![index])[evIndex].startDate.day} (${formatScheduleTime(_getEventsForDay(_eventDays![index])[evIndex].startDate)}-${formatScheduleTime(_getEventsForDay(_eventDays![index])[evIndex].endDate)})',
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        Text(
                                                          '${getTextFromKey("Schedule.room")}: ${_getEventsForDay(_eventDays![index])[evIndex].room}',
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        Text(
                                                          '${getTextFromKey("Schedule.group")}: ${_getEventsForDay(_eventDays![index])[evIndex].groupNumber}',
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        Text(
                                                          '${getTextFromKey("Schedule.teacher")}: ${_getEventsForDay(_eventDays![index])[evIndex].teacher}',
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 10),
                                                          child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all<Color>(
                                                                    _checkButton(_getEventsForDay(_eventDays![index])[evIndex])
                                                                )
                                                            ),
                                                            onPressed: (){
                                                              _launchURL(_getEventsForDay(_eventDays![index])[evIndex].meetLink);
                                                            },
                                                            child: Text(
                                                                getTextFromKey("Schedule.joinMeeting")
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    );
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
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                                Text(
                                                  " - ",
                                                  style: TextStyle(
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                                Text(
                                                  formatScheduleTime(_getEventsForDay(_eventDays![index])[evIndex].endDate),
                                                  style: TextStyle(
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RoomText(
                                            event: _getEventsForDay(_eventDays![index])[evIndex],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 110),
                                        child: Text(
                                          _getEventsForDay(_eventDays![index])[evIndex].subjectName,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
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