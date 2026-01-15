import 'package:deep_manage_app/Model/Purchase/PurchaseModel.dart';

abstract class PurchaseState {}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchaseLoaded extends PurchaseState {
  final List<PurchaseModel> purchases;
  PurchaseLoaded(this.purchases);
}

class PurchaseLoadedSingle extends PurchaseState {
  final PurchaseModel purchase;
  PurchaseLoadedSingle(this.purchase);
}

class PurchaseCreated extends PurchaseState {}

class PurchaseDeleted extends PurchaseState {}

class PurchaseUpdated extends PurchaseState {}

class PurchaseRestored extends PurchaseState {}

class PurchaseError extends PurchaseState {
  final String message;
  PurchaseError(this.message);
}