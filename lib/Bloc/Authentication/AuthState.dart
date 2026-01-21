
import 'package:equatable/equatable.dart';

import '../../Model/User/LoginUserModel.dart';
import '../../Model/User/UserModel.dart';

abstract class AuthState extends Equatable{
  const AuthState();

  @override
  List<Object> get props => [];

}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  final UserModel user;

  const AuthSuccess({required this.token, required this.user});

  @override
  List<Object> get props => [token];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthLoggedOut extends AuthState {}