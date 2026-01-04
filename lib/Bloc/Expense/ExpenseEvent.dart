abstract class ExpenseEvent {}

class LoadExpense extends ExpenseEvent {
  final bool showDeleted;
  LoadExpense({this.showDeleted = false});

}

class LoadExpenseById extends ExpenseEvent {
  final String expenseId;
  LoadExpenseById(this.expenseId);
}

class CreateExpense extends ExpenseEvent {
  final Map<String, dynamic> data;
  CreateExpense(this.data);
}

class DeleteExpense extends ExpenseEvent {
  final String expenseId;
  DeleteExpense(this.expenseId);
}

class UpdateExpense extends ExpenseEvent {
  final String expenseId;
  final Map<String, dynamic> updatedData;
  UpdateExpense(this.expenseId, this.updatedData);
}