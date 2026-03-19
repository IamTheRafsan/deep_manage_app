import 'package:deep_manage_app/Component/Buttons/PrimaryButton.dart';
import 'package:deep_manage_app/Component/SafeArea/DetailScreenSafeArea.dart';
import 'package:deep_manage_app/Component/SnackBar/SuccessSnackBar.dart';
import 'package:deep_manage_app/Component/SnackBar/WarningSnackBar.dart';
import 'package:deep_manage_app/Styles/AppText.dart';
import 'package:deep_manage_app/Styles/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Role/RoleBloc.dart';
import '../../Bloc/Role/RoleEvent.dart';
import '../../Bloc/Role/RoleState.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'UpdateRoleScreen.dart';
import 'package:deep_manage_app/Component/Cards/InfoCard.dart';

class RoleDetailScreen extends StatefulWidget {
  final String roleId;

  const RoleDetailScreen({super.key, required this.roleId});

  @override
  State<RoleDetailScreen> createState() => _RoleDetailScreenState();
}

class _RoleDetailScreenState extends State<RoleDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoleBloc>().add(LoadRoleById(widget.roleId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Role Details",
      onBackPressed: () {
        final roleBloc = context.read<RoleBloc>();
        Navigator.of(context).pop();
        roleBloc.add(LoadRoles());
      },
      body: BlocConsumer<RoleBloc, RoleState>(
        listener: (context, state) {
          if (state is RoleDeleted) {
            SuccessSnackBar.show(context, message: "Role Deleted Successfully!");
            context.read<RoleBloc>().add(LoadRoles());
            Navigator.pop(context);
          }

          if (state is RoleUpdated) {
            SuccessSnackBar.show(context, message: "Role Updated Sucessfully");
            context.read<RoleBloc>().add(LoadRoleById(widget.roleId));
          }

          if (state is RoleError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is RoleLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is RoleLoadedSingle) {
            final role = state.role;

            return  Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: color.cardBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: color.primaryColor),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: color.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.badge_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(role.name, style: AppText.HeadingText()),
                                    // const SizedBox(height: 4),
                                    // Text("ID: ${role.role_id}", style: AppText.BodyText()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        Text("Role Details", style: AppText.SubHeadingText()),
                        const SizedBox(height: 16),

                        // if (role.created_by_id != null &&
                        //     role.created_by_id!.isNotEmpty)
                        //   InfoCard(
                        //     icon: Icons.person_outline,
                        //     title: "Created By",
                        //     value: role.created_by_id!,
                        //   ),
                        //
                        // const SizedBox(height: 12),

                        InfoCard(
                          icon: Icons.calendar_today_outlined,
                          title: "Created Date",
                          value: "${role.created_date} at ${role.created_time}",
                        ),

                        const SizedBox(height: 12),

                        InfoCard(
                          icon: Icons.update_outlined,
                          title: "Last Updated",
                          value: "${role.updated_date} at ${role.updated_time}",
                        ),

                        const SizedBox(height: 28),

                        Text("Permissions", style: AppText.SubHeadingText()),
                        const SizedBox(height: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: role.permission.map(
                                (perm) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Chip(
                                label: Text(perm),
                                backgroundColor: color.cardBackgroundColor,
                                labelStyle: AppText.BodyText(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ),
                          ).toList(),
                        ),


                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                //Bottom Buttons
                CustomSafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: RedButton(
                            text: 'Delete Role',
                            onPressed: () => context
                                .read<RoleBloc>()
                                .add(DeleteRoleById(role.role_id)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Update Role',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateRoleScreen(roleId: role.role_id),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                )
              ],
            );

          }

          return const Center(
            child: Text("No role information available"),
          );
        },
      ),
    );
  }
}