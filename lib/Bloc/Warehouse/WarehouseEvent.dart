abstract class WarehouseEvent {}

class LoadWarehouse extends WarehouseEvent {
  final bool showDeleted;
  LoadWarehouse({this.showDeleted = false});
}

class LoadWarehouseById extends WarehouseEvent {
  final String warehouseId;
  LoadWarehouseById(this.warehouseId);
}

class CreateWarehouse extends WarehouseEvent {
  final Map<String, dynamic> data;
  CreateWarehouse(this.data);
}

class DeleteWarehouse extends WarehouseEvent {
  final String warehouseId;

  DeleteWarehouse(this.warehouseId);
}

class UpdateWarehouse extends WarehouseEvent {
  final String warehouseId;
  final Map<String, dynamic> updatedData;
  UpdateWarehouse(this.warehouseId, this.updatedData);
}

class RestoreWarehouse extends WarehouseEvent {
  final String warehouseId;
  RestoreWarehouse(this.warehouseId);
}