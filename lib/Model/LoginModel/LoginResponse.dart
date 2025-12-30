import '../User/UserModel.dart';

class LoginResponse {
  final String token;
  final UserModel user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final tokenData = json['token'];

    return LoginResponse(
      token: tokenData['token'],
      user: UserModel.fromJson(tokenData['user']),
    );
  }
}
