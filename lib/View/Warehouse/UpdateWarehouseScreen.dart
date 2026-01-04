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

class UpdateWarehouseScreen extends StatefulWidget {
  final String warehouseId;

  const UpdateWarehouseScreen({super.key, required this.warehouseId});

  @override
  State<UpdateWarehouseScreen> createState() => _UpdateWarehouseScreenState();
}

class _UpdateWarehouseScreenState extends State<UpdateWarehouseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  bool _isLoading = false;
  bool _initialDataLoaded = false;
  String _currentUserId = '';

  final List<String> _statusOptions = ['ACTIVE', 'INACTIVE'];
  String _selectedStatus = 'ACTIVE';

  final List<String> _countryOptions = [
    'Bangladesh',
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
    context.read<WarehouseBloc>().add(LoadWarehouseById(widget.warehouseId));
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
      title: "Update Warehouse",
      body: BlocConsumer<WarehouseBloc, WarehouseState>(
        listener: (context, state) {
          if (state is WarehouseLoadedSingle && !_initialDataLoaded) {
            final warehouse = state.warehouse;
            _nameController.text = warehouse.name;
            _emailController.text = warehouse.email;
            _mobileController.text = warehouse.mobile;
            _selectedCountry = warehouse.country;
            _cityController.text = warehouse.city;
            _areaController.text = warehouse.area;
            _selectedStatus = warehouse.status;

            _initialDataLoaded = true;
          }

          if (state is WarehouseUpdated) {
            SuccessSnackBar.show(context, message: "Warehouse Updated Successfully!");
            Navigator.pop(context);
          }

          if (state is WarehouseError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          if (state is WarehouseLoading && !_initialDataLoaded) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Loading warehouse data...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is WarehouseLoadedSingle && state.warehouse.deleted) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.block,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Warehouse is Deleted",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This warehouse has been deleted and cannot be updated.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Go Back"),
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
                    onPressed: _isLoading ? null : _updateWarehouse,
                    text: _isLoading ? 'Updating...' : 'Update Warehouse',
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

  Future<void> _updateWarehouse() async {
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

    if (_currentUserId.isEmpty) {
      WarningSnackBar.show(context, message: "User not authenticated");
      return;
    }

    setState(() => _isLoading = true);

    final mobileNumber = _mobileController.text.trim();
    final now = DateTime.now();
    final updatedData = {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "mobile": mobileNumber,
      "country": _selectedCountry,
      "city": _cityController.text.trim(),
      "area": _areaController.text.trim(),
      "status": _selectedStatus,
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "updated_by_id": _currentUserId,
    };

    try {
      context.read<WarehouseBloc>().add(UpdateWarehouse(widget.warehouseId, updatedData));
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
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }
}