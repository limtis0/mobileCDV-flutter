library mobile_cdv.globals;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';

// Constants
const int calendarPastMonths = 2; // How many months in past to request from server
const int calendarFutureMonths = 6; // Same, but for future

const int notificationQueueSize = 32;

const String lessonCanceledStatus = 'ODWOLANE';

// TODO Fill keys for all lessonTypes and all lessonNames. We can't get them :(
final Map<String, Color> lessonColors = {
  'W':Colors.green,
  'WR':Colors.teal[300]!,
  'L':Colors.blue,
  'TODO_E_LEARNING':Colors.grey[400]!,
  'C':Colors.orange,
  'LK':Colors.purpleAccent,
  'TODO_PROJEKT':Colors.pink,
  'TODO_PRAKTYKI':Colors.indigo[900]!,
  'TODO_SEMINARIUM':Colors.indigo,
  'TODO_KONWERSATORIUM':Colors.deepOrange,
  'TODO_SPOTKANIE':Colors.purple,
  'EGSAM':Colors.purple[600]!,
  'TODO_REZERWACJA':Colors.purple[700]!,
  'TODO_DYZUR':Colors.purple[800]!,
};

final Map<String, String> lessonNames = {
  'W':getTextFromKey('Static.Wyklad'),
  'WR':getTextFromKey('Static.Warsztaty'),
  'L':getTextFromKey('Static.Labaratoria'),
  'TODO_E_LEARNING':getTextFromKey('Static.Elearning'),
  'C':getTextFromKey('Static.Cwiczenia'),
  'LK':getTextFromKey('Static.Lektorat'),
  'TODO_PROJEKT':getTextFromKey('Static.Projekt'),
  'TODO_PRAKTYKI':getTextFromKey('Static.Praktyki'),
  'TODO_SEMINARIUM':getTextFromKey('Static.Seminarium'),
  'TODO_KONWERSATORIUM':getTextFromKey('Static.Konwersatorium'),
  'TODO_SPOTKANIE':getTextFromKey('Static.Spotkanie'),
  'EGSAM':getTextFromKey('Static.Zaliczenie'),
  'TODO_REZERWACJA':getTextFromKey('Static.Rezerwacja'),
  'TODO_DYZUR':getTextFromKey('Static.Dyzur'),
};

String locale = 'pl';
const Map<String, String> locales = {
  'English': 'en',
  'Polski': 'pl',
  'Русский': 'ru',
  'Türkçe': 'tr',
};

int theme = 0;
const Map<String, int> themes = {
  'Light': 0,
  'Dark': 1,
  'Amoled': 2,
  'Pink': 3,
};

bool notificationsToggle = true;
int notificationsTime = 3600;
final Map<String, int> timesTillNotification = {
  getTextFromKey('Settings.time.15mins'): 900,
  getTextFromKey('Settings.time.30mins'): 1800,
  getTextFromKey('Settings.time.1hour'): 3600,
  getTextFromKey('Settings.time.2hours'): 7200,
};

// Prefs
bool isLoggedIn = false;

String email = '';
String pass = '';
String tokenEncoded = '';

String name = '';
String type = '';
String album = '';

ImageProvider? avatar;

Future<void> loadFromPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  isLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
  
  email = prefs.getString('savedEmail') ?? '';
  pass = prefs.getString('savedPassword') ?? '';
  tokenEncoded = prefs.getString('savedTokenEncoded') ?? '';
  
  name = prefs.getString('savedUserName') ?? '';
  type = prefs.getString('savedUserType') ?? '';
  album = prefs.getString('savedUserAlbumNumber') ?? '';

  locale = prefs.getString('localization') ?? 'pl';
  theme = prefs.getInt('themeId') ?? 0;
  notificationsToggle = prefs.getBool('notificationsToggle') ?? true;
  notificationsTime = prefs.getInt('notificationsTime') ?? 3600;
}

void clear() {
  isLoggedIn = false;
  email = '';
  pass = '';
  name = '';
  type = '';
  album = '';
}