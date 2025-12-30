import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/User/UserBlock.dart';
import '../../Bloc/User/UserEvent.dart';
import '../../Bloc/User/UserState.dart';
import '../../Bloc/Role/RoleBloc.dart';
import '../../Bloc/Role/RoleEvent.dart';
import '../../Bloc/Role/RoleState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/DropDownInputField.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Model/RoleModel/RoleModel.dart';
import '../../Styles/AppText.dart';
import 'ViewUserScreen.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final List<String> _selectedRoleIds = [];
  final List<String> _selectedRoleNames = [];
  bool _isLoading = false;

  List<RoleModel> _availableRoles = [];
  bool _loadingRoles = true;
  Map<String, String> _roleNameToIdMap = {};

  final List<String> _genderOptions = ['MALE', 'FEMALE'];
  String _selectedGender = 'MALE';
  late final List<DropdownMenuItem<String>> genderMenuItems = _genderOptions
      .map((String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  ))
      .toList();

  final List<String> _countryOptions = [
    'Bangladesh', 'USA', 'UK', 'Canada', 'Australia', 'India', 'Pakistan'
  ];
  String _selectedCountry = 'Bangladesh';

  late final List<DropdownMenuItem<String>> countryItems = _countryOptions
      .map((String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  ))
      .toList();

  @override
  void initState() {
    super.initState();
    context.read<RoleBloc>().add(LoadRoles());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add New User",
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserCreated) {
            SuccessSnackBar.show(context, message: "User Created Successfully!");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewUserScreen(), // Replace with your actual ViewUserScreen
                ),
                    (route) => false,
              );
            });
          }

          if (state is UserError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          return BlocListener<RoleBloc, RoleState>(
            listener: (context, roleState) {
              if (roleState is RoleLoaded) {
                setState(() {
                  _availableRoles = roleState.roles;
                  _loadingRoles = false;

                  _roleNameToIdMap = {};
                  for (var role in roleState.roles) {
                    _roleNameToIdMap[role.name] = role.role_id;
                  }
                });
              }
              if (roleState is RoleError) {
                setState(() {
                  _loadingRoles = false;
                });
                WarningSnackBar.show(context, message: "Failed to load roles");
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextInputField(
                          controller: _firstNameController,
                          label: 'First Name *',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextInputField(
                          controller: _lastNameController,
                          label: 'Last Name *',
                        ),
                      ),
                    ],
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

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender *',
                              style: AppText.BodyText(),
                            ),
                            const SizedBox(height: 8),
                            DropDownInputField<String>(
                              value: _selectedGender,
                              label: 'Gender *',
                              items: genderMenuItems,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedGender = newValue!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select gender';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _passwordController,
                    label: 'Password *',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password *',
                    obscureText: true,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Address Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropDownInputField(
                        value: _selectedCountry,
                        label: "Country *",
                        items: countryItems,
                        onChanged: (String? newValue){
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
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _cityController,
                    label: 'City *',
                  ),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _addressController,
                    label: 'Address *',
                    maxLines: 2,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Role Assignment",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  _buildRoleSelection(),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PrimaryButton(
                      onPressed: _isLoading ? null : _createUser,
                      text: _isLoading ? 'Creating...' : 'Create User',
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

  Widget _buildRoleSelection() {
    if (_loadingRoles) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_availableRoles.isEmpty) {
      return const Text(
        "No roles available",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedRoleNames.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selected Roles:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedRoleNames.map((roleName) {
                  return Chip(
                    label: Text(roleName),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        final index = _selectedRoleNames.indexOf(roleName);
                        _selectedRoleNames.removeAt(index);
                        _selectedRoleIds.removeAt(index);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),

        DropdownButtonFormField<String>(
          value: null,
          decoration: InputDecoration(
            labelText: "Select Role *",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: _availableRoles.map((role) {
            return DropdownMenuItem<String>(
              value: role.role_id,
              child: Text(role.name),
            );
          }).toList(),
          onChanged: (String? selectedRoleId) {
            if (selectedRoleId != null) {
              final selectedRole = _availableRoles.firstWhere(
                    (role) => role.role_id == selectedRoleId,
              );

              if (!_selectedRoleIds.contains(selectedRoleId)) {
                setState(() {
                  _selectedRoleIds.add(selectedRoleId);
                  _selectedRoleNames.add(selectedRole.name);
                });
              }
            }
          },
          validator: (value) {
            if (_selectedRoleIds.isEmpty) {
              return 'Please select at least one role';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          "Tip: Select roles from dropdown to assign to user",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Future<void> _createUser() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _addressController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please fill all required fields");
      return;
    }

    if (!_emailController.text.contains('@')) {
      WarningSnackBar.show(context, message: "Please enter a valid email");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      WarningSnackBar.show(context, message: "Passwords do not match");
      return;
    }

    if (_selectedRoleIds.isEmpty) {
      WarningSnackBar.show(context, message: "Please select at least one role");
      return;
    }

    setState(() => _isLoading = true);

    final mobileNumber = int.tryParse(_mobileController.text.trim());
    if (mobileNumber == null) {
      WarningSnackBar.show(context, message: "Please enter a valid mobile number");
      setState(() => _isLoading = false);
      return;
    }

    final now = DateTime.now();
    final userData = {
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "email": _emailController.text.trim(),
      "gender": _selectedGender,
      "mobile": mobileNumber,
      "country": _selectedCountry,
      "city": _cityController.text.trim(),
      "address": _addressController.text.trim(),
      "role_id": _selectedRoleIds,
      "password": _passwordController.text,
      "created_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "created_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "warehouse": [],
      "outlet": [],
    };

    print('📤 Creating user with data: $userData');

    try {
      context.read<UserBloc>().add(CreateUser(userData));
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}