import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Deposit/DepositBloc.dart';
import '../../Bloc/Deposit/DepositEvent.dart';
import '../../Bloc/Deposit/DepositState.dart';
import '../../Bloc/DepositCategory/DepositCategoryBloc.dart';
import '../../Bloc/DepositCategory/DepositCategoryEvent.dart';
import '../../Bloc/DepositCategory/DepositCategoryState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/DropDownInputField.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Model/DepositCategory/DepositCategoryModel.dart';
import 'ViewDepositScreen.dart';

class AddDepositScreen extends StatefulWidget {
  const AddDepositScreen({super.key});

  @override
  State<AddDepositScreen> createState() => _AddDepositScreenState();
}

class _AddDepositScreenState extends State<AddDepositScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  List<DepositCategoryModel> _categories = [];
  bool _loadingCategories = true;

  final List<String> _statusOptions = ['PAID', 'UNPAID', 'DUE'];
  String _selectedStatus = 'PAID';

  // FIXED: Use String? instead of int? to match DropdownMenuItem<String>
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepositCategoryBloc>().add(LoadDepositCategory());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add New Deposit",
      body: BlocConsumer<DepositBloc, DepositState>(
        listener: (context, state) {
          if (state is DepositCreated) {
            SuccessSnackBar.show(context, message: "Deposit Created Successfully!");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewDepositScreen(),
                ),
                    (route) => false,
              );
            });
          }

          if (state is DepositError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          return BlocListener<DepositCategoryBloc, DepositCategoryState>(
            listener: (context, categoryState) {
              if (categoryState is DepositCategoryLoaded) {
                setState(() {
                  _categories = categoryState.depositCategories;
                  _loadingCategories = false;

                  // Set default category if available
                  if (_categories.isNotEmpty && _selectedCategoryId == null) {
                    _selectedCategoryId = _categories.first.id.toString();
                    _selectedCategoryName = _categories.first.name;
                  }
                });
              }
              if (categoryState is DepositCategoryError) {
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
                    "Deposit Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _nameController,
                    label: 'Deposit Name *',
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

                  // FIXED: Explicitly specify type <String> for DropDownInputField
                  DropDownInputField<String>(
                    value: _selectedStatus,
                    label: 'Status *',
                    items: statusMenuItems,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      }
                    },
                    validator: (String? value) {
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
                      onPressed: _isLoading ? null : _createDeposit,
                      text: _isLoading ? 'Creating...' : 'Create Deposit',
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
              value: category.id.toString(), // Convert to string
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategoryId = newValue;
              if (newValue != null) {
                final selected = _categories.firstWhere(
                      (c) => c.id.toString() == newValue,
                  orElse: () => _categories.first,
                );
                _selectedCategoryName = selected.name;
              }
            });
          },
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please select category';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _createDeposit() async {
    // Debug logging
    print('DEBUG: Category ID: $_selectedCategoryId');
    print('DEBUG: Category Name: $_selectedCategoryName');
    print('DEBUG: Categories loaded: ${_categories.length}');

    if (_nameController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedCategoryId == null ||
        _selectedCategoryId!.isEmpty) {
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
    final depositData = {
      "name": _nameController.text.trim(),
      "amount": amount,
      "description": _descriptionController.text.trim(),
      "status": _selectedStatus,
      "category": _selectedCategoryId, // This is now a string
      "created_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "created_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    print('DEBUG: Deposit data to send: $depositData');

    try {
      context.read<DepositBloc>().add(CreateDeposit(depositData));
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