import 'package:deep_manage_app/Model/Brand/BrandModel.dart';
import '../ApiService/BrandApi/BrandApi.dart';

class BrandRepository {
  final BrandApi brandApi;

  BrandRepository({required this.brandApi});

  Future<void> addBrand(Map<String, dynamic> data) async {
    await brandApi.addBrand(data);
  }

  Future<List<BrandModel>> getBrand() {
    return brandApi.getBrand();
  }

  Future<BrandModel> getBrandById(String id) {
    return brandApi.getBrandById(id);
  }

  Future<void> deleteBrand(String id) {
    return brandApi.deleteBrand(id);
  }

  Future<void> updateBrand(String id, Map<String, dynamic> data) {
    return brandApi.updateBrand(id, data);
  }
}