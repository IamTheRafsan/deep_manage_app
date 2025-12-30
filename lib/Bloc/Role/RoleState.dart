import '../../Model/RoleModel/RoleModel.dart';

abstract class RoleState {}

class RoleInitial extends RoleState {}

class RoleLoading extends RoleState {}

class RoleLoaded extends RoleState {
  final List<RoleModel> roles;
  RoleLoaded(this.roles);
}

class RoleError extends RoleState {
  final String message;
  RoleError(this.message);
}

class RoleLoadedSingle extends RoleState {
  final RoleModel role;
  RoleLoadedSingle(this.role);
}
class RoleDeleted extends RoleState {}

class RoleUpdated extends RoleState {}