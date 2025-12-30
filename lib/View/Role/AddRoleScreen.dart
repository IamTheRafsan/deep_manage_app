import 'package:deep_manage_app/Component/Buttons/PrimaryButton.dart';
import 'package:deep_manage_app/Component/GlobalScaffold/GlobalScaffold.dart';
import 'package:deep_manage_app/Component/Inputs/TextInputField.dart';
import 'package:deep_manage_app/Component/SnackBar/SuccessSnackBar.dart';
import 'package:deep_manage_app/Component/SnackBar/WarningSnackBar.dart';
import 'package:deep_manage_app/Styles/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Role/RoleBloc.dart';
import '../../Bloc/Role/RoleEvent.dart';
import '../../Const/permisssions.dart';
import '../../Styles/AppText.dart';

class AddRoleScreen extends StatefulWidget {
  const AddRoleScreen({super.key});

  @override
  State<AddRoleScreen> createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  final TextEditingController _nameController = TextEditingController();
  List<String> selectedPermissions = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Create New Role",
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Role Name Field
            Text(
              "Role Name *",
              style: AppText.SubHeadingText(),
            ),
            const SizedBox(height: 8),
            TextInputField(
              controller: _nameController,
              label: "Enter Role Name",
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
                        borderRadius: BorderRadius.circular(8),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        secondary: Icon(
                          Icons.control_point_sharp,
                          color: isSelected
                              ? color.primaryColor
                              : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Create Button
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: PrimaryButton(
                text: "Create",
                onPressed: isLoading ? null : _createRole,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createRole() async {
    if (_nameController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Role name cannot be empty");
      return;
    }

    if (selectedPermissions.isEmpty) {
      WarningSnackBar.show(context, message: "Select at least one permission");
      return;
    }

    setState(() => isLoading = true);

    try {
      final repo = context.read<RoleBloc>().roleRepository;

      await repo.createRole(
        _nameController.text.trim(),
        selectedPermissions,
      );

      SuccessSnackBar.show(context, message: "Role Created Successfully!");

      context.read<RoleBloc>().add(LoadRoles());
      Navigator.pop(context);
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }
}