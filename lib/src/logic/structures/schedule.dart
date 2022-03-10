import '../time_operations.dart';

class ScheduleTableItem
{
  final int id;
  final String status;
  final String subject;
  final String subjectName;
  final String groupNumber;
  final DateTime startDate;
  final DateTime endDate;
  final String form;
  final String teacher;
  final String room;
  final String meetLink;
  final String surveyStatus;

  const ScheduleTableItem({
    required this.id,
    required this.status,
    required this.subject,
    required this.subjectName,
    required this.groupNumber,
    required this.startDate,
    required this.endDate,
    required this.form,
    required this.teacher,
    required this.room,
    required this.meetLink,
    required this.surveyStatus,
  });

  factory ScheduleTableItem.fromJson(Map<String, dynamic> json)
  {
    return ScheduleTableItem
      (
      // Skipped profile
      id: json['Id'],
      status: json['Status'],
      subject: json['Subject'],
      subjectName: json['ThemaGroup'],
      groupNumber: json['GroupNr'],
      startDate: getScheduledDate(json['Start']),
      endDate: getScheduledDate(json['End']),
      form: json['Form'],
      teacher: json['Teacher'],
      room: json['Room'],
      meetLink: json['HangoutLink'],
      surveyStatus: json['SurveyStatus'],
    );
  }
}

class Schedule
{
  // Singleton pattern
  static final Schedule _schedule = Schedule._internal();
  factory Schedule()
  {
    return _schedule;
  }
  Schedule._internal();

  // Schedule
  static final List<ScheduleTableItem> _scheduleList = [];

  // Sorts by date on insertion
  void insert(ScheduleTableItem item)
  {
    if (_scheduleList.isEmpty)
    {
      _scheduleList.add(item);
      return;
    }

    for (int i = 0; i < _scheduleList.length; i++)
    {
      if (item.startDate.isBefore(_scheduleList[i].startDate))
      {
        _scheduleList.insert(i, item);
        return;
      }
    }
    _scheduleList.add(item);
  }

  void clear()
  {
    _scheduleList.clear();
  }

  List<ScheduleTableItem> list()
  {
    return _scheduleList;
  }

  @override
  String toString()
  {
    String s = '';
    for (ScheduleTableItem element in _scheduleList)
    {
      s += '${element.subjectName} - ${element.startDate.toString()}:${element.endDate.toString()}\n';
    }
    return s;
  }
}