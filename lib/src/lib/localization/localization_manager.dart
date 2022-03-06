import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import '../../widgets/event_calendar.dart';

List? fields;
int? localeId;
String? calendarLocalization;

String? getLocaleType(){
  switch(localeId){
    case 1:
      return "en";
      break;
    case 2:
      return "pl";
      break;
    case 3:
      return "ru";
      break;
  }
  return "pl";
}

Future<void> initLocalization([String locale = "pl"]) async
{
  switch(locale){
    case "en":
      calendarLocalization = "en_US";
      localeId = 1;
      break;
    case "pl":
      calendarLocalization = "pl_PL";
      localeId = 2;
      break;
    case "ru":
      calendarLocalization = "ru_RU";
      localeId = 3;
      break;
  }

  String input = await rootBundle.loadString('assets/locale/locale.csv');
  fields = const CsvToListConverter().convert(input);
}

String getTextFromKey([String key = "noKey"])
{
  if(localeId != null) {
    if(fields?.length != null) {
      for (int i = 0; i != fields?.length; i++) {
        if (fields?[i][0] == key) {
          return fields?[i][localeId];
        }
      }
    }
  }
  return "Translation missing for $key";
}