// lib/Screens/ExpenseCategory/UpdateExpenseCategoryScreen.dart
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

class UpdateExpenseCategoryScreen extends StatefulWidget {
  final String expenseCategoryId;

  const UpdateExpenseCategoryScreen({super.key, required this.expenseCategoryId});

  @override
  State<UpdateExpenseCategoryScreen> createState() => _UpdateExpenseCategoryScreenState();
}

class _UpdateExpenseCategoryScreenState extends State<UpdateExpenseCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  bool _initialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    context.read<ExpenseCategoryBloc>().add(LoadExpenseCategoryById(widget.expenseCategoryId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Update Expense Category",
      body: BlocConsumer<ExpenseCategoryBloc, ExpenseCategoryState>(
        listener: (context, state) {
          if (state is ExpenseCategoryLoadedSingle && !_initialDataLoaded) {
            final category = state.expenseCategory;
            _nameController.text = category.name;
            _initialDataLoaded = true;
          }

          if (state is ExpenseCategoryUpdated) {
            SuccessSnackBar.show(context, message: "Expense Category Updated Successfully!");
            Navigator.pop(context);
          }

          if (state is ExpenseCategoryError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          if (state is ExpenseCategoryLoading && !_initialDataLoaded) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Loading category data...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

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
                    onPressed: _isLoading ? null : _updateExpenseCategory,
                    text: _isLoading ? 'Updating...' : 'Update Category',
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

  Future<void> _updateExpenseCategory() async {
    if (_nameController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please enter category name");
      return;
    }

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final updatedData = {
      "name": _nameController.text.trim(),
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    try {
      context.read<ExpenseCategoryBloc>().add(UpdateExpenseCategory(widget.expenseCategoryId, updatedData));
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