import 'dart:convert';
import 'dart:typed_data';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mobile_cdv/src/logic/structures/usertoken.dart';

/// Decodes token and fits it into usertoken structure
UserToken decodeToken(String token) {
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  return UserToken.fromJson(payload['data']);
}

/// Decodes image from API response
Uint8List decodeImage(String imageBase64) {
  return base64Decode(imageBase64);
}
