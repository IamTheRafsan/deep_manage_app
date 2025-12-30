
abstract class UserEvent{}

class LoadUser extends UserEvent {}

class LoadUserById extends UserEvent {
  final String userId;
  LoadUserById(this.userId);
}

class CreateUser extends UserEvent{
  final Map<String, dynamic> data;
  CreateUser(this.data);

}

class DeleteUser extends UserEvent{
  final String userId;
  DeleteUser(this.userId);
}

class UpdateUser extends UserEvent {
  final String userId;
  final Map<String, dynamic> updatedData;
  UpdateUser(this.userId, this.updatedData);
}