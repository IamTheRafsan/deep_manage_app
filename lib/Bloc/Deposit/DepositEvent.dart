abstract class DepositEvent {}

class LoadDeposit extends DepositEvent {
  final bool showDeleted;
  LoadDeposit({this.showDeleted = false});
}

class LoadDepositById extends DepositEvent {
  final String depositId;
  LoadDepositById(this.depositId);
}

class CreateDeposit extends DepositEvent {
  final Map<String, dynamic> data;
  CreateDeposit(this.data);
}

class DeleteDeposit extends DepositEvent {
  final String depositId;
  DeleteDeposit(this.depositId);
}

class UpdateDeposit extends DepositEvent {
  final String depositId;
  final Map<String, dynamic> updatedData;
  UpdateDeposit(this.depositId, this.updatedData);
}