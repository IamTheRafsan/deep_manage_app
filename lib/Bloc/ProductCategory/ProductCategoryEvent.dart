abstract class ProductCategoryEvent {}

class LoadProductCategory extends ProductCategoryEvent {
  final bool showDeleted;
  LoadProductCategory({this.showDeleted = false});
}

class LoadProductCategoryById extends ProductCategoryEvent {
  final String productCategoryId;
  LoadProductCategoryById(this.productCategoryId);
}

class CreateProductCategory extends ProductCategoryEvent {
  final Map<String, dynamic> data;
  CreateProductCategory(this.data);
}

class DeleteProductCategory extends ProductCategoryEvent {
  final String productCategoryId;
  DeleteProductCategory(this.productCategoryId);
}

class UpdateProductCategory extends ProductCategoryEvent {
  final String productCategoryId;
  final Map<String, dynamic> updatedData;
  UpdateProductCategory(this.productCategoryId, this.updatedData);
}