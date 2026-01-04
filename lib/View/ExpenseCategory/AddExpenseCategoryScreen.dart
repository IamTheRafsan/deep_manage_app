// lib/Screens/ExpenseCategory/AddExpenseCategoryScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryBloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryEventBloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryStateBloc.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import 'ViewExpenseCategory.dart';

class AddExpenseCategoryScreen extends StatefulWidget {
  const AddExpenseCategoryScreen({super.key});

  @override
  State<AddExpenseCategoryScreen> createState() => _AddExpenseCategoryScreenState();
}

class _AddExpenseCategoryScreenState extends State<AddExpenseCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add Expense Category",
      body: BlocConsumer<ExpenseCategoryBloc, ExpenseCategoryState>(
        listener: (context, state) {
          if (state is ExpenseCategoryCreated) {
            SuccessSnackBar.show(context, message: "Expense Category Created Successfully!");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewExpenseCategoryScreen(),
                ),
                    (route) => false,
              );
            });
          }

          if (state is ExpenseCategoryError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Expense Category Information",
                  style: AppText.SubHeadingText(),
                ),
                const SizedBox(height: 16),

                TextInputField(
                  controller: _nameController,
                  label: 'Category Name *',
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PrimaryButton(
                    onPressed: _isLoading ? null : _createExpenseCategory,
                    text: _isLoading ? 'Creating...' : 'Create Category',
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _createExpenseCategory() async {
    if (_nameController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please enter category name");
      return;
    }

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final categoryData = {
      "name": _nameController.text.trim(),
      "created_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "created_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    try {
      context.read<ExpenseCategoryBloc>().add(CreateExpenseCategory(categoryData));
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}