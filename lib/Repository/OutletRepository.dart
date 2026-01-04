// lib/Repository/OutletRepository.dart
import 'package:deep_manage_app/Model/Outlet/OutletModel.dart';
import '../ApiService/OutletApi/OutletApi.dart';

class OutletRepository {
  final OutletApi outletApi;

  OutletRepository({required this.outletApi});

  // Create new outlet
  Future<void> addOutlet(Map<String, dynamic> data) async {
    await outletApi.addOutlet(data);
  }

  // View all outlets
  Future<List<OutletModel>> getOutlet() {
    return outletApi.getOutlet();
  }

  // View outlet by id
  Future<OutletModel> getOutletById(String id) {
    return outletApi.getOutletById(id);
  }

  // Delete outlet by id
  Future<void> deleteOutlet(String id) {
    return outletApi.deleteOutlet(id);
  }

  // Update outlet
  Future<void> updateOutlet(String id, Map<String, dynamic> data) {
    return outletApi.updateOutlet(id, data);
  }
}