import 'package:deep_manage_app/Bloc/Product/ProductEvent.dart';
import 'package:deep_manage_app/Bloc/Product/ProductState.dart';
import 'package:deep_manage_app/Repository/ProductRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<LoadProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productRepository.getProduct();
        // Filter deleted products if needed
        final filteredProducts = event.showDeleted
            ? products
            : products.where((p) => !p.deleted).toList();
        emit(ProductLoaded(filteredProducts));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<LoadProductById>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = await productRepository.getProductById(event.productId);
        emit(ProductLoadedSingle(product));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<CreateProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        await productRepository.addProduct(event.data);
        emit(ProductCreated());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<DeleteProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        await productRepository.deleteProduct(event.productId);
        emit(ProductDeleted());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<UpdateProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        await productRepository.updateProduct(
          event.productId,
          event.updatedData,
        );
        emit(ProductUpdated());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}