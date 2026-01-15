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

class UpdateDepositScreen extends StatefulWidget {
  final String depositId;

  const UpdateDepositScreen({super.key, required this.depositId});

  @override
  State<UpdateDepositScreen> createState() => _UpdateDepositScreenState();
}

class _UpdateDepositScreenState extends State<UpdateDepositScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  bool _initialDataLoaded = false;
  List<DepositCategoryModel> _categories = [];
  bool _loadingCategories = true;
  bool _categoriesError = false;

  final List<String> _statusOptions = ['PAID', 'UNPAID', 'DUE'];
  String _selectedStatus = 'PAID';

  String? _selectedCategoryId;
  String? _selectedCategoryName;

  // Store the original category ID from the deposit
  String? _originalCategoryId;

  late final List<DropdownMenuItem<String>> statusMenuItems = _statusOptions
      .map((String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  ))
      .toList();

  @override
  void initState() {
    super.initState();
    print('UpdateDepositScreen initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Loading deposit and categories...');
      context.read<DepositBloc>().add(LoadDepositById(widget.depositId));
      context.read<DepositCategoryBloc>().add(LoadDepositCategory());
    });
  }

  @override
  Widget build(BuildContext context) {
    print('UpdateDepositScreen build called');
    print('_loadingCategories: $_loadingCategories');
    print('_categories length: ${_categories.length}');
    print('_categoriesError: $_categoriesError');

    return GlobalScaffold(
      title: "Update Deposit",
      body: MultiBlocListener(
        listeners: [
          BlocListener<DepositBloc, DepositState>(
            listener: (context, state) {
              print('DepositBloc state changed: ${state.runtimeType}');

              if (state is DepositLoadedSingle && !_initialDataLoaded) {
                print('Deposit loaded: ${state.deposit.name}');
                final deposit = state.deposit;
                _nameController.text = deposit.name;
                _amountController.text = deposit.amount.toString();
                _descriptionController.text = deposit.description;
                _selectedStatus = deposit.status;

                // Store the original category ID
                _originalCategoryId = deposit.categoryId?.toString();
                print('Original category ID: $_originalCategoryId');

                // Only set the selected category if categories are already loaded
                if (_categories.isNotEmpty) {
                  _updateSelectedCategoryFromOriginalId();
                } else {
                  // Temporarily store the original ID
                  _selectedCategoryId = _originalCategoryId;
                  print('Temporarily set category ID to: $_selectedCategoryId');
                }

                _initialDataLoaded = true;
                setState(() {});
              }

              if (state is DepositUpdated) {
                SuccessSnackBar.show(context, message: "Deposit Updated Successfully!");
                Navigator.pop(context);
              }

              if (state is DepositError) {
                WarningSnackBar.show(context, message: state.message);
                setState(() => _isLoading = false);
              }
            },
          ),
          BlocListener<DepositCategoryBloc, DepositCategoryState>(
            listener: (context, categoryState) {
              print('DepositCategoryBloc state changed: ${categoryState.runtimeType}');

              if (categoryState is DepositCategoryLoaded) {
                print('Categories loaded successfully');
                print('Number of categories: ${categoryState.depositCategories.length}');

                setState(() {
                  _categories = categoryState.depositCategories;
                  _loadingCategories = false;
                  _categoriesError = false;
                });

                print('Categories after setState: ${_categories.length}');
                print('Available category IDs: ${_categories.map((c) => c.id.toString()).toList()}');

                // Now that categories are loaded, update the selected category
                if (_originalCategoryId != null) {
                  _updateSelectedCategoryFromOriginalId();
                } else if (_categories.isNotEmpty && _selectedCategoryId == null) {
                  // Set default if no category was selected
                  _selectedCategoryId = _categories.first.id.toString();
                  _selectedCategoryName = _categories.first.name;
                  print('Set default category to: $_selectedCategoryId');
                }

                print('Selected category ID after load: $_selectedCategoryId');
              }

              if (categoryState is DepositCategoryLoading) {
                print('Categories loading...');
                setState(() {
                  _loadingCategories = true;
                  _categoriesError = false;
                });
              }

              if (categoryState is DepositCategoryError) {
                print('Categories error: ${categoryState.message}');
                setState(() {
                  _loadingCategories = false;
                  _categoriesError = true;
                });
                WarningSnackBar.show(context, message: "Failed to load categories: ${categoryState.message}");
              }
            },
          ),
        ],
        child: BlocBuilder<DepositBloc, DepositState>(
          builder: (context, state) {
            if (state is DepositLoading && !_initialDataLoaded) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "Loading deposit data...",
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
                      onPressed: _isLoading ? null : _updateDeposit,
                      text: _isLoading ? 'Updating...' : 'Update Deposit',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Debug button to manually trigger category load
                  if (_loadingCategories || _categoriesError)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Manually reloading categories...');
                          setState(() {
                            _loadingCategories = true;
                            _categoriesError = false;
                          });
                          context.read<DepositCategoryBloc>().add(LoadDepositCategory());
                        },
                        child: const Text('Retry Loading Categories'),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to update selected category from original ID
  void _updateSelectedCategoryFromOriginalId() {
    if (_originalCategoryId != null && _categories.isNotEmpty) {
      print('Looking for category with ID: $_originalCategoryId');
      print('Available IDs: ${_categories.map((c) => c.id.toString()).toList()}');

      try {
        final matchingCategory = _categories.firstWhere(
              (category) => category.id.toString() == _originalCategoryId,
        );

        _selectedCategoryId = matchingCategory.id.toString();
        _selectedCategoryName = matchingCategory.name;

        print('Found matching category: $_selectedCategoryId ($_selectedCategoryName)');
      } catch (e) {
        print('Category not found, using first category as fallback');
        _selectedCategoryId = _categories.first.id.toString();
        _selectedCategoryName = _categories.first.name;
      }

      setState(() {});
    }
  }

  Widget _buildCategoryDropdown() {
    print('Building category dropdown');
    print('_loadingCategories: $_loadingCategories');
    print('_categoriesError: $_categoriesError');
    print('_categories length: ${_categories.length}');
    print('_selectedCategoryId: $_selectedCategoryId');

    if (_loadingCategories) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category *',
            style: AppText.BodyText(),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 12),
                Text("Loading categories..."),
              ],
            ),
          ),
        ],
      );
    }

    if (_categoriesError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category *',
            style: AppText.BodyText(),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              children: [
                Text(
                  "Failed to load categories. Please check your connection and try again.",
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 8),
                Text(
                  "You can continue without selecting a category, but the deposit may not save properly.",
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_categories.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category *',
            style: AppText.BodyText(),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "No categories available. Please add categories first or contact support.",
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: AppText.BodyText(),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategoryId,
                isExpanded: true,
                hint: const Text('Select Category'),
                items: _categories.map((category) {
                  final categoryIdStr = category.id.toString();
                  print('Dropdown item: $categoryIdStr - ${category.name}');
                  return DropdownMenuItem<String>(
                    value: categoryIdStr,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  print('Category selected: $newValue');
                  setState(() {
                    _selectedCategoryId = newValue;
                    if (newValue != null) {
                      try {
                        final selectedCategory = _categories.firstWhere(
                              (category) => category.id.toString() == newValue,
                        );
                        _selectedCategoryName = selectedCategory.name;
                        print('Category name set to: $_selectedCategoryName');
                      } catch (e) {
                        print('Error finding category: $e');
                        // If not found, select the first category
                        if (_categories.isNotEmpty) {
                          _selectedCategoryId = _categories.first.id.toString();
                          _selectedCategoryName = _categories.first.name;
                        }
                      }
                    }
                  });
                },
              ),
            ),
          ),
        ),
        if (_selectedCategoryId != null && _selectedCategoryId!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            // child: Text(
            //   'Selected: ${_selectedCategoryName ?? "Unknown"}',
            //   style: const TextStyle(
            //     fontSize: 12,
            //     color: Colors.green,
            //     fontStyle: FontStyle.italic,
            //   ),
            // ),
          ),
      ],
    );
  }

  Future<void> _updateDeposit() async {
    print('=== UPDATE DEPOSIT DEBUG ===');
    print('Name: ${_nameController.text}');
    print('Amount: ${_amountController.text}');
    print('Category ID: $_selectedCategoryId');
    print('Category Name: $_selectedCategoryName');
    print('Original Category ID: $_originalCategoryId');
    print('Status: $_selectedStatus');
    print('Description: ${_descriptionController.text}');
    print('Categories loaded: ${_categories.isNotEmpty}');
    print('===========================');

    // Validation
    if (_nameController.text.isEmpty ||
        _amountController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please fill name and amount fields");
      return;
    }

    // Warn but don't block if category is not selected
    if (_selectedCategoryId == null || _selectedCategoryId!.isEmpty) {
      WarningSnackBar.show(context, message: "No category selected. Using default category.");
      if (_categories.isNotEmpty) {
        _selectedCategoryId = _categories.first.id.toString();
        _selectedCategoryName = _categories.first.name;
      }
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
      "category": {"id": int.tryParse(_selectedCategoryId!) ?? 1,},
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    print('Sending update data: $updatedData');

    try {
      context.read<DepositBloc>().add(UpdateDeposit(widget.depositId, updatedData));
    } catch (e) {
      print('Error updating deposit: $e');
      WarningSnackBar.show(context, message: "Error: ${e.toString()}");
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