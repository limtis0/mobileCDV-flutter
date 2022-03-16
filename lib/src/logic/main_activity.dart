import 'structures/usertoken.dart';
import 'structures/login_response.dart';
import 'package:mobile_cdv/src/logic/decoder.dart';
import 'package:mobile_cdv/src/logic/request.dart';
import 'package:mobile_cdv/src/logic/storage.dart';
import 'package:mobile_cdv/src/logic/time_operations.dart';
import 'package:mobile_cdv/src/logic/structures/exceptions.dart';
import 'package:mobile_cdv/src/logic/globals.dart' as globals;

Future<void> activitySignIn(String email, String password) async
{
  final LoginResponse loginResponse = await fetchLogin(email.trim(), password);

  UserToken token = decodeToken(loginResponse.token);

  await saveImage(decodeImage(loginResponse.photo), 'avatar.png');
  globals.avatar = await imageToWidget('avatar.png');

  await setPrefsOnSignIn(email.trim(), password, loginResponse.token, token);
  await globals.loadFromPrefs();

  try
  {
    await fetchSchedule(token.userType, token.userId.toString(),
        getMonthsFromNowFirstDayAPI(-2), getMonthsFromNowLastDayAPI(6), loginResponse.token);
  }
  on RequestErrorException
  {
    rethrow;
  }
}

Future<void> activitySignOut() async
{
  await clearPrefs();
  globals.clear();

  await removeFile('avatar.png');
}
