import 'dart:convert';
import '../storage/globals.dart' as globals;
import '../structures/schedule.dart';
import '../structures/exceptions.dart';
import '../structures/login_response.dart';
import 'package:http/http.dart' as http;
import '../notifications.dart';
import '../time_operations.dart';

// LOGIN
Future<LoginResponse> fetchLogin(String login, String password) async {
  final response = await http.post(
    Uri.parse('https://api.cdv.pl/mobilnecdv-api/login'),
    body: jsonEncode(<String, String>
    {
      'login': login,
      'password': password,
    })
  );

  if (response.statusCode == 200) {
    return LoginResponse.fromJson(jsonDecode(response.body));
  }
  else {
    throw RequestErrorException('Failed to log in');
  }
}

// SCHEDULE
Future<void> fetchSchedule() async {
  String dateFrom = getMonthsFromNowFirstDayAPI(-globals.calendarPastMonths);
  String dateTo = getMonthsFromNowLastDayAPI(globals.calendarFutureMonths);
  String url = 'https://api.cdv.pl/mobilnecdv-api/schedule/${globals.type}/${globals.id}/1/$dateFrom/$dateTo';

  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>
    {
      'Authorization': 'Bearer ${globals.tokenEncoded}',
    }
  );

  if (response.statusCode == 200) {
    Schedule().clear();
    for (Map<String, dynamic> lesson in jsonDecode(response.body)) {
      Schedule().insert(ScheduleTableItem.fromJson(lesson));
    }
    if (globals.notificationsToggle) {
      NotificationService().setNotificationQueue();
    }
  }
  else {
    throw RequestErrorException('Failed to get schedule');
  }
}
