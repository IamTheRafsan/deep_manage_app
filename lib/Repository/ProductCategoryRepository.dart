import 'package:deep_manage_app/Model/ProductCategory/ProductCategoryModel.dart';
import '../ApiService/ProductCategoryApi/ProductCategoryApi.dart';

class ProductCategoryRepository {
  final ProductCategoryApi productCategoryApi;

  ProductCategoryRepository({required this.productCategoryApi});

  Future<void> addProductCategory(Map<String, dynamic> data) async {
    await productCategoryApi.addProductCategory(data);
  }

  Future<List<ProductCategoryModel>> getProductCategory() {
    return productCategoryApi.getProductCategory();
  }

  Future<ProductCategoryModel> getProductCategoryById(String id) {
    return productCategoryApi.getProductCategoryById(id);
  }

  Future<void> deleteProductCategory(String id) {
    return productCategoryApi.deleteProductCategory(id);
  }

  Future<void> updateProductCategory(String id, Map<String, dynamic> data) {
    return productCategoryApi.updateProductCategory(id, data);
  }
}