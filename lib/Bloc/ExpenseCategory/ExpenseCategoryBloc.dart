// lib/Bloc/ExpenseCategory/ExpenseCategoryBloc.dart
import 'package:deep_manage_app/Repository/ExpenseCategoryRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ExpenseCategoryEventBloc.dart';
import 'ExpenseCategoryStateBloc.dart';

class ExpenseCategoryBloc extends Bloc<ExpenseCategoryEvent, ExpenseCategoryState> {
  final ExpenseCategoryRepository expenseCategoryRepository;

  ExpenseCategoryBloc({required this.expenseCategoryRepository}) : super(ExpenseCategoryInitial()) {
    on<LoadExpenseCategory>((event, emit) async {
      emit(ExpenseCategoryLoading());
      try {
        final categories = await expenseCategoryRepository.getExpenseCategory();
        final filteredCategories = event.showDeleted
            ? categories
            : categories.where((c) => !c.deleted).toList();
        emit(ExpenseCategoryLoaded(filteredCategories));
      } catch (e) {
        emit(ExpenseCategoryError(e.toString()));
      }
    });

    on<LoadExpenseCategoryById>((event, emit) async {
      emit(ExpenseCategoryLoading());
      try {
        final category = await expenseCategoryRepository.getExpenseCategoryById(event.expenseCategoryId);
        emit(ExpenseCategoryLoadedSingle(category));
      } catch (e) {
        emit(ExpenseCategoryError(e.toString()));
      }
    });

    on<CreateExpenseCategory>((event, emit) async {
      emit(ExpenseCategoryLoading());
      try {
        await expenseCategoryRepository.addExpenseCategory(event.data);
        emit(ExpenseCategoryCreated());
      } catch (e) {
        emit(ExpenseCategoryError(e.toString()));
      }
    });

    on<DeleteExpenseCategory>((event, emit) async {
      emit(ExpenseCategoryLoading());
      try {
        await expenseCategoryRepository.deleteExpenseCategory(event.expenseCategoryId);
        emit(ExpenseCategoryDeleted());
      } catch (e) {
        emit(ExpenseCategoryError(e.toString()));
      }
    });

    on<UpdateExpenseCategory>((event, emit) async {
      emit(ExpenseCategoryLoading());
      try {
        await expenseCategoryRepository.updateExpenseCategory(
          event.expenseCategoryId,
          event.updatedData,
        );
        emit(ExpenseCategoryUpdated());
      } catch (e) {
        emit(ExpenseCategoryError(e.toString()));
      }
    });
  }
}