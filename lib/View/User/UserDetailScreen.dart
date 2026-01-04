import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/User/UserBlock.dart';
import '../../Bloc/User/UserEvent.dart';
import '../../Bloc/User/UserState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import 'package:deep_manage_app/Component/Cards/InfoCard.dart';

import '../../Styles/Color.dart';
import 'UpdateUserScreen.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserById(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "User Details",
      onBackPressed: () {
        final userBloc = context.read<UserBloc>();
        Navigator.of(context).pop();
        userBloc.add(LoadUser());
      },
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserDeleted) {
            SuccessSnackBar.show(context, message: "User Deleted Successfully!");
            context.read<UserBloc>().add(LoadUser());
            Navigator.pop(context);
          }

          if (state is UserUpdated) {
            SuccessSnackBar.show(context, message: "User Updated Successfully");
            context.read<UserBloc>().add(LoadUserById(widget.userId));
          }

          if (state is UserError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is UserLoadedSingle) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: color.primaryColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                  Text(
                                      user.firstName+user.lastName,
                                      style: AppText.HeadingText()
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                      "Roles: ${user.roles}",
                                      style: AppText.BodyText()
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Personal Information Section
                  Text(
                      "Personal Details",
                      style: AppText.SubHeadingText()
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.email,
                    title: "Email",
                    value: user.email,
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.phone,
                    title: "Mobile",
                    value: user.mobile,
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.male,
                    title: "Gender",
                    value: user.gender,
                  ),

                  const SizedBox(height: 28),

                  // Address Information Section
                  Text(
                      "Address Information",
                      style: AppText.SubHeadingText()
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.location_city_outlined,
                    title: "Address",
                    value: user.address,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          icon: Icons.flag,
                          title: "Country",
                          value: user.country,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          icon: Icons.location_pin,
                          title: "City",
                          value: user.city,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // User Info
                  Text(
                      "Status Information",
                      style: AppText.SubHeadingText()
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.calendar_today_outlined,
                    title: "Created Date",
                    value: "${user.created_date} at ${user.created_time}",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.update_outlined,
                    title: "Last Updated",
                    value: "${user.updated_date} at ${user.updated_time}",
                  ),

                  const SizedBox(height: 28),

                  // // Roles Section
                  // Text(
                  //     "Roles & Permissions",
                  //     style: AppText.SubHeadingText()
                  // ),
                  // const SizedBox(height: 12),
                  // if (user.roles.isNotEmpty)
                  //   Wrap(
                  //     spacing: 8,
                  //     runSpacing: 8,
                  //     children: user.roles
                  //         .map(
                  //           (role) => Chip(
                  //         label: Text(role),
                  //         backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  //         labelStyle: AppText.BodyText().copyWith(
                  //           color: Theme.of(context).primaryColor,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(8),
                  //           side: BorderSide(
                  //             color: Theme.of(context).primaryColor.withOpacity(0.3),
                  //           ),
                  //         ),
                  //       ),
                  //     )
                  //         .toList(),
                  //   )
                  // else
                  //   Container(
                  //     padding: const EdgeInsets.all(16),
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey[100],
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Text(
                  //       "No roles assigned",
                  //       style: AppText.BodyText().copyWith(
                  //         color: Colors.grey[600],
                  //       ),
                  //     ),
                  //   ),

                  //const SizedBox(height: 40),

                  // // Status Badge
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //   decoration: BoxDecoration(
                  //     color: user.deleted ? Colors.red.shade100 : Colors.green.shade100,
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Icon(
                  //         user.deleted ? Icons.block : Icons.check_circle,
                  //         size: 16,
                  //         color: user.deleted ? Colors.red : Colors.green,
                  //       ),
                  //       const SizedBox(width: 8),
                  //       Text(
                  //         user.deleted ? "Inactive" : "Active",
                  //         style: AppText.BodyText().copyWith(
                  //           color: user.deleted ? Colors.red : Colors.green,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: RedButton(
                          text: 'Delete User',
                          onPressed: () => context
                              .read<UserBloc>()
                              .add(DeleteUser(user.userId)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Update User',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateUserScreen(userId: user.userId),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Error Loading User",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserBloc>().add(LoadUserById(widget.userId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No user information available"),
          );
        },
      ),
    );
  }
}