// lib/Bloc/Expense/ExpenseBloc.dart
import 'package:deep_manage_app/Bloc/Expense/ExpenseEvent.dart';
import 'package:deep_manage_app/Bloc/Expense/ExpenseState.dart';
import 'package:deep_manage_app/Repository/ExpenseRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepository;

  ExpenseBloc({required this.expenseRepository}) : super(ExpenseInitial()) {
    on<LoadExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        final expenses = await expenseRepository.getExpense();
        final filteredExpense = event.showDeleted
        ? expenses
        : expenses.where((c)=> !c.deleted).toList();
        emit(ExpenseLoaded(filteredExpense));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<LoadExpenseById>((event, emit) async {
      emit(ExpenseLoading());
      try {
        final expense = await expenseRepository.getExpenseById(event.expenseId);
        emit(ExpenseLoadedSingle(expense));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<CreateExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await expenseRepository.addExpense(event.data);
        emit(ExpenseCreated());
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<DeleteExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await expenseRepository.deleteExpense(event.expenseId);
        emit(ExpenseDeleted());
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<UpdateExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await expenseRepository.updateExpense(
          event.expenseId,
          event.updatedData,
        );
        emit(ExpenseUpdated());
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });
  }
}