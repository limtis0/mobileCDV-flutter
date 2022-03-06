import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_cdv/src/lib/lozalization/localization_manager.dart';

import 'src/application.dart';

void main() {
  startApp();
}

Future<void> startApp() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalization("en");
  initializeDateFormatting().then((_) => runApp(const MainApp()));
}