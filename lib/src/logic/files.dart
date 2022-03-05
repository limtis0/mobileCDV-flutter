import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async
{
   Directory directory = await getApplicationDocumentsDirectory();
   return directory.path;
}

// void saveImage(String fileName) async
// {
//    String path = await _localPath;
// }

