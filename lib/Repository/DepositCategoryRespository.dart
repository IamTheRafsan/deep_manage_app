// lib/Repository/DepositCategoryRepository.dart
import 'package:deep_manage_app/Model/DepositCategory/DepositCategoryModel.dart';
import '../ApiService/DepositCategoryApi/DepositCategoryApi.dart';

class DepositCategoryRepository {
  final DepositCategoryApi depositCategoryApi;

  DepositCategoryRepository({required this.depositCategoryApi});

  Future<void> addDepositCategory(Map<String, dynamic> data) async {
    await depositCategoryApi.addDepositCategory(data);
  }

  Future<List<DepositCategoryModel>> getDepositCategory() {
    return depositCategoryApi.getDepositCategory();
  }

  Future<DepositCategoryModel> getDepositCategoryById(String id) {
    return depositCategoryApi.getDepositCategoryById(id);
  }

  Future<void> deleteDepositCategory(String id) {
    return depositCategoryApi.deleteDepositCategory(id);
  }

  Future<void> updateDepositCategory(String id, Map<String, dynamic> data) {
    return depositCategoryApi.updateDepositCategory(id, data);
  }
}