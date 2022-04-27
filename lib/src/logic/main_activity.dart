import 'structures/usertoken.dart';
import 'package:flutter/material.dart';
import 'structures/login_response.dart';
import 'package:mobile_cdv/src/logic/requests/decoder.dart';
import 'package:mobile_cdv/src/logic/requests/request.dart';
import 'package:mobile_cdv/src/logic/storage/files.dart';
import 'package:mobile_cdv/src/logic/time_operations.dart';
import 'package:mobile_cdv/src/logic/storage/globals.dart' as globals;
import 'package:mobile_cdv/src/logic/storage/shared_prefs.dart';
import 'package:mobile_cdv/src/logic/structures/exceptions.dart';

Future<void> activitySignIn(String email, String password, bool imageDecode) async {
  final LoginResponse loginResponse = await fetchLogin(email.trim(), password);

  UserToken token = decodeToken(loginResponse.token);

  if (imageDecode) {
    await saveImage(decodeImage(loginResponse.photo), 'avatar.png');
    imageCache?.clear();
  }
  globals.avatar = await imageToWidget('avatar.png');

  await setPrefsOnSignIn(email.trim(), password, loginResponse.token, token);
  await globals.loadFromPrefs();

  try {
    await fetchSchedule(
        token.userType, token.userId.toString(),
        getMonthsFromNowFirstDayAPI(-globals.calendarPastMonths),
        getMonthsFromNowLastDayAPI(globals.calendarFutureMonths),
        loginResponse.token
    );
  }
  on RequestErrorException { rethrow; }
}

Future<void> activitySignOut() async {
  await clearPrefs();
  globals.clear();

  await removeFile('avatar.png');
}
