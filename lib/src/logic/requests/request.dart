import 'dart:convert';
import '../storage/globals.dart' as globals;
import '../structures/schedule.dart';
import '../structures/exceptions.dart';
import '../structures/login_response.dart';
import 'package:http/http.dart' as http;
import '../notifications.dart';

// LOGIN
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
    throw RequestErrorException('Failed to log in');
  }
}

// SCHEDULE
Future<void> fetchSchedule(String userType, String userId, String dateFrom, String dateTo, String token) async
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
    if (globals.notificationsToggle)
    {
      NotificationService().setNotificationQueue(globals.notificationsTime, 32);
    }
  }
  else
  {
    throw RequestErrorException('Failed to get schedule');
  }
}
