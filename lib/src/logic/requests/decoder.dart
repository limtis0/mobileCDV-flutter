import 'dart:convert';
import 'dart:typed_data';
import 'package:jwt_decode/jwt_decode.dart';

import 'package:mobile_cdv/src/logic/structures/usertoken.dart';

UserToken decodeToken(String token)
{
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  return UserToken.fromJson(payload['data']);
}

Uint8List decodeImage(String imageBase64)
{
  return base64Decode(imageBase64);
}
