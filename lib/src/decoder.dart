import 'package:mobile_cdv/src/request.dart';
import 'package:jwt_decode/jwt_decode.dart';

// class UserToken
// {
//
// }

// TODO String token
void decodeToken() async
{
  LoginResponse login = await fetchLogin("izakharov@edu.cdv.pl", "34r+KktH3VA");
  Map<String, dynamic> payload = Jwt.parseJwt(login.token);
  print(payload);
}