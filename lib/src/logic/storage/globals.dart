library mobile_cdv.globals;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'structures/schedule.dart';

// GLOBALS
Schedule schedule = Schedule();

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