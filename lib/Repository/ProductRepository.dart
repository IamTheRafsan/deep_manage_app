import 'package:deep_manage_app/Model/Product/ProductModel.dart';
import '../ApiService/ProductApi/ProductApi.dart';

class ProductRepository {
  final ProductApi productApi;

  ProductRepository({required this.productApi});

  Future<void> addProduct(Map<String, dynamic> data) async {
    await productApi.addProduct(data);
  }

  Future<List<ProductModel>> getProduct() {
    return productApi.getProduct();
  }

  Future<ProductModel> getProductById(String id) {
    return productApi.getProductById(id);
  }

  Future<void> deleteProduct(String id) {
    return productApi.deleteProduct(id);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) {
    return productApi.updateProduct(id, data);
  }
}