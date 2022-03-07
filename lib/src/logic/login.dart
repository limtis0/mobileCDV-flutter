import 'package:mobile_cdv/src/logic/decoder.dart';
import 'package:mobile_cdv/src/logic/request.dart';

void login(String email, String password){
  LoginResponse loginResponse = fetchLogin(email, password) as LoginResponse;

  UserToken token = decodeToken(loginResponse.token);

  List schedule = fetchSchedule(token.userId.toString(), '2022-02-01', '2022-06-01', loginResponse.token) as List;

  
}