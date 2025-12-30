abstract class RoleEvent {}

class LoadRoles extends RoleEvent {}

class LoadRoleById extends RoleEvent {
  final String roleId;
  LoadRoleById(this.roleId);
}

class DeleteRoleById extends RoleEvent {
  final String roleId;
  DeleteRoleById(this.roleId);
}

class UpdateRoleById extends RoleEvent {
  final String roleId;
  final Map<String, dynamic> updatedData;
  UpdateRoleById(this.roleId, this.updatedData);
}
