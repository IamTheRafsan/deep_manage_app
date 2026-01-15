import 'package:deep_manage_app/Model/Product/ProductModel.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded(this.products);
}

class ProductLoadedSingle extends ProductState {
  final ProductModel product;
  ProductLoadedSingle(this.product);
}

class ProductCreated extends ProductState {}

class ProductDeleted extends ProductState {}

class ProductUpdated extends ProductState {}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}