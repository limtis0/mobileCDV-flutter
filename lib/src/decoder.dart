import 'dart:typed_data';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';

class UserToken
{
  // Skipped cbduID, roles and round
  final int userId;
  final String userLogin;
  final String userType;
  final String userName;
  final String userAlbumNumer;

  const UserToken({
    required this.userId,
    required this.userLogin,
    required this.userType,
    required this.userName,
    required this.userAlbumNumer,
  });

  factory UserToken.fromJson(Map<String, dynamic> json)
  {
    return UserToken
    (
      userId: json['verbisId'],
      userLogin: json['login'],
      userType: json['userType'],
      userName: json['displayName'],
      userAlbumNumer: json['album'],
    );
  }
}

UserToken decodeToken(String token)
{
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  return UserToken.fromJson(payload['data']);
}

// TODO Convert Uint8List to savable image
Uint8List decodeImage(String imageBase64)
{
  return base64Decode(imageBase64);
}
