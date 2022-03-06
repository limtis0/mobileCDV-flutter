import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

/*
*
* fields[0] - Columns names
*
*/

List? fields;
int? _localeid;

void initLocalization([String locale = "pl"]) async
{
  final input = File('file.csv').openRead();
  fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
}



String? getTextFromKey([String key = "noKey"])
{
  if(_localeid != null) {
    for (int i = 0; i != fields?.length; i++) {
      if (fields?[i][0] == key) {
        return fields?[i][_localeid];
      }
    }
  }
  return "Translation missing, key: $key";
}