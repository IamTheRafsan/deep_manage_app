import 'package:deep_manage_app/Model/Expense/ExpenseModel.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseModel> expenses;
  ExpenseLoaded(this.expenses);
}

class ExpenseLoadedSingle extends ExpenseState {
  final ExpenseModel expense;
  ExpenseLoadedSingle(this.expense);
}

class ExpenseCreated extends ExpenseState {}

class ExpenseDeleted extends ExpenseState {}

class ExpenseUpdated extends ExpenseState {}

class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError(this.message);
}