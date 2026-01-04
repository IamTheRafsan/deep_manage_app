import 'package:deep_manage_app/Model/Expense/ExpenseModel.dart';
import '../ApiService/ExpenseApi/ExpenseApi.dart';

class ExpenseRepository {
  final ExpenseApi expenseApi;

  ExpenseRepository({required this.expenseApi});

  Future<void> addExpense(Map<String, dynamic> data) async {
    await expenseApi.addExpense(data);
  }

  Future<List<ExpenseModel>> getExpense() {
    return expenseApi.getExpense();
  }

  Future<ExpenseModel> getExpenseById(String id) {
    return expenseApi.getExpenseById(id);
  }

  Future<void> deleteExpense(String id) {
    return expenseApi.deleteExpense(id);
  }

  Future<void> updateExpense(String id, Map<String, dynamic> data) {
    return expenseApi.updateExpense(id, data);
  }
}