import '../structures/usertoken.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  bool? wasOpenedBefore = prefs.getBool('wasOpenedBefore');
  if (wasOpenedBefore == true) {
    return;
  }

  // On first app opening:
  await prefs.setBool('wasOpenedBefore', true);
  setDefaultPreferences();
}

Future<void> setDefaultPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setInt('themeId', 0);
  await prefs.setBool('isUserLoggedIn', false);
  await prefs.setString('localization', 'en');
  await prefs.setBool('notificationsToggle', true);
  await prefs.setInt('notificationsTime', 3600);
}

Future<void> setPrefsOnSignIn(String email, String password, String tokenEncoded, UserToken token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isUserLoggedIn', true);

  await prefs.setString('savedEmail', email);
  await prefs.setString('savedPassword', password);
  await prefs.setString('savedTokenEncoded', tokenEncoded);

  await prefs.setString('savedUserName', token.userName);
  await prefs.setString('savedUserType', token.userType);
  await prefs.setString('savedUserAlbumNumber', token.userAlbumNumer);
}

Future<void> clearPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isUserLoggedIn', false);

  await prefs.remove('savedEmail');
  await prefs.remove('savedPassword');
  await prefs.remove('savedTokenEncoded');
  await prefs.remove('savedUserName');
  await prefs.remove('savedUserType');
  await prefs.remove('savedUserAlbumNumber');
}