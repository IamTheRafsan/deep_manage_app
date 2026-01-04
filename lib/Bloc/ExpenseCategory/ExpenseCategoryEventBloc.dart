// lib/Bloc/ExpenseCategory/ExpenseCategoryEvent.dart
abstract class ExpenseCategoryEvent {}

class LoadExpenseCategory extends ExpenseCategoryEvent {
  final bool showDeleted;
  LoadExpenseCategory({this.showDeleted = false});
}

class LoadExpenseCategoryById extends ExpenseCategoryEvent {
  final String expenseCategoryId;
  LoadExpenseCategoryById(this.expenseCategoryId);
}

class CreateExpenseCategory extends ExpenseCategoryEvent {
  final Map<String, dynamic> data;
  CreateExpenseCategory(this.data);
}

class DeleteExpenseCategory extends ExpenseCategoryEvent {
  final String expenseCategoryId;
  DeleteExpenseCategory(this.expenseCategoryId);
}

class UpdateExpenseCategory extends ExpenseCategoryEvent {
  final String expenseCategoryId;
  final Map<String, dynamic> updatedData;
  UpdateExpenseCategory(this.expenseCategoryId, this.updatedData);
}