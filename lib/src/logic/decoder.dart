<<<<<<< HEAD
import 'structures/usertoken.dart';
=======
import 'dart:convert';
>>>>>>> origin/f
import 'dart:typed_data';
import 'structures/usertoken.dart';
import 'package:jwt_decode/jwt_decode.dart';
<<<<<<< HEAD
import 'dart:convert';
=======
>>>>>>> origin/f

UserToken decodeToken(String token)
{
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  return UserToken.fromJson(payload['data']);
}

Uint8List decodeImage(String imageBase64)
{
  return base64Decode(imageBase64);
}
