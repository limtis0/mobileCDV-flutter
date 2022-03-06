import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

List? fields;
int? localeId;

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

void initLocalization([String locale = "pl"]) async
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
  final input = File('$path/assets/locale.csv').openRead();
  fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
}

String? getTextFromKey([String key = "noKey"])
{
  if(localeId != null) {
    for (int i = 0; i != fields?.length; i++) {
      if (fields?[i][0] == key) {
        return fields?[i][localeId];
      }
    }
  }
  return "Translation missing, key: $key";
}