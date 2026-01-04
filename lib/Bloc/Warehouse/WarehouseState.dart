import 'package:deep_manage_app/Model/Warehouse/WarehouseModel.dart';

abstract class WarehouseState {}

class WarehouseInitial extends WarehouseState {}

class WarehouseLoading extends WarehouseState {}

class WarehouseLoaded extends WarehouseState {
  final List<WarehouseModel> warehouses;
  WarehouseLoaded(this.warehouses);
}

class WarehouseLoadedSingle extends WarehouseState {
  final WarehouseModel warehouse;
  WarehouseLoadedSingle(this.warehouse);
}

class WarehouseCreated extends WarehouseState {}

class WarehouseDeleted extends WarehouseState {}

class WarehouseUpdated extends WarehouseState {}

class WarehouseRestored extends WarehouseState {}

class WarehouseError extends WarehouseState {
  final String message;
  WarehouseError(this.message);
}