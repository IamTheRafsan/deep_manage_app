abstract class ProductEvent {}

class LoadProduct extends ProductEvent {
  final bool showDeleted;
  LoadProduct({this.showDeleted = false});
}

class LoadProductById extends ProductEvent {
  final String productId;
  LoadProductById(this.productId);
}

class CreateProduct extends ProductEvent {
  final Map<String, dynamic> data;
  CreateProduct(this.data);
}

class DeleteProduct extends ProductEvent {
  final String productId;
  DeleteProduct(this.productId);
}

class UpdateProduct extends ProductEvent {
  final String productId;
  final Map<String, dynamic> updatedData;
  UpdateProduct(this.productId, this.updatedData);
}