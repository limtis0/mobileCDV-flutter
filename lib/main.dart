import 'package:flutter/material.dart';
import 'src/application.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'src/lib/lozalization/localization_manager.dart';

void main() {
  initLocalization("en");
  initializeDateFormatting().then((_) => runApp(const MainApp()));
}

