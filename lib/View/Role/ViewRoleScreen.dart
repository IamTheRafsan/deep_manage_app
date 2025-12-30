import 'package:deep_manage_app/Component/Cards/RoleCard.dart';
import 'package:deep_manage_app/Styles/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Role/RoleBloc.dart';
import '../../Bloc/Role/RoleState.dart';
import '../../Bloc/Role/RoleEvent.dart';
import '../../Model/RoleModel/RoleModel.dart';
import '../../Styles/Color.dart';
import 'RoleDetailScreen.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';

class ViewRoleScreen extends StatefulWidget {
  const ViewRoleScreen({super.key});

  @override
  State<ViewRoleScreen> createState() => _ViewRoleScreenState();
}

class _ViewRoleScreenState extends State<ViewRoleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoleBloc>().add(LoadRoles());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Roles",
      body: BlocBuilder<RoleBloc, RoleState>(
        builder: (context, state) {
          if (state is RoleLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is RoleLoaded) {
            final List<RoleModel> roles = state.roles.where((role) => role.deleted != 1).toList();

            if (roles.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<RoleBloc>().add(LoadRoles());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  return RoleCard(
                    role: role,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoleDetailScreen(roleId: role.role_id),
                        ),
                      );
                      context.read<RoleBloc>().add(LoadRoles());
                    },
                  );

                },
              ),
            );
          } else if (state is RoleError) {
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
                    "Error Loading Roles",
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
                      context.read<RoleBloc>().add(LoadRoles());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No roles available"),
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
              Icons.badge_outlined,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Roles Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Create your first role to get started",
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