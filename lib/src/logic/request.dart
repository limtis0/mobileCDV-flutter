import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

// LOGIN
class LoginResponse
{
  final bool result;
  final String token;
  final String? message;
  final String photo;

  const LoginResponse({
    required this.result,
    required this.token,
    required this.message,
    required this.photo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json)
  {
    return LoginResponse
    (
      result: json['result'],
      token: json['token'],
      message: json['message'],
      photo: json['photo'],
    );
  }
}

Future<LoginResponse> fetchLogin(String login, String password) async
{
  final response = await http.post(
    Uri.parse('https://api.cdv.pl/mobilnecdv-api/login'),
    body: jsonEncode(<String, String>
    {
      'login': login,
      'password': password,
    })
  );

  if (response.statusCode == 200)
  {
    return LoginResponse.fromJson(jsonDecode(response.body));
  }
  else
  {
    throw Exception('Failed to login.');
  }
}

// SCHEDULE
class ScheduleTableItem
{
  final int id;
  final String status;
  final String subject;
  final String subjectName;
  final String groupNumber;
  final String startDate;
  final String endDate;
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
      startDate: json['Start'],
      endDate: json['End'],
      form: json['Form'],
      teacher: json['Teacher'],
      room: json['Room'],
      meetLink: json['HangoutLink'],
      surveyStatus: json['SurveyStatus'],
    );
  }
}

Future<List> fetchSchedule(String studentId, String dateFrom, String dateTo, String token) async
{
  String url = 'https://api.cdv.pl/mobilnecdv-api/schedule/student/$studentId/1/$dateFrom/$dateTo';
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>
    {
      'Authorization': 'Bearer $token',
    }
  );

  if (response.statusCode == 200)
  {
    globals.schedule.clear();
    for (Map<String, dynamic> lesson in jsonDecode(response.body))
    {
      globals.schedule.add(ScheduleTableItem.fromJson(lesson));
    }
    return globals.schedule;
  }
  else
  {
    throw Exception('Failed to get schedule.');
  }
}
