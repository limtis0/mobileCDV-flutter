import 'dart:collection';
import 'package:flutter/material.dart';
import '../logic/time_operations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../logic/storage/globals.dart' as globals;
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile_cdv/src/widgets/utils.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:mobile_cdv/src/logic/theme_manager.dart';
import 'package:mobile_cdv/src/logic/structures/schedule.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  State<EventCalendar> createState() => EventCalendarState();
}

class RoomText extends StatelessWidget {
  final ScheduleTableItem event;
  RoomText({Key? key, required this.event}) : super(key: key);

  late final bool isCancelled = (event.status == globals.lessonCanceledStatus);

  @override
  Widget build(BuildContext context) {
    return Text(
      isCancelled ? getTextFromKey('Event.CANCELLED') : event.room,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: isCancelled ? Colors.red : themeOf(context).eventTextColor!,
      ),
    );
  }
}

class EventCalendarState extends State<EventCalendar> with AutomaticKeepAliveClientMixin {
  // Singleton pattern
  static final EventCalendarState _eventCalendarState = EventCalendarState._internal();
  factory EventCalendarState() {
    return _eventCalendarState;
  }
  EventCalendarState._internal();

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  DateTime _currentPage = DateTime(DateTime.now().year, DateTime.now().month);

  PageController? _pageController;
  AutoScrollController listScrollController = AutoScrollController();

  IconData nullIcon = Icons.arrow_drop_down_outlined;

  int? _lastTime;
  List<DateTime>? _eventDays;
  ScheduleTableItem? _buildEvent;
  LinkedHashMap<DateTime, List<ScheduleTableItem>>? kEvents;

  void _updateEvents() {
    kEvents = LinkedHashMap<DateTime, List<ScheduleTableItem>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(setEvents());
  }

  void _updateDateTimes() {
    _eventDays = [];
    kEvents?.forEach((key, value) {
      if(DateTime(key.year, key.month) == _currentPage){
        _eventDays!.add(key);
      }
    });
  }

  void refreshCalendar() {
    _updateEvents();
    _updateDateTimes();
    setState(() {});
  }

  List<ScheduleTableItem> _getEventsForDay(DateTime day) {
    return kEvents![day] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    refreshCalendar();
  }

  int getIndex(DateTime day) {
    int i = 0;
    for(var item in _eventDays!) {
      if(item.day >= day.day) { return i; }
      i++;
    }
    return 0;
  }

  bool _checkDay(DateTime day) {
    for(var item in _eventDays!) {
      if(item.day >= day.day) {
        return true;
      }
    }
    return false;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      if(_checkDay(selectedDay)) {
        listScrollController.scrollToIndex(getIndex(selectedDay), preferPosition: AutoScrollPosition.begin);
        nullIcon = Icons.arrow_drop_down_outlined;
      }
    });
  }

  void _onPageChanged(focusedDay) {
    _currentPage = DateTime(focusedDay.year, focusedDay.month);
    setState(() {
      _updateEvents();
      _updateDateTimes();
      if(_calendarFormat == CalendarFormat.month || focusedDay.month != DateTime.now().month) {
        if(_lastTime != focusedDay.month) {
          _lastTime = focusedDay.month;
          listScrollController.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
        }
      }
    });
    _focusedDay = focusedDay;
  }

  Color markerColor(Object? obj) {
    obj as ScheduleTableItem;
    return globals.lessonColors[obj.form] ?? Colors.grey;
  }

  // Hence we are initializing calendar with -12 months from now as starting point
  // Current month will be on 12th page
  final int _initialPage = 12;
  void calendarToToday() async {
    int calcPage = _initialPage;
    switch(_calendarFormat) {
      case CalendarFormat.month:
        break;
      case CalendarFormat.twoWeeks:
        calcPage = calcPage * 2 + 2;
        break;
      case CalendarFormat.week:
        calcPage = calcPage * 4 + 4;
        break;
    }
    await _pageController!.animateToPage(calcPage, duration: const Duration(milliseconds: 250), curve: Curves.ease);
    await listScrollController.scrollToIndex(getIndex(DateTime.now()), preferPosition: AutoScrollPosition.begin);
  }

  Future<void> calendarToNextMonth() async {
    final int selMonth = _focusedDay.month;
    int curMonth = selMonth;
    while (curMonth == selMonth) {
      await _pageController!.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.ease);
      curMonth = _focusedDay.month;
    }
    await listScrollController.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
  }

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

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Color _checkButton(ScheduleTableItem _event) {
    if(_event.meetLink != '') {
      return globals.lessonColors[_event.form] ?? Colors.grey;
    }else {
      return Colors.grey;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        TableCalendar(
          onCalendarCreated: (controller) {
            _pageController = controller;
            _updateDateTimes();
            for(int i = 0; i != _eventDays?.length; i++) {
              if(!_checkDay(DateTime.now())) {
                if(getIndex(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + i)) != 0) {
                  listScrollController.scrollToIndex(
                      getIndex(DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day + i)
                      ));
                  break;
                }
              }else {
                listScrollController.scrollToIndex(
                    getIndex(DateTime(
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
          eventLoader: (day){ return _getEventsForDay(day); },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isEmpty) return const SizedBox();
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: markerColor(events[index]),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
                color: themeOf(context).calendarFocusedDayColor,
                shape: BoxShape.circle
            ),
            selectedDecoration: BoxDecoration(
              color: themeOf(context).calendarFocusedDayColor,
              shape: BoxShape.circle,
            ),
          ),
          onDaySelected: _onDaySelected,
          onPageChanged: _onPageChanged,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: themeOf(context).calendarWeekdaysColor),
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
          icon: Icon(nullIcon),
          onPressed: (){
            setState(() {
              switch (_calendarFormat) {
                case CalendarFormat.week:
                  nullIcon = Icons.arrow_drop_down_outlined;
                  _calendarFormat = CalendarFormat.twoWeeks;
                  break;
                case CalendarFormat.twoWeeks:
                  nullIcon = Icons.arrow_drop_up_outlined;
                  _calendarFormat = CalendarFormat.month;
                  break;
                case CalendarFormat.month:
                  nullIcon = Icons.arrow_drop_down_outlined;
                  _calendarFormat = CalendarFormat.week;
                  break;
              }
            });
          },
        ),
        Expanded(
          child: RefreshIndicator(
            color: themeOf(context).functionalObjectsColor,
            backgroundColor: themeOf(context).eventBackgroundColor,
            onRefresh: () async { await calendarToNextMonth(); }, // TODO: Create a dedicated RefreshSchedule() function
            child: ListView.builder(
              controller: listScrollController,
              itemCount: _eventDays!.length,
              itemBuilder: (context, index) {
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: listScrollController,
                  index: index,
                  child:
                  Column(
                    children: [
                      const SizedBox(height: 20), // TODO: Maybe move to the bottom if it breaks anything
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              '${_months[_eventDays![index].month-1]}, ${_eventDays![index].day.toString()}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              _weekdays[_eventDays![index].weekday-1],
                              style: const TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      ),
                      const Divider(thickness: 1.5, indent: 8, endIndent: 8),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _getEventsForDay(_eventDays![index]).length,
                        itemBuilder: (context, evIndex) {
                          _buildEvent = _getEventsForDay(_eventDays![index])[evIndex];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: globals.lessonColors[_buildEvent!.form] ?? Colors.grey,
                                  width: 5,
                                ),
                              ),
                              color: themeOf(context).eventBackgroundColor,
                            ),
                            child: ListTile(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      backgroundColor: themeOf(context).popUpBackgroundColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side: BorderSide(
                                            color: globals.lessonColors[_buildEvent!.form] ?? Colors.grey,
                                            width: 3
                                        )
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _buildEvent!.subjectName,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _buildEvent!.subject,
                                            textAlign: TextAlign.center,
                                          ),
                                          const Divider(thickness: 1.5),
                                          Text(
                                              '${getTextFromKey('Schedule.date')}: ${_months[_eventDays![index].month-1]},'
                                                  ' ${_buildEvent!.startDate.day} '
                                                  '(${formatScheduleTime(_buildEvent!.startDate)}-'
                                                  '${formatScheduleTime(_buildEvent!.endDate)})\n'
                                              '${getTextFromKey('Schedule.room')}: ${_buildEvent!.room}\n'
                                              '${getTextFromKey('Schedule.group')}: ${_buildEvent!.groupNumber}\n'
                                              '${getTextFromKey('Schedule.teacher')}: ${_buildEvent!.teacher}',
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              style: ButtonStyle(backgroundColor:
                                              MaterialStateProperty.all<Color>(_checkButton(_buildEvent!))),
                                              onPressed: (){ _launchURL(_buildEvent!.meetLink); },
                                              child: Text(
                                                getTextFromKey('Schedule.joinMeeting'),
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
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
                                      Text(
                                          '${formatScheduleTime(_buildEvent!.startDate)}'
                                          ' - '
                                          '${formatScheduleTime(_buildEvent!.endDate)}',
                                        style: TextStyle(color: themeOf(context).eventTextColor),
                                      ),
                                      RoomText(event: _buildEvent!),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 110),
                                    child: Text(
                                      _getEventsForDay(_eventDays![index])[evIndex].subjectName,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: themeOf(context).eventTextColor),
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
              },
            ),
          ),
        )
      ],
    );
  }
}