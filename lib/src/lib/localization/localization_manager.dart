import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

List? fields;
int localeId = 2;
String calendarLocalization = "pl_PL";

Future<void> initLocalization(String locale) async
{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('localization', locale);

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
    case "tr":
      calendarLocalization = "tr_TR";
      localeId = 4;
      break;
  }

  String input = await rootBundle.loadString('assets/locale/locale.csv');
  fields = const CsvToListConverter().convert(input);
}

String getTextFromKey([String key = "noKey"])
{
  if (fields?.length == null) { return "Localization file missing"; }

  for (int i = 0; i != fields!.length; i++) {
      if (fields![i][0] == key) {
        if(fields![i][localeId] != "") {
          return fields![i][localeId];
        }
      }
    }
  return "Translation missing for $key";
}