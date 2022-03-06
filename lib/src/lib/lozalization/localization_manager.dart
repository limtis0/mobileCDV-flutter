import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

List? fields;
int? localeId;

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<void> initLocalization([String locale = "pl"]) async
{
  final path = await _localPath;

  switch(locale){
    case "en":
      localeId = 1;
      break;
    case "pl":
      localeId = 2;
      break;
    default:
      localeId = 2;
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
    }else{
      print("length = null");
    }
  }
  return "Translation missing for $key";
}