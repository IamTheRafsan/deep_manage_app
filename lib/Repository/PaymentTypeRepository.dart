import 'package:deep_manage_app/Model/PaymentType/PaymentTypeModel.dart';
import '../ApiService/PaymentTypeApi/PaymentTypeApi.dart';

class PaymentTypeRepository {
  final PaymentTypeApi paymentTypeApi;

  PaymentTypeRepository({required this.paymentTypeApi});

  // Create new payment type
  Future<void> addPaymentType({
    required String name,
    required String createdById,
  }) async {
    final data = {
      "name": name,
      "created_by_id": createdById,
    };

    await paymentTypeApi.addPaymentType(data);
  }

  // View all payment types (only non-deleted)
  Future<List<PaymentTypeModel>> getPaymentTypes() {
    return paymentTypeApi.getPaymentTypes();
  }

  // View all payment types including deleted (for admin)
  Future<List<PaymentTypeModel>> getAllPaymentTypes() {
    return paymentTypeApi.getPaymentTypes();
  }

  // View payment type by id
  Future<PaymentTypeModel> getPaymentTypeById(String id) {
    return paymentTypeApi.getPaymentTypeById(id);
  }

  // Soft delete payment type
  Future<void> deletePaymentType({
    required String id
  }) async {
    return paymentTypeApi.deletePaymentType(id);
  }

  // Update payment type
  Future<void> updatePaymentType({
    required String id,
    required Map<String, dynamic> data,
    required String updatedById,
  }) async {
    final updatedData = {
      ...data,
      "updated_by_id": updatedById,
    };

    return paymentTypeApi.updatePaymentType(id, updatedData);
  }

  // Restore soft deleted payment type
  Future<void> restorePaymentType(String id) async {
    final data = {
      "deleted": false,
      "deletedById": null,
      "deletedByName": null,
      "deletedDate": null,
      "deletedTime": null,
    };

    return paymentTypeApi.updatePaymentType(id, data);
  }
}