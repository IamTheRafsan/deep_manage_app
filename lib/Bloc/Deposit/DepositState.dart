import 'package:deep_manage_app/Model/Deposit/DepositModel.dart';

abstract class DepositState {}

class DepositInitial extends DepositState {}

class DepositLoading extends DepositState {}

class DepositLoaded extends DepositState {
  final List<DepositModel> deposits;
  DepositLoaded(this.deposits);
}

class DepositLoadedSingle extends DepositState {
  final DepositModel deposit;
  DepositLoadedSingle(this.deposit);
}

class DepositCreated extends DepositState {}

class DepositDeleted extends DepositState {}

class DepositUpdated extends DepositState {}

class DepositError extends DepositState {
  final String message;
  DepositError(this.message);
}