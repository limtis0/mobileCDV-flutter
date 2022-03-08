import 'dart:convert';
import 'globals.dart' as globals;
import 'structures/schedule.dart';
import 'package:http/http.dart' as http;

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
Future<List> fetchSchedule(String userType, String userId, String dateFrom, String dateTo, String token) async
{
  String url = 'https://api.cdv.pl/mobilnecdv-api/schedule/$userType/$userId/1/$dateFrom/$dateTo';
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
      globals.schedule.insert(ScheduleTableItem.fromJson(lesson));
    }
    return globals.schedule.list();
  }
  else
  {
    throw Exception('Failed to get schedule.');
  }
}
