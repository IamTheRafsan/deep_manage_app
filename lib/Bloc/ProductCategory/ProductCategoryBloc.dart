import 'package:deep_manage_app/Bloc/ProductCategory/ProductCategoryEvent.dart';
import 'package:deep_manage_app/Bloc/ProductCategory/ProductCategoryState.dart';
import 'package:deep_manage_app/Repository/ProductCategoryRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCategoryBloc extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  final ProductCategoryRepository productCategoryRepository;

  ProductCategoryBloc({required this.productCategoryRepository}) : super(ProductCategoryInitial()) {
    on<LoadProductCategory>((event, emit) async {
      emit(ProductCategoryLoading());
      try {
        final categories = await productCategoryRepository.getProductCategory();
        // Filter deleted categories if needed
        final filteredCategories = event.showDeleted
            ? categories
            : categories.where((c) => !c.deleted).toList();
        emit(ProductCategoryLoaded(filteredCategories));
      } catch (e) {
        emit(ProductCategoryError(e.toString()));
      }
    });

    on<LoadProductCategoryById>((event, emit) async {
      emit(ProductCategoryLoading());
      try {
        final category = await productCategoryRepository.getProductCategoryById(event.productCategoryId);
        emit(ProductCategoryLoadedSingle(category));
      } catch (e) {
        emit(ProductCategoryError(e.toString()));
      }
    });

    on<CreateProductCategory>((event, emit) async {
      emit(ProductCategoryLoading());
      try {
        await productCategoryRepository.addProductCategory(event.data);
        emit(ProductCategoryCreated());
      } catch (e) {
        emit(ProductCategoryError(e.toString()));
      }
    });

    on<DeleteProductCategory>((event, emit) async {
      emit(ProductCategoryLoading());
      try {
        await productCategoryRepository.deleteProductCategory(event.productCategoryId);
        emit(ProductCategoryDeleted());
      } catch (e) {
        emit(ProductCategoryError(e.toString()));
      }
    });

    on<UpdateProductCategory>((event, emit) async {
      emit(ProductCategoryLoading());
      try {
        await productCategoryRepository.updateProductCategory(
          event.productCategoryId,
          event.updatedData,
        );
        emit(ProductCategoryUpdated());
      } catch (e) {
        emit(ProductCategoryError(e.toString()));
      }
    });
  }
}