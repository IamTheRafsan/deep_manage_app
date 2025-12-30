import 'package:deep_manage_app/Component/Buttons/PrimaryButton.dart';
import 'package:deep_manage_app/Component/GlobalScaffold/GlobalScaffold.dart';
import 'package:deep_manage_app/Component/Inputs/TextInputField.dart';
import 'package:deep_manage_app/Component/SnackBar/SuccessSnackBar.dart';
import 'package:deep_manage_app/Component/SnackBar/WarningSnackBar.dart';
import 'package:deep_manage_app/Styles/AppText.dart';
import 'package:deep_manage_app/Styles/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Role/RoleBloc.dart';
import '../../Bloc/Role/RoleEvent.dart';
import '../../Bloc/Role/RoleState.dart';
import '../../Const/permisssions.dart';

class UpdateRoleScreen extends StatefulWidget {
  final String roleId;

  const UpdateRoleScreen({super.key, required this.roleId});

  @override
  State<UpdateRoleScreen> createState() => _UpdateRoleScreenState();
}

class _UpdateRoleScreenState extends State<UpdateRoleScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> selectedPermissions = [];
  bool isLoading = false;
  bool _initialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    // Load role data when screen opens
    context.read<RoleBloc>().add(LoadRoleById(widget.roleId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Update Role",
      body: BlocConsumer<RoleBloc, RoleState>(
        listener: (context, state) {
          if (state is RoleLoadedSingle && !_initialDataLoaded) {
            // Pre-fill data when loaded
            _nameController.text = state.role.name;
            selectedPermissions.clear();
            selectedPermissions.addAll(state.role.permission);
            _initialDataLoaded = true;
          }

          if (state is RoleUpdated) {
            SuccessSnackBar.show(context, message: "Role Updated Successfully!");
            Navigator.pop(context); // Go back after update
          }

          if (state is RoleError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is RoleLoading && !_initialDataLoaded) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Loading role data...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const SizedBox(height: 8),
                Text(
                  "Update role information and permissions",
                  style: AppText.BodyText(),
                ),
                const SizedBox(height: 24),

                // Role Name Field
                const SizedBox(height: 8),
                TextInputField(
                  controller: _nameController,
                  label: 'Enter Role Name',
                ),
                const SizedBox(height: 28),

                // Permissions Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Permissions *",
                      style: AppText.SubHeadingText(),
                    ),
                    Text(
                      "${selectedPermissions.length} selected",
                      style: AppText.BodyTextBold()
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Select permissions for this role",
                  style: AppText.BodyText()
                ),
                const SizedBox(height: 16),

                // Permissions List
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.primaryColor),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: allPermissions.length,
                      itemBuilder: (context, index) {
                        final perm = allPermissions[index];
                        final isSelected = selectedPermissions.contains(perm);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[200]!,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: CheckboxListTile(
                            title: Text(
                              perm,
                              style: AppText.BodyText()
                            ),
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  selectedPermissions.add(perm);
                                } else {
                                  selectedPermissions.remove(perm);
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            secondary: Icon(
                              Icons.control_point_sharp,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Update Button
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PrimaryButton(
                    onPressed: isLoading ? null : _updateRole,
                    text: 'Update',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateRole() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Role name is required"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    if (selectedPermissions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Select at least one permission"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final updatedData = {
      "name": _nameController.text.trim(),
      "permission": selectedPermissions,
    };

    try {
      context.read<RoleBloc>().add(UpdateRoleById(widget.roleId, updatedData));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}