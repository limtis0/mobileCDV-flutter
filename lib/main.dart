import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_cdv/src/logic/main_activity.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/logic/notifications.dart';
import 'package:mobile_cdv/src/logic/storage/shared_prefs.dart';
import 'package:mobile_cdv/src/logic/theme_manager.dart';
import 'package:mobile_cdv/src/logic/storage/globals.dart' as globals;

import 'src/application.dart';

void main() => startApp();

Future<void> startApp() async
{
  WidgetsFlutterBinding.ensureInitialized(); // fix error with async function

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await initPrefs();
  await globals.loadFromPrefs();

  NotificationService().init(); // init notification service

  await initLocalization(prefs.getString('localization') ?? 'en'); // init localization

  showTimetable();
}


Future<void> showTimetable() async
{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try
  {
    await activitySignIn(prefs.getString('savedEmail')!, prefs.getString('savedPassword')!, false);
  }
  catch(e){
    globals.isLoggedIn == false;
  }

  initializeDateFormatting().then((_) async => runApp(
      ChangeNotifierProvider<ThemeModel>(
        create: (BuildContext context) => ThemeModel(),
        child: const MainApp(),
      )
  )); // run app
}
