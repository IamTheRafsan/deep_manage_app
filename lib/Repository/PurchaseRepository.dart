import 'package:deep_manage_app/Model/Purchase/PurchaseModel.dart';
import '../ApiService/PurchaseApi/PurchaseApi.dart';

class PurchaseRepository {
  final PurchaseApi purchaseApi;

  PurchaseRepository({required this.purchaseApi});

  // Create new purchase
  Future<void> addPurchase(PurchaseModel purchase) async {
    final data = purchase.toApiJson();
    await purchaseApi.addPurchase(data);
  }

  // View all purchases (only non-deleted)
  Future<List<PurchaseModel>> getPurchases() {
    return purchaseApi.getPurchases();
  }

  // View all purchases including deleted (for admin)
  Future<List<PurchaseModel>> getAllPurchases() {
    return purchaseApi.getPurchases();
  }

  // View purchase by id
  Future<PurchaseModel> getPurchaseById(String id) {
    return purchaseApi.getPurchaseById(id);
  }

  // Delete purchase (soft delete handled by backend)
  Future<void> deletePurchase(String id) async {
    await purchaseApi.deletePurchase(id);
  }

  // Update purchase
  Future<void> updatePurchase(String id, PurchaseModel purchase) async {
    final data = purchase.toApiJson();
    return purchaseApi.updatePurchase(id, data);
  }

  // Restore soft deleted purchase
  Future<void> restorePurchase(String id) async {
    final data = {
      "deleted": false,
      "deletedById": null,
      "deletedByName": null,
      "deletedDate": null,
      "deletedTime": null,
    };

    return purchaseApi.updatePurchase(id, data);
  }
}