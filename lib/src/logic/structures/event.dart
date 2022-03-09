class Event {
  final String subject;
  final String subjectName;
  final String groupNumber;
  final DateTime startDate;
  final DateTime endDate;
  final String form;
  final String teacher;
  final String room;
  final String meetLink;

  const Event(
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

  @override
  String toString() => subjectName;
}