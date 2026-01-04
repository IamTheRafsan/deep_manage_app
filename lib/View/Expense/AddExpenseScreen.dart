// lib/Screens/Expense/AddExpenseScreen.dart
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
import 'ViewExpenseCategory.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
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
    context.read<ExpenseCategoryBloc>().add(LoadExpenseCategory());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add New Expense",
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseCreated) {
            SuccessSnackBar.show(context, message: "Expense Created Successfully!");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewExpenseScreen(),
                ),
                    (route) => false,
              );
            });
          }

          if (state is ExpenseError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
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
                      onPressed: _isLoading ? null : _createExpense,
                      text: _isLoading ? 'Creating...' : 'Create Expense',
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

  Future<void> _createExpense() async {
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
    final expenseData = {
      "name": _nameController.text.trim(),
      "amount": amount,
      "description": _descriptionController.text.trim(),
      "status": _selectedStatus,
      "category_id": _selectedCategoryId,
      "created_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "created_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      // Add other optional fields if needed: warehouse_id, outlet_id, user_id, payment_type_id
    };

    try {
      context.read<ExpenseBloc>().add(CreateExpense(expenseData));
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