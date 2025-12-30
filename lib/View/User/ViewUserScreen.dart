import 'package:deep_manage_app/Component/Cards/ViewCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/User/UserBlock.dart';
import '../../Bloc/User/UserState.dart';
import '../../Bloc/User/UserEvent.dart';
import '../../Model/User/UserModel.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'UserDetailScreen.dart';

class ViewUserScreen extends StatefulWidget {
  const ViewUserScreen({super.key});

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUser());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Users",
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CustomCircularIndicator(
              ),
            );
          } else if (state is UserLoaded) {
            final List<UserModel> activeUsers =
            state.users.where((user) => !user.deleted).toList();

            if (activeUsers.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserBloc>().add(LoadUser());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: activeUsers.length,
                itemBuilder: (context, index) {
                  final user = activeUsers[index];

                  // Determine status color
                  Color statusColor;
                  IconData statusIcon;
                  String statusText;

                  if (user.deleted == 1) {
                    statusColor = Colors.red;
                    statusIcon = Icons.block;
                    statusText = "Inactive";
                  } else {
                    statusColor = Colors.green;
                    statusIcon = Icons.check_circle;
                    statusText = "Active";
                  }



                  return ViewCard(
                    title: "${user.firstName} ${user.lastName}",
                    subtitle: "${user.email}\n${user.roles.join(', ')}",
                    icon: Icons.person_sharp,
                    dateText: "${user.created_date}",
                    onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserDetailScreen(userId: user.userId),
                            ),
                          );
                          context.read<UserBloc>().add(LoadUser());
                        },);
                  // return Card(
                  //   margin: const EdgeInsets.only(bottom: 12),
                  //   elevation: 2,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: ListTile(
                  //     contentPadding: const EdgeInsets.all(16),
                  //     leading: Container(
                  //       width: 48,
                  //       height: 48,
                  //       decoration: BoxDecoration(
                  //         color: Theme.of(context).primaryColor.withOpacity(0.1),
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: Icon(
                  //         Icons.person,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     ),
                  //     title: Text(
                  //       "${user.firstName} ${user.lastName}",
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //     subtitle: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const SizedBox(height: 4),
                  //         Text(
                  //           user.email,
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             color: Colors.grey[600],
                  //           ),
                  //         ),
                  //         const SizedBox(height: 4),
                  //         Row(
                  //           children: [
                  //             Icon(
                  //               statusIcon,
                  //               size: 14,
                  //               color: statusColor,
                  //             ),
                  //             const SizedBox(width: 4),
                  //             Text(
                  //               statusText,
                  //               style: TextStyle(
                  //                 fontSize: 12,
                  //                 color: statusColor,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //     trailing: Container(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 12,
                  //         vertical: 6,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         color: Theme.of(context).primaryColor.withOpacity(0.1),
                  //         borderRadius: BorderRadius.circular(20),
                  //       ),
                  //       child: Text(
                  //         user.roles.isNotEmpty ? user.roles[0] : "No Role",
                  //         style: TextStyle(
                  //           fontSize: 12,
                  //           color: Theme.of(context).primaryColor,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //     onTap: () async {
                  //       await Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (_) => UserDetailScreen(userId: user.userId),
                  //         ),
                  //       );
                  //       context.read<UserBloc>().add(LoadUser());
                  //     },
                  //   ),
                  // );
                },
              ),
            );
          } else if (state is UserError) {
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
                    "Error Loading Users",
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
                      context.read<UserBloc>().add(LoadUser());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No users available"),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Users Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Create your first user to get started",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}