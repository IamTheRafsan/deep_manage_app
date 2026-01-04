// lib/Repository/ExpenseCategoryRepository.dart
import 'package:deep_manage_app/Model/ExpenseCategory/ExpenseCategoryModel.dart';

import '../ApiService/ExpenseCategoryApi/ExpenseCategoryApi.dart';

class ExpenseCategoryRepository {
  final ExpenseCategoryApi expenseCategoryApi;

  ExpenseCategoryRepository({required this.expenseCategoryApi});

  Future<void> addExpenseCategory(Map<String, dynamic> data) async {
    await expenseCategoryApi.addExpenseCategory(data);
  }

  Future<List<ExpenseCategoryModel>> getExpenseCategory() {
    return expenseCategoryApi.getExpenseCategory();
  }

  Future<ExpenseCategoryModel> getExpenseCategoryById(String id) {
    return expenseCategoryApi.getExpenseCategoryById(id);
  }

  Future<void> deleteExpenseCategory(String id) {
    return expenseCategoryApi.deleteExpenseCategory(id);
  }

  Future<void> updateExpenseCategory(String id, Map<String, dynamic> data) {
    return expenseCategoryApi.updateExpenseCategory(id, data);
  }
}