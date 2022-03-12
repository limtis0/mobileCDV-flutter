import 'dart:io';
import 'dart:typed_data';
import 'structures/usertoken.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getLocalPath() async
{
   Directory directory = await getApplicationDocumentsDirectory();
   return directory.path;
}

// Gets Uint8List on input and saves it as an image (i.e. test.png)
Future<void> saveImage(Uint8List imageBytes, String fileName) async
{
   final String filePath = await getLocalPath();
   final file = File('$filePath/$fileName');
   await file.writeAsBytes(imageBytes);
}

Future<void> removeFile(String fileName) async
{
   final String filePath = await getLocalPath();
   final file = File('$filePath/$fileName');
   await file.delete();
}

/* TODO Choose the library with Image data type that suits front-end
   and make getImageFromFile() function;
 */

Future<void> initPrefs() async
{
   final SharedPreferences prefs = await SharedPreferences.getInstance();

   bool? wasOpenedBefore = prefs.getBool('wasOpenedBefore');
   if (wasOpenedBefore == true)
   {
      return;
   }

   // On first app opening:
   await prefs.setBool('wasOpenedBefore', true);
   setDefaultPreferences();
}

Future<void> setDefaultPreferences() async
{
   final SharedPreferences prefs = await SharedPreferences.getInstance();

   await prefs.setInt('themeId', 0);
   await prefs.setBool('isUserLoggedIn', false);
   await prefs.setString('localization', 'en');
}

Future<void> setPrefsOnSignIn(String email, String password, String tokenEncoded, UserToken token) async
{
   final SharedPreferences prefs = await SharedPreferences.getInstance();

   await prefs.setBool('isUserLoggedIn', true);

   await prefs.setString('savedEmail', email);
   await prefs.setString('savedPassword', password);
   await prefs.setString('savedTokenEncoded', tokenEncoded);

   await prefs.setString('savedUserName', token.userName);
   await prefs.setString('savedUserType', token.userType);
   await prefs.setString('savedUserAlbumNumber', token.userAlbumNumer);
}