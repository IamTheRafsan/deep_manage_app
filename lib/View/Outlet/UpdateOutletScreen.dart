// lib/Screens/Outlet/UpdateOutletScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/Outlet/OutletBloc.dart';
import '../../Bloc/Outlet/OutletEvent.dart';
import '../../Bloc/Outlet/OutletState.dart';
import '../../Bloc/Warehouse/WarehouseBloc.dart';
import '../../Bloc/Warehouse/WarehouseEvent.dart';
import '../../Bloc/Warehouse/WarehouseState.dart';
import '../../Model/Warehouse/WarehouseModel.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/DropDownInputField.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Styles/Color.dart';

class UpdateOutletScreen extends StatefulWidget {
  final String outletId;

  const UpdateOutletScreen({super.key, required this.outletId});

  @override
  State<UpdateOutletScreen> createState() => _UpdateOutletScreenState();
}

class _UpdateOutletScreenState extends State<UpdateOutletScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  bool _isLoading = false;
  bool _initialDataLoaded = false;
  String _currentUserId = '';
  String? _selectedWarehouseId;
  String? _selectedWarehouseName;
  List<WarehouseModel> _warehouses = [];
  bool _loadingWarehouses = true;

  final List<String> _statusOptions = ['ACTIVE', 'INACTIVE'];
  String _selectedStatus = 'ACTIVE';

  final List<String> _countryOptions = ['Bangladesh'];
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
    context.read<OutletBloc>().add(LoadOutletById(widget.outletId));
    context.read<WarehouseBloc>().add(LoadWarehouse());
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
      title: "Update Outlet",
      body: BlocConsumer<OutletBloc, OutletState>(
        listener: (context, state) {
          if (state is OutletLoadedSingle && !_initialDataLoaded) {
            final outlet = state.outlet;
            _nameController.text = outlet.name;
            _emailController.text = outlet.email;
            _mobileController.text = outlet.mobile;
            _selectedCountry = outlet.country;
            _cityController.text = outlet.city;
            _areaController.text = outlet.area;
            _selectedStatus = outlet.status;
            _selectedWarehouseId = outlet.warehouseId;

            _initialDataLoaded = true;
          }

          if (state is OutletUpdated) {
            SuccessSnackBar.show(context, message: "Outlet Updated Successfully!");
            Navigator.pop(context);
          }

          if (state is OutletError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          return BlocListener<WarehouseBloc, WarehouseState>(
            listener: (context, warehouseState) {
              if (warehouseState is WarehouseLoaded) {
                setState(() {
                  _warehouses = warehouseState.warehouses.where((w) => !w.deleted).toList();
                  _loadingWarehouses = false;
                });
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Outlet Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _nameController,
                    label: 'Outlet Name',
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

                  // Warehouse Selection
                  Text(
                    "Warehouse Assignment",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  _buildWarehouseSelection(),

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
                      onPressed: _isLoading ? null : _updateOutlet,
                      text: _isLoading ? 'Updating...' : 'Update Outlet',
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

  Widget _buildWarehouseSelection() {
    if (_loadingWarehouses) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_warehouses.isEmpty) {
      return const Text(
        "No warehouses available.",
        style: TextStyle(color: Colors.red),
      );
    }

    return DropDownInputField<String>(
      value: _selectedWarehouseId,
      label: 'Select Warehouse *',
      items: _warehouses.map((warehouse) {
        return DropdownMenuItem<String>(
          value: warehouse.id,
          child: Text(warehouse.name),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedWarehouseId = newValue;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a warehouse';
        }
        return null;
      },
    );
  }

  Future<void> _updateOutlet() async {
    if (_emailController.text.isEmpty ||
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

    if (_selectedWarehouseId == null) {
      WarningSnackBar.show(context, message: "Please select a warehouse");
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
      "warehouseId": _selectedWarehouseId,
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "updated_by_id": _currentUserId,
    };

    try {
      context.read<OutletBloc>().add(UpdateOutlet(widget.outletId, updatedData));
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