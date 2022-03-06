import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> get _localPath async
{
   Directory directory = await getApplicationDocumentsDirectory();
   return directory.path;
}

// Gets Uint8List on input and saves it as an image (i.e. test.png)
void saveImage(Uint8List imageBytes, String fileName) async
{
   final String filePath = await _localPath;
   final file = File('$filePath/$fileName');
   file.writeAsBytes(imageBytes);
}

/* TODO Choose the library with Image data type that suits front-end
   and make getImageFromFile() function;
 */

void setPrefsOnOpening() async
{
   final SharedPreferences prefs = await SharedPreferences.getInstance();

   bool? wasOpenedBefore = prefs.getBool('wasOpenedBefore');
   if (wasOpenedBefore == true)
   {
      // Do stuff
      return;
   }

   // Default values:
   prefs.setBool('wasOpenedBefore', true);
}
