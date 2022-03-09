// branch
class UserToken
{
  // Skipped cbduID, roles and round
  final int userId;
  final String userEmail;
  final String userType;
  final String userName;
  final String userAlbumNumer;

  const UserToken({
    required this.userId,
    required this.userEmail,
    required this.userType,
    required this.userName,
    required this.userAlbumNumer,
  });

  factory UserToken.fromJson(Map<String, dynamic> json)
  {
    return UserToken
      (
      userId: json['verbisId'],
      userEmail: json['login'],
      userType: json['userType'],
      userName: json['displayName'],
      userAlbumNumer: json['album'],
    );
  }
}