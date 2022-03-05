import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

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

Image decodeImage(String imageBase64)
{
  return Image.memory(base64Decode(imageBase64));
}
