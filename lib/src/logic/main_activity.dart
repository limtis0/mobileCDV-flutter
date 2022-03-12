import 'dart:io';

import 'package:flutter/material.dart';

import 'structures/usertoken.dart';
import 'structures/login_response.dart';
import 'package:mobile_cdv/src/logic/decoder.dart';
import 'package:mobile_cdv/src/logic/request.dart';
import 'package:mobile_cdv/src/logic/storage.dart';
import 'package:mobile_cdv/src/logic/time_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_cdv/src/logic/structures/exceptions.dart';
import 'package:mobile_cdv/src/logic/globals.dart' as globals;

Future<void> activitySignIn(String email, String password) async
{
  final LoginResponse loginResponse = await fetchLogin(email, password);

  UserToken token = decodeToken(loginResponse.token);

  await saveImage(decodeImage(loginResponse.photo), 'avatar.png');
  globals.avatar = Image(image: Image.file(File('${globals.path}/avatar.png')).image).image;

  await setPrefsOnSignIn(email, password, loginResponse.token, token);

  globals.name = token.userName;
  globals.type = token.userType;
  globals.album = token.userAlbumNumer;

  try
  {
    await fetchSchedule(token.userType, token.userId.toString(),
        getMonthsFromNowFirstDayAPI(-2), getMonthsFromNowLastDayAPI(6), loginResponse.token);
  }
  on RequestErrorException
  {
    rethrow;
  }
}

void removeGlobals(){
  globals.name = '';
  globals.pass = '';
  globals.album = '';
  globals.type = '';
  globals.isLoggined = false;
  globals.path = '';
}
Future<void> activitySignOut() async
{
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  removeGlobals();

  await prefs.setBool('isUserLoggedIn', false);

  await prefs.remove('savedEmail');
  await prefs.remove('savedPassword');
  await prefs.remove('savedTokenEncoded');
  await prefs.remove('savedUserName');
  await prefs.remove('savedUserType');
  await prefs.remove('savedUserAlbumNumber');

  await removeFile('avatar.png');
}
