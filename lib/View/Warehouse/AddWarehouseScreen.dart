import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/Warehouse/WarehouseBloc.dart';
import '../../Bloc/Warehouse/WarehouseEvent.dart';
import '../../Bloc/Warehouse/WarehouseState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/DropDownInputField.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Styles/Color.dart';
import 'ViewWarehouseScreen.dart';

class AddWarehouseScreen extends StatefulWidget {
  const AddWarehouseScreen({super.key});

  @override
  State<AddWarehouseScreen> createState() => _AddWarehouseScreenState();
}

class _AddWarehouseScreenState extends State<AddWarehouseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  bool _isLoading = false;
  String _currentUserId = '';

  final List<String> _statusOptions = ['ACTIVE', 'INACTIVE'];
  String _selectedStatus = 'ACTIVE';

  final List<String> _countryOptions = [
    'Bangladesh'
  ];
  String _selectedCountry = 'Bangladesh';

  late final List<DropdownMenuItem<String>> statusMenuItems = _statusOptions
      .map((String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  ))
      .toList();

  late final List<DropdownMenuItem<String>> countryItems = _countryOptions
      .map((String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  ))
      .toList();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getString('userId') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add New Warehouse",
      body: BlocConsumer<WarehouseBloc, WarehouseState>(
        listener: (context, state) {
          if (state is WarehouseCreated) {
            SuccessSnackBar.show(context, message: "Warehouse Created Successfully!");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewWarehouseScreen(),
                ),
                    (route) => false,
              );
            });
          }

          if (state is WarehouseError) {
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
                  "Warehouse Information",
                  style: AppText.SubHeadingText(),
                ),
                const SizedBox(height: 16),

                TextInputField(
                  controller: _nameController,
                  label: 'Warehouse Name *',
                ),
                const SizedBox(height: 16),

                TextInputField(
                  controller: _emailController,
                  label: 'Email *',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                TextInputField(
                  controller: _mobileController,
                  label: 'Mobile Number *',
                  keyboardType: TextInputType.phone,
                ),
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
                const SizedBox(height: 24),

                Text(
                  "Location Information",
                  style: AppText.SubHeadingText(),
                ),
                const SizedBox(height: 16),

                DropDownInputField(
                  value: _selectedCountry,
                  label: "Country *",
                  items: countryItems,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCountry = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select country';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextInputField(
                        controller: _cityController,
                        label: 'City *',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextInputField(
                        controller: _areaController,
                        label: 'Area *',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PrimaryButton(
                    onPressed: _isLoading ? null : _createWarehouse,
                    text: _isLoading ? 'Creating...' : 'Create Warehouse',
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

  Future<void> _createWarehouse() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _areaController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please fill all required fields");
      return;
    }

    if (!_emailController.text.contains('@')) {
      WarningSnackBar.show(context, message: "Please enter a valid email");
      return;
    }

    final mobileNumber = _mobileController.text.trim();
    if (mobileNumber.length < 10) {
      WarningSnackBar.show(context, message: "Please enter a valid mobile number");
      return;
    }

    if (_currentUserId.isEmpty) {
      WarningSnackBar.show(context, message: "User not authenticated");
      return;
    }

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final warehouseData = {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "mobile": mobileNumber,
      "country": _selectedCountry,
      "city": _cityController.text.trim(),
      "area": _areaController.text.trim(),
      "status": _selectedStatus,
      "created_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "created_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "created_by_id": _currentUserId,
    };

    try {
      context.read<WarehouseBloc>().add(CreateWarehouse(warehouseData));
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }
}