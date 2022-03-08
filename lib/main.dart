import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/logic/notifications.dart';
import 'package:mobile_cdv/src/logic/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/application.dart';

void main() => startApp();

Future<void> startApp() async
{
  // TODO check this
  WidgetsFlutterBinding.ensureInitialized(); // fix error with async function

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  initPrefs();

  NotificationService().init(); // init notification service

  await initLocalization(prefs.getString('localization').toString()); // init localization
  initializeDateFormatting().then((_) => runApp(const MainApp())); // run app
}