import 'package:deep_manage_app/Bloc/DepositCategory/DepositCategoryEvent.dart';
import 'package:deep_manage_app/Bloc/DepositCategory/DepositCategoryState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repository/DepositCategoryRespository.dart';

class DepositCategoryBloc extends Bloc<DepositCategoryEvent, DepositCategoryState> {
  final DepositCategoryRepository depositCategoryRepository;

  DepositCategoryBloc({required this.depositCategoryRepository}) : super(DepositCategoryInitial()) {
    on<LoadDepositCategory>((event, emit) async {
      emit(DepositCategoryLoading());
      try {
        final categories = await depositCategoryRepository.getDepositCategory();
        // Filter deleted categories if needed
        final filteredCategories = event.showDeleted
            ? categories
            : categories.where((c) => !c.deleted).toList();
        emit(DepositCategoryLoaded(filteredCategories));
      } catch (e) {
        emit(DepositCategoryError(e.toString()));
      }
    });

    on<LoadDepositCategoryById>((event, emit) async {
      emit(DepositCategoryLoading());
      try {
        final category = await depositCategoryRepository.getDepositCategoryById(event.depositCategoryId);
        emit(DepositCategoryLoadedSingle(category));
      } catch (e) {
        emit(DepositCategoryError(e.toString()));
      }
    });

    on<CreateDepositCategory>((event, emit) async {
      emit(DepositCategoryLoading());
      try {
        await depositCategoryRepository.addDepositCategory(event.data);
        emit(DepositCategoryCreated());
      } catch (e) {
        emit(DepositCategoryError(e.toString()));
      }
    });

    on<DeleteDepositCategory>((event, emit) async {
      emit(DepositCategoryLoading());
      try {
        await depositCategoryRepository.deleteDepositCategory(event.depositCategoryId);
        emit(DepositCategoryDeleted());
      } catch (e) {
        emit(DepositCategoryError(e.toString()));
      }
    });

    on<UpdateDepositCategory>((event, emit) async {
      emit(DepositCategoryLoading());
      try {
        await depositCategoryRepository.updateDepositCategory(
          event.depositCategoryId,
          event.updatedData,
        );
        emit(DepositCategoryUpdated());
      } catch (e) {
        emit(DepositCategoryError(e.toString()));
      }
    });
  }
}