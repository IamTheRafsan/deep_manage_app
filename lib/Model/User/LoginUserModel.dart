import '../User/UserModel.dart';

class LoginUserModel {
  final String token;
  final UserModel user;

  LoginUserModel({required this.token, required this.user});

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      token: json['token']['token'],
      user: UserModel.fromJson(json['token']['user']),
    );
  }
}