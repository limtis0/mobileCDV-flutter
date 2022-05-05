import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mobile_cdv/src/logic/main_activity.dart';
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
  final AutoScrollController listScrollController = AutoScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  IconData nullIcon = Icons.arrow_drop_down_outlined;

  bool toShow = globals.isLoggedIn;

  int? _curMonth;
  List<DateTime>? _eventDays;
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

  void refreshCalendar([bool error=false]) {
    error ? _refreshController.refreshFailed()
        :_refreshController.refreshCompleted();
    _updateEvents();
    _updateDateTimes();
    rebuild();
  }

  List<ScheduleTableItem> _getEventsForDay(DateTime day) {
    return kEvents![day] ?? [];
  }

  @override
  void initState() {
    super.initState();
    globals.calendarBuilt = true;
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
      // Scrolls to the top if month has changed
      if(_curMonth != focusedDay.month) {
          _curMonth = focusedDay.month;
          listScrollController.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
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

  void _calendarToNextMonth() async {
    final int selMonth = _focusedDay.month;

    int count = 0;
    int curMonth = selMonth;
    while (curMonth == selMonth) {
      await _pageController!.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.ease);
      curMonth = _focusedDay.month;
      count++; // Doesn't lets this stuck in an infinite loop
      if (count > 5) { break; }
    }
    await listScrollController.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
    _refreshController.loadComplete();
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

  void _launchURL(String url) async {
    if (url == '') { return; }
    if (!await launch(url)) throw 'Could not launch $url';
  }

  Color _checkButton(ScheduleTableItem _event) {
    if(_event.meetLink != '') {
      return globals.lessonColors[_event.form] ?? Colors.grey;
    }else {
      return Colors.grey;
    }
  }

  void rebuild(){
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!globals.isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getTextFromKey("noSchedule.page"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 35,
              ),
            )
          ],
        ),
      );
    }
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
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            // TODO Add translations and find theme field for updating wheel
            header: ClassicHeader(
              idleText: 'Pull down to refresh',
              idleIcon: Icon(Icons.arrow_downward, color: themeOf(context).eventTextColor),
              releaseText: 'Release to refresh',
              releaseIcon: Icon(Icons.refresh, color: themeOf(context).eventTextColor),
              refreshingText: 'Refreshing...',
              refreshingIcon:
                SizedBox(
                  width: 25.0,
                  height: 25.0,
                  child: defaultTargetPlatform == TargetPlatform.iOS
                      ? CupertinoActivityIndicator(color: themeOf(context).eventTextColor)
                      : CircularProgressIndicator(strokeWidth: 2.0, color: themeOf(context).eventTextColor)
                ),
              completeText: 'Successfully refreshed',
              completeIcon: Icon(Icons.done, color: themeOf(context).eventTextColor),
              failedText: 'Something went wrong',
              failedIcon: Icon(Icons.error, color: themeOf(context).eventTextColor),
              textStyle: TextStyle(color: themeOf(context).eventTextColor),
            ),
            footer: ClassicFooter(
              idleText: 'Pull up to load the next page',
              idleIcon: Icon(Icons.arrow_upward, color: themeOf(context).eventTextColor),
              canLoadingText: 'Release to load the next page',
              canLoadingIcon: Icon(Icons.autorenew, color: themeOf(context).eventTextColor),
              loadingText: 'Loading...',
              loadingIcon:
                SizedBox(
                  width: 25.0,
                  height: 25.0,
                  child: defaultTargetPlatform == TargetPlatform.iOS
                      ? CupertinoActivityIndicator(color: themeOf(context).eventTextColor)
                      : CircularProgressIndicator(strokeWidth: 2.0, color: themeOf(context).eventTextColor)
                ),
              textStyle: TextStyle(color: themeOf(context).eventTextColor),
            ),
            controller: _refreshController,
            onRefresh: activityLoadSchedule,
            onLoading: _calendarToNextMonth,
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
                      const SizedBox(height: 20),
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
                          ScheduleTableItem _buildEvent = _getEventsForDay(_eventDays![index])[evIndex];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: globals.lessonColors[_buildEvent.form] ?? Colors.grey,
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
                                            color: globals.lessonColors[_buildEvent.form] ?? Colors.grey,
                                            width: 3
                                        )
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _buildEvent.subjectName,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _buildEvent.subject,
                                            textAlign: TextAlign.center,
                                          ),
                                          const Divider(thickness: 1.5),
                                          Text(
                                              '${getTextFromKey('Schedule.date')}: ${_months[_eventDays![index].month-1]},'
                                                  ' ${_buildEvent.startDate.day} '
                                                  '(${formatScheduleTime(_buildEvent.startDate)}-'
                                                  '${formatScheduleTime(_buildEvent.endDate)})\n'
                                              '${getTextFromKey('Schedule.room')}: ${_buildEvent.room}\n'
                                              '${getTextFromKey('Schedule.group')}: ${_buildEvent.groupNumber}\n'
                                              '${getTextFromKey('Schedule.teacher')}: ${_buildEvent.teacher}',
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              style: ButtonStyle(backgroundColor:
                                              MaterialStateProperty.all<Color>(_checkButton(_buildEvent))),
                                              onPressed: (){ _launchURL(_buildEvent.meetLink); },
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
                                          '${formatScheduleTime(_buildEvent.startDate)}'
                                          ' - '
                                          '${formatScheduleTime(_buildEvent.endDate)}',
                                        style: TextStyle(color: themeOf(context).eventTextColor),
                                      ),
                                      Text( // Canceled or room number
                                        _buildEvent.status == globals.lessonCanceledStatus
                                            ? getTextFromKey('Event.CANCELLED')
                                            : _buildEvent.room,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: _buildEvent.status == globals.lessonCanceledStatus
                                              ? Colors.red
                                              : themeOf(context).eventTextColor,
                                        ),
                                      )
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