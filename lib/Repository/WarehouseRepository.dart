import 'package:deep_manage_app/Model/Warehouse/WarehouseModel.dart';
import '../ApiService/WarehouseApi/WarehouseApi.dart';

class WarehouseRepository {
  final WarehouseApi warehouseApi;

  WarehouseRepository({required this.warehouseApi});

  // Create new warehouse
  Future<void> addWarehouse({
    required String name,
    required String email,
    required String mobile,
    required String country,
    required String city,
    required String area,
    required String status,
    required String createdById,
  }) async {
    final data = {
      "name": name,
      "email": email,
      "mobile": mobile,
      "country": country,
      "city": city,
      "area": area,
      "status": status,
      "created_by_id": createdById,
    };

    await warehouseApi.addWarehouse(data);
  }

  // View all warehouses (only non-deleted)
  Future<List<WarehouseModel>> getWarehouse() {
    return warehouseApi.getWarehouse();
  }

  // View all warehouses including deleted (for admin)
  Future<List<WarehouseModel>> getAllWarehouse() {
    return warehouseApi.getWarehouse();
  }

  // View warehouse by id
  Future<WarehouseModel> getWarehouseById(String id) {
    return warehouseApi.getWarehouseById(id);
  }

  // Soft delete warehouse
  Future<void> deleteWarehouse({
    required String id,
  }) async {

    // Assuming your backend handles soft delete
    await warehouseApi.deleteWarehouse(id);
  }

  // Update warehouse
  Future<void> updateWarehouse({
    required String id,
    required Map<String, dynamic> data,
    required String updatedById,
  }) async {
    final updatedData = {
      ...data,
      "updated_by_id": updatedById,
    };

    return warehouseApi.updateWarehouse(id, updatedData);
  }

  // Restore soft deleted warehouse
  Future<void> restoreWarehouse(String id) async {
    final data = {
      "deleted": false,
      "deletedById": null,
      "deletedByName": null,
      "deletedDate": null,
      "deletedTime": null,
    };

    return warehouseApi.updateWarehouse(id, data);
  }
}