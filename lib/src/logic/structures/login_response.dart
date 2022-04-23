class LoginResponse {
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

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse
      (
      result: json['result'],
      token: json['token'],
      message: json['message'],
      photo: json['photo'],
    );
  }
}
