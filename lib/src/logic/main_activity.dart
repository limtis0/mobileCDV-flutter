import 'structures/usertoken.dart';
import 'package:mobile_cdv/src/logic/decoder.dart';
import 'package:mobile_cdv/src/logic/request.dart';
import 'package:mobile_cdv/src/logic/storage.dart';
import 'package:mobile_cdv/src/logic/time_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void activitySignIn(String email, String password)
{
  LoginResponse loginResponse = fetchLogin(email, password) as LoginResponse;

  final SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
  
  prefs.setBool('isUserLoggedIn', true);

  prefs.setString('savedEmail', email);
  prefs.setString('savedPassword', password);
  prefs.setString('savedTokenEncoded', loginResponse.token);
  
  UserToken token = decodeToken(loginResponse.token);
  saveImage(decodeImage(loginResponse.photo), 'avatar.png');

  prefs.setString('savedUserName', token.userName);
  prefs.setString('savedUserType', token.userType);
  prefs.setString('savedUserAlbumNumber', token.userAlbumNumer);

  // Sets schedule from the start of current month up to the start of next month
  fetchSchedule(token.userType, token.userId.toString(), getMonthsFromNowFirstDayAPI(0), getMonthsFromNowFirstDayAPI(1), loginResponse.token);
}

void activitySignOut() async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isUserLoggedIn', false);

  await prefs.remove('savedEmail');
  await prefs.remove('savedPassword');
  await prefs.remove('savedTokenEncoded');
  await prefs.remove('savedUserName');
  await prefs.remove('savedUserType');
  await prefs.remove('savedUserAlbumNumber');

  removeFile('avatar.png');
}
