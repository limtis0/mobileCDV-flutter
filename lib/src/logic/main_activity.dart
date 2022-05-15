import 'structures/usertoken.dart';
import 'package:flutter/material.dart';
import 'structures/login_response.dart';
import 'package:mobile_cdv/src/logic/storage/files.dart';
import 'package:mobile_cdv/src/logic/requests/decoder.dart';
import 'package:mobile_cdv/src/logic/requests/request.dart';
import 'package:mobile_cdv/src/widgets/event_calendar.dart';
import 'package:mobile_cdv/src/logic/storage/shared_prefs.dart';
import 'package:mobile_cdv/src/logic/storage/globals.dart' as globals;

/// Logs in, using given email and password
/// Stores response into sharedPrefs and globals, also saves profile image
Future<void> activitySignIn(String email, String password, [bool imageDecode = true]) async {
  email = email.trim(); // Removes spaces after email

  final LoginResponse loginResponse = await fetchLogin(email, password);
  final UserToken token = decodeToken(loginResponse.token);

  if (imageDecode) {
    await saveImage(decodeImage(loginResponse.photo), 'avatar.png');
    imageCache?.clear();
  }
  globals.avatar = await imageToWidget('avatar.png');

  await setPrefsOnSignIn(email, password, loginResponse.token, token);
  await globals.loadFromPrefs();

  await activityLoadSchedule();
}

/// Is used to refresh schedule and pass it into EventCalendar widget
Future<void> activityLoadSchedule() async {
  bool error = false;
  if (!globals.isLoggedIn) { return; }

  try{
    await fetchSchedule();
  }
  catch(e){
    error = true;
  }

  if (globals.calendarBuilt) { EventCalendarState().refreshCalendar(error); }
}

/// Called after logging out
/// Removes profile saved data
/// Refreshes EventCalendar widget
Future<void> activitySignOut() async {
  await clearPrefs();
  globals.clear();

  await removeFile('avatar.png');

  if (globals.calendarBuilt) { EventCalendarState().rebuild(); }
}
