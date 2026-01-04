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
import '../../Styles/Color.dart';

class UpdateUserScreen extends StatefulWidget {
  final String userId;

  const UpdateUserScreen({super.key, required this.userId});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final List<String> _selectedRoleIds = [];
  final List<String> _selectedRoleNames = [];
  bool _isLoading = false;
  bool _initialDataLoaded = false;

  List<RoleModel> _availableRoles = [];
  bool _loadingRoles = true;
  List<String> _pendingUserRoles = [];
  bool _rolesLoaded = false;
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
    'Bangladesh'
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
    context.read<UserBloc>().add(LoadUserById(widget.userId));
    context.read<RoleBloc>().add(LoadRoles());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Update User",
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoadedSingle && !_initialDataLoaded) {
            final user = state.user;
            _firstNameController.text = user.firstName;
            _lastNameController.text = user.lastName;
            _emailController.text = user.email;
            _mobileController.text = user.mobile;
            _genderController.text = user.gender;
            _countryController.text = user.country;
            _cityController.text = user.city;
            _addressController.text = user.address;

            _selectedGender = user.gender;
            _selectedCountry = user.country;

            _pendingUserRoles = List<String>.from(user.roles);
            if (_rolesLoaded) {
              _mapPendingRoles();
            }

            _initialDataLoaded = true;
          }

          if (state is UserUpdated) {
            SuccessSnackBar.show(context, message: "User Updated Successfully!");
            Navigator.pop(context);
          }

          if (state is UserError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          if (state is UserLoading && !_initialDataLoaded) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Loading user data...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return BlocListener<RoleBloc, RoleState>(
            listener: (context, roleState) {
              if (roleState is RoleLoaded) {
                setState(() {
                  _availableRoles = roleState.roles;
                  _loadingRoles = false;
                  _rolesLoaded = true;

                  _roleNameToIdMap = {};
                  for (var role in roleState.roles) {
                    _roleNameToIdMap[role.name] = role.role_id;
                  }
                });

                if (_pendingUserRoles.isNotEmpty) {
                  _mapPendingRoles();
                }
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

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender *',
                        style: AppText.BodyText(),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        child: DropDownInputField<String>(
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
                      ),
                    ],
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
                        label: "Country",
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
                      onPressed: _isLoading ? null : _updateUser,
                      text: _isLoading ? 'Updating...' : 'Update User',
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
                    label: Text(roleName, style: AppText.BodyText(),),
                    backgroundColor: color.cardBackgroundColor,
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
        DropDownInputField<String>(
            value: null,
            label: "Select Role",
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

  Future<void> _updateUser() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _mobileController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please fill all required fields");
      return;
    }

    if (!_emailController.text.contains('@')) {
      WarningSnackBar.show(context, message: "Please enter a valid email");
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
    final updatedData = {
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "email": _emailController.text.trim(),
      "gender": _selectedGender,
      "mobile": mobileNumber,
      "country": _selectedCountry,
      "city": _cityController.text.trim(),
      "address": _addressController.text.trim(),
      "role_id": _selectedRoleIds,
      "password": null,
      "created_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "created_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "warehouse": [],
      "outlet": [],
    };

    try {
      context.read<UserBloc>().add(UpdateUser(widget.userId, updatedData));
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _mapPendingRoles() {
    if (_pendingUserRoles.isEmpty) return;

    _selectedRoleIds.clear();
    _selectedRoleNames.clear();

    for (var roleIdentifier in _pendingUserRoles) {
      if (roleIdentifier.startsWith('DeepManageRole')) {
        final role = _availableRoles.firstWhere(
              (r) => r.role_id == roleIdentifier,
          orElse: () => _createPlaceholderRole(
            roleId: roleIdentifier,
            name: 'Unknown Role',
            deleted: false,
          ),
        );
        _selectedRoleIds.add(roleIdentifier);
        _selectedRoleNames.add(role.name);
      }
      else if (_roleNameToIdMap.containsKey(roleIdentifier)) {
        final roleId = _roleNameToIdMap[roleIdentifier]!;
        _selectedRoleIds.add(roleId);
        _selectedRoleNames.add(roleIdentifier);
      }
    }

    _pendingUserRoles.clear();
    setState(() {});
  }

  RoleModel _createPlaceholderRole({
    String roleId = '',
    String name = '',
    bool deleted = false,
  }) {
    return RoleModel(
      role_id: roleId,
      name: name,
      created_by_id: null,
      created_by_name: null,
      updated_by_id: null,
      updated_by_name: null,
      permission: [],
      created_date: null,
      created_time: null,
      updated_date: null,
      updated_time: null,
      deleted: deleted,
      deletedById: null,
      deletedByName: null,
      deletedDate: null,
      deletedTime: null,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _genderController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}