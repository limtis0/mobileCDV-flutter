import '../structures/usertoken.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initializes sharedPrefs on app start
Future<void> initPrefs() async {
  // TODO: Use same prefs instance globally
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  bool? wasOpenedBefore = prefs.getBool('wasOpenedBefore');
  if (wasOpenedBefore == true) {
    return;
  }

  // On first app opening:
  await prefs.setBool('wasOpenedBefore', true);
  setDefaultPreferences();
}

/// Sets sharedPrefs to default values
Future<void> setDefaultPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setInt('themeId', 0);
  await prefs.setBool('isUserLoggedIn', false);
  await prefs.setString('localization', 'pl');
  await prefs.setBool('notificationsToggle', true);
  await prefs.setInt('notificationsTime', 3600);
}

/// Sets sharedPrefs after logging in
Future<void> setPrefsOnSignIn(String email, String password, String tokenEncoded, UserToken token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isUserLoggedIn', true);

  await prefs.setString('savedEmail', email);
  await prefs.setString('savedPassword', password);
  await prefs.setString('savedTokenEncoded', tokenEncoded);

  await prefs.setString('savedUserName', token.userName);
  await prefs.setString('savedUserType', token.userType);
  await prefs.setString('savedUserAlbumNumber', token.userAlbumNumer);
  await prefs.setString('savedUserId', token.userId.toString());
}

/// Clears sharedPrefs after logging out
Future<void> clearPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isUserLoggedIn', false);

  await prefs.remove('savedEmail');
  await prefs.remove('savedPassword');
  await prefs.remove('savedTokenEncoded');
  await prefs.remove('savedUserName');
  await prefs.remove('savedUserType');
  await prefs.remove('savedUserAlbumNumber');
  await prefs.remove('savedUserId');
}