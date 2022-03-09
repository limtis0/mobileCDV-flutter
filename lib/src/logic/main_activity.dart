// branch
import 'structures/usertoken.dart';
import 'package:mobile_cdv/src/logic/decoder.dart';
import 'package:mobile_cdv/src/logic/request.dart';
import 'package:mobile_cdv/src/logic/storage.dart';
import 'package:mobile_cdv/src/logic/time_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> activitySignIn(String email, String password) async
{
  final LoginResponse loginResponse = await fetchLogin(email, password);

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isUserLoggedIn', true);

  await prefs.setString('savedEmail', email);
  await prefs.setString('savedPassword', password);
  await prefs.setString('savedTokenEncoded', loginResponse.token);
  
  UserToken token = decodeToken(loginResponse.token);
  await saveImage(decodeImage(loginResponse.photo), 'avatar.png');

  await prefs.setString('savedUserName', token.userName);
  await prefs.setString('savedUserType', token.userType);
  await prefs.setString('savedUserAlbumNumber', token.userAlbumNumer);

  // Sets schedule from the start of current month up to the start of next month
  try {
    prefs.setBool('isUserLoggedIn', true);
    await fetchSchedule(token.userType, token.userId.toString(), getMonthsFromNowFirstDayAPI(0), getMonthsFromNowFirstDayAPI(1), loginResponse.token);
  }catch(e) {
    rethrow;
  }
}

Future<void> activitySignOut() async
{
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isUserLoggedIn', false);

  await prefs.remove('savedEmail');
  await prefs.remove('savedPassword');
  await prefs.remove('savedTokenEncoded');
  await prefs.remove('savedUserName');
  await prefs.remove('savedUserType');
  await prefs.remove('savedUserAlbumNumber');

  await removeFile('avatar.png');
}
