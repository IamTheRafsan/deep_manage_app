import 'package:deep_manage_app/Model/Purchase/PurchaseModel.dart';

abstract class PurchaseEvent {}

class LoadPurchases extends PurchaseEvent {
  final bool showDeleted;
  LoadPurchases({this.showDeleted = false});
}

class LoadPurchaseById extends PurchaseEvent {
  final String purchaseId;
  LoadPurchaseById(this.purchaseId);
}

class CreatePurchase extends PurchaseEvent {
  final PurchaseModel purchase;
  CreatePurchase(this.purchase);
}

class DeletePurchase extends PurchaseEvent {
  final String purchaseId;
  DeletePurchase(this.purchaseId);
}

class UpdatePurchase extends PurchaseEvent {
  final String purchaseId;
  final PurchaseModel purchase;
  UpdatePurchase(this.purchaseId, this.purchase);
}

class RestorePurchase extends PurchaseEvent {
  final String purchaseId;
  RestorePurchase(this.purchaseId);
}