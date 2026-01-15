import 'package:deep_manage_app/Bloc/Brand/BrandEvent.dart';
import 'package:deep_manage_app/Bloc/Brand/BrandState.dart';
import 'package:deep_manage_app/Repository/BrandRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository brandRepository;

  BrandBloc({required this.brandRepository}) : super(BrandInitial()) {
    on<LoadBrand>((event, emit) async {
      emit(BrandLoading());
      try {
        final brands = await brandRepository.getBrand();
        emit(BrandLoaded(brands));
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });

    on<LoadBrandById>((event, emit) async {
      emit(BrandLoading());
      try {
        final brand = await brandRepository.getBrandById(event.brandId);
        emit(BrandLoadedSingle(brand));
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });

    on<CreateBrand>((event, emit) async {
      emit(BrandLoading());
      try {
        await brandRepository.addBrand(event.data);
        emit(BrandCreated());
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });

    on<DeleteBrand>((event, emit) async {
      emit(BrandLoading());
      try {
        await brandRepository.deleteBrand(event.brandId);
        emit(BrandDeleted());
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });

    on<UpdateBrand>((event, emit) async {
      emit(BrandLoading());
      try {
        await brandRepository.updateBrand(
          event.brandId,
          event.updatedData,
        );
        emit(BrandUpdated());
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });
  }
}