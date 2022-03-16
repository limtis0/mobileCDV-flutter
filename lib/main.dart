import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_cdv/src/logic/main_activity.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/logic/notifications.dart';
import 'package:mobile_cdv/src/logic/storage.dart';
import 'package:mobile_cdv/src/logic/theme_manager.dart';
import 'package:mobile_cdv/src/logic/globals.dart' as globals;

import 'src/application.dart';

void main() => startApp();

Future<void> startApp() async
{
  WidgetsFlutterBinding.ensureInitialized(); // fix error with async function

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await initPrefs();

  NotificationService().init(); // init notification service

  await initLocalization(prefs.getString('localization') ?? 'en'); // init localization

  if (prefs.getInt('themeId') == null) {
    await prefs.setInt('themeId', 0);
  }

  if(prefs.getBool('isUserLoggedIn') == null){
    await prefs.setBool('isUserLoggedIn', false);
  }
  if(prefs.getBool('isUserLoggedIn')!){
    globals.isLoggedIn = true;
  }else {
    globals.isLoggedIn = false;
  }

  globals.theme = prefs.getInt('themeId')!;

  showTimetable();
}


Future<void> showTimetable() async
{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try{
    await activitySignIn(prefs.getString('savedEmail')!, prefs.getString('savedPassword')!);
  }catch(e){
    globals.isLoggedIn == false;
  }


  initializeDateFormatting().then((_) async => runApp(
      ChangeNotifierProvider<ThemeModel>(
        create: (BuildContext context) => ThemeModel(),
        child: MainApp(),
      )
  )); // run app
}
