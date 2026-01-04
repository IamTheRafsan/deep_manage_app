import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Expense/ExpenseBloc.dart';
import '../../Bloc/Expense/ExpenseEvent.dart';
import '../../Bloc/Expense/ExpenseState.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryBloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryEventBloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryStateBloc.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/DropDownInputField.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Model/ExpenseCategory/ExpenseCategoryModel.dart';

class UpdateExpenseScreen extends StatefulWidget {
  final String expenseId;

  const UpdateExpenseScreen({super.key, required this.expenseId});

  @override
  State<UpdateExpenseScreen> createState() => _UpdateExpenseScreenState();
}

class _UpdateExpenseScreenState extends State<UpdateExpenseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  bool _initialDataLoaded = false;
  List<ExpenseCategoryModel> _categories = [];
  bool _loadingCategories = true;

  final List<String> _statusOptions = ['PENDING', 'PAID', 'CANCELLED'];
  String _selectedStatus = 'PENDING';

  String? _selectedCategoryId;
  String? _selectedCategoryName;

  late final List<DropdownMenuItem<String>> statusMenuItems = _statusOptions
      .map((String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  ))
      .toList();

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenseById(widget.expenseId));
    context.read<ExpenseCategoryBloc>().add(LoadExpenseCategory());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Update Expense",
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseLoadedSingle && !_initialDataLoaded) {
            final expense = state.expense;
            _nameController.text = expense.name;
            _amountController.text = expense.amount.toString();
            _descriptionController.text = expense.description;
            _selectedStatus = expense.status;
            _selectedCategoryId = expense.categoryId;
            _selectedCategoryName = expense.categoryName;

            _initialDataLoaded = true;
          }

          if (state is ExpenseUpdated) {
            SuccessSnackBar.show(context, message: "Expense Updated Successfully!");
            Navigator.pop(context);
          }

          if (state is ExpenseError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          if (state is ExpenseLoading && !_initialDataLoaded) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Loading expense data...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return BlocListener<ExpenseCategoryBloc, ExpenseCategoryState>(
            listener: (context, categoryState) {
              if (categoryState is ExpenseCategoryLoaded) {
                setState(() {
                  _categories = categoryState.expenseCategories;
                  _loadingCategories = false;
                });
              }
              if (categoryState is ExpenseCategoryError) {
                setState(() {
                  _loadingCategories = false;
                });
                WarningSnackBar.show(context, message: "Failed to load categories");
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Expense Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _nameController,
                    label: 'Expense Name *',
                  ),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _amountController,
                    label: 'Amount *',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  _buildCategoryDropdown(),
                  const SizedBox(height: 16),

                  DropDownInputField<String>(
                    value: _selectedStatus,
                    label: 'Status *',
                    items: statusMenuItems,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select status';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PrimaryButton(
                      onPressed: _isLoading ? null : _updateExpense,
                      text: _isLoading ? 'Updating...' : 'Update Expense',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    if (_loadingCategories) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_categories.isEmpty) {
      return const Text("No categories available");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: AppText.BodyText(),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          decoration: InputDecoration(
            labelText: 'Select Category',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategoryId = newValue;
              if (newValue != null) {
                final selected = _categories.firstWhere((c) => c.id == newValue);
                _selectedCategoryName = selected.name;
              }
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select category';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _updateExpense() async {
    if (_nameController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedCategoryId == null) {
      WarningSnackBar.show(context, message: "Please fill all required fields");
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      WarningSnackBar.show(context, message: "Please enter a valid amount");
      return;
    }

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final updatedData = {
      "name": _nameController.text.trim(),
      "amount": amount,
      "description": _descriptionController.text.trim(),
      "status": _selectedStatus,
      "category_id": _selectedCategoryId,
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    try {
      context.read<ExpenseBloc>().add(UpdateExpense(widget.expenseId, updatedData));
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}