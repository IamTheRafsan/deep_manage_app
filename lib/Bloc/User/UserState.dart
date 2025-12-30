import 'package:deep_manage_app/Model/User/UserModel.dart';

abstract class UserState{}

class UserInitial extends UserState{}

class UserLoading extends UserState{}

class UserLoaded extends UserState{
  final List<UserModel> users;
  UserLoaded(this.users);
}

class UserLoadedSingle extends UserState{
  final UserModel user;
  UserLoadedSingle(this.user);
}

class UserCreated extends UserState {}

class UserDeleted extends UserState {}

class UserUpdated extends UserState {}

class UserError extends UserState{
  final String message;
  UserError(this.message);
}

