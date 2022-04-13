library mobile_cdv.globals;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_cdv/src/logic/structures/schedule.dart';

// Constants
const int calendarPastMonths = 2; // How many months in past to request from server
const int calendarFutureMonths = 6; // Same, but for future

const String lessonCanceledIndicator = 'ODWOLANE';

// TODO Fill colors for all lessonTypes. We can't get them :(
final Map<String, Color> lessonColors = {
  'W':Colors.green,
  'WR':Colors.blue[200]!,
  'L':Colors.blue,
  'LK':Colors.purpleAccent,
  'C':Colors.orange,
  'EGSAM':Colors.purple,
};

Schedule schedule = Schedule();

// Prefs
bool isLoggedIn = false;

String name = '';
String type = '';
String album = '';

String email = '';
String pass = '';

bool notificationsToggle = true;
int notificationsTime = 3600;

ImageProvider? avatar;

int theme = 0;

Future<void> loadFromPrefs() async
{
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  isLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;

  theme = prefs.getInt('themeId') ?? 0;
  
  email = prefs.getString('savedEmail') ?? '';
  pass = prefs.getString('savedPassword') ?? '';
  
  name = prefs.getString('savedUserName') ?? '';
  type = prefs.getString('savedUserType') ?? '';
  album = prefs.getString('savedUserAlbumNumber') ?? '';
  
  notificationsToggle = prefs.getBool('notificationsToggle') ?? true;
  notificationsTime = prefs.getInt('notificationsTime') ?? 3600;
}

void clear()
{
  isLoggedIn = false;
  email = '';
  pass = '';
  name = '';
  type = '';
  album = '';
}