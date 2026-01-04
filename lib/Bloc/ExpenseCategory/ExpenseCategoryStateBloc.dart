import 'package:deep_manage_app/Model/ExpenseCategory/ExpenseCategoryModel.dart';

abstract class ExpenseCategoryState {}

class ExpenseCategoryInitial extends ExpenseCategoryState {}

class ExpenseCategoryLoading extends ExpenseCategoryState {}

class ExpenseCategoryLoaded extends ExpenseCategoryState {
  final List<ExpenseCategoryModel> expenseCategories;
  ExpenseCategoryLoaded(this.expenseCategories);
}

class ExpenseCategoryLoadedSingle extends ExpenseCategoryState {
  final ExpenseCategoryModel expenseCategory;
  ExpenseCategoryLoadedSingle(this.expenseCategory);
}

class ExpenseCategoryCreated extends ExpenseCategoryState {}

class ExpenseCategoryDeleted extends ExpenseCategoryState {}

class ExpenseCategoryUpdated extends ExpenseCategoryState {}

class ExpenseCategoryError extends ExpenseCategoryState {
  final String message;
  ExpenseCategoryError(this.message);
}