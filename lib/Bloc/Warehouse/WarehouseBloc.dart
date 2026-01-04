import 'package:deep_manage_app/Bloc/Warehouse/WarehouseEvent.dart';
import 'package:deep_manage_app/Bloc/Warehouse/WarehouseState.dart';
import 'package:deep_manage_app/Repository/WarehouseRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  final WarehouseRepository warehouseRepository;

  WarehouseBloc({required this.warehouseRepository}) : super(WarehouseInitial()) {
    on<LoadWarehouse>((event, emit) async {
      emit(WarehouseLoading());
      try {
        final warehouses = await warehouseRepository.getWarehouse();
        // Filter deleted warehouses if needed
        final filteredWarehouses = event.showDeleted
            ? warehouses
            : warehouses.where((w) => !w.deleted).toList();
        emit(WarehouseLoaded(filteredWarehouses));
      } catch (e) {
        emit(WarehouseError(e.toString()));
      }
    });

    on<LoadWarehouseById>((event, emit) async {
      emit(WarehouseLoading());
      try {
        final warehouse = await warehouseRepository.getWarehouseById(event.warehouseId);
        emit(WarehouseLoadedSingle(warehouse));
      } catch (e) {
        emit(WarehouseError(e.toString()));
      }
    });

    on<CreateWarehouse>((event, emit) async {
      emit(WarehouseLoading());
      try {
        await warehouseRepository.addWarehouse(
          name: event.data['name'],
          email: event.data['email'],
          mobile: event.data['mobile'],
          country: event.data['country'],
          city: event.data['city'],
          area: event.data['area'],
          status: event.data['status'],
          createdById: event.data['created_by_id'],
        );
        emit(WarehouseCreated());
      } catch (e) {
        emit(WarehouseError(e.toString()));
      }
    });

    on<DeleteWarehouse>((event, emit) async {
      emit(WarehouseLoading());
      try {
        await warehouseRepository.deleteWarehouse(
          id: event.warehouseId,
        );
        emit(WarehouseDeleted());
      } catch (e) {
        emit(WarehouseError(e.toString()));
      }
    });

    on<UpdateWarehouse>((event, emit) async {
      emit(WarehouseLoading());
      try {
        await warehouseRepository.updateWarehouse(
          id: event.warehouseId,
          data: event.updatedData,
          updatedById: event.updatedData['updated_by_id'],
        );
        emit(WarehouseUpdated());
      } catch (e) {
        emit(WarehouseError(e.toString()));
      }
    });

    on<RestoreWarehouse>((event, emit) async {
      emit(WarehouseLoading());
      try {
        await warehouseRepository.restoreWarehouse(event.warehouseId);
        emit(WarehouseRestored());
      } catch (e) {
        emit(WarehouseError(e.toString()));
      }
    });
  }
}