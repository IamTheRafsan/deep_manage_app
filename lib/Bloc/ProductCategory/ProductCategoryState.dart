import 'package:deep_manage_app/Model/ProductCategory/ProductCategoryModel.dart';

abstract class ProductCategoryState {}

class ProductCategoryInitial extends ProductCategoryState {}

class ProductCategoryLoading extends ProductCategoryState {}

class ProductCategoryLoaded extends ProductCategoryState {
  final List<ProductCategoryModel> productCategories;
  ProductCategoryLoaded(this.productCategories);
}

class ProductCategoryLoadedSingle extends ProductCategoryState {
  final ProductCategoryModel productCategory;
  ProductCategoryLoadedSingle(this.productCategory);
}

class ProductCategoryCreated extends ProductCategoryState {}

class ProductCategoryDeleted extends ProductCategoryState {}

class ProductCategoryUpdated extends ProductCategoryState {}

class ProductCategoryError extends ProductCategoryState {
  final String message;
  ProductCategoryError(this.message);
}