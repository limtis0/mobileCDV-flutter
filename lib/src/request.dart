import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginResponse
{
  final bool result;
  final String token;
  final String? message;
  final String photo;

  const LoginResponse({
    required this.result,
    required this.token,
    required this.message,
    required this.photo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json)
  {
    return LoginResponse
      (
      result: json['result'],
      token: json['token'],
      message: json['message'],
      photo: json['photo'],
    );
  }
}

Future<LoginResponse> fetchLogin(String login, String password) async
{
  final response = await http.post(
    Uri.parse('https://api.cdv.pl/mobilnecdv-api/login'),
    body: jsonEncode(<String, String>
    {
      'login': login,
      'password': password,
    })
  );

  if (response.statusCode == 200)
  {
    return LoginResponse.fromJson(jsonDecode(response.body));
  }
  else
  {
    throw Exception('Failed to login.');
  }
}