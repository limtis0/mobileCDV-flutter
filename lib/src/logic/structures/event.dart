import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/logic/structures/schedule.dart';

class Event
{
  final String subject;
  final String subjectName;
  final String groupNumber;
  final DateTime startDate;
  final DateTime endDate;
  final String form;
  final String teacher;
  final String room;
  final String meetLink;

  const Event
      (
      this.subject,
      this.subjectName,
      this.groupNumber,
      this.startDate,
      this.endDate,
      this.form,
      this.teacher,
      this.room,
      this.meetLink,
      );

  factory Event.fromScheduleItem(ScheduleTableItem lesson)
  {
    return Event
      (
        lesson.subject,
        lesson.subjectName,
        lesson.groupNumber,
        lesson.startDate,
        lesson.endDate,
        lesson.form,
        lesson.teacher,
        lesson.room,
        lesson.meetLink,
    );
  }

  @override
  String toString() {
    return subjectName;
  }
}