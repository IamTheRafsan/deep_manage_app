import 'package:deep_manage_app/Bloc/User/UserState.dart';
import 'package:deep_manage_app/Component/Cards/ProfileScreenCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:deep_manage_app/Component/GlobalScaffold/GlobalScaffold.dart';
import 'package:deep_manage_app/Component/SnackBar/WarningSnackBar.dart';
import 'package:deep_manage_app/Model/User/UserModel.dart';
import 'package:deep_manage_app/Styles/AppText.dart';
import 'package:deep_manage_app/View/SettingScreen.dart';
import 'package:deep_manage_app/View/User/UpdateUserScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deep_manage_app/Bloc/User/UserBloc.dart';
import 'package:deep_manage_app/Bloc/User/UserEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Bloc/Authentication/AuthBloc.dart';
import '../../Bloc/Authentication/AuthEvent.dart';
import '../Authentication/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String? _userId;
  bool _isLoadingUserId = true;

  @override
  void initState(){
    super.initState();
    _loadUserIdFromSharedPrefs();
  }

  Future<void> _loadUserIdFromSharedPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      setState(() {
        _userId = userId;
        _isLoadingUserId = false;
      });

      // Load user data using BLoC
      if (userId != null) {
        context.read<UserBloc>().add(LoadUserById(userId));
      }
    } catch (e) {
      print('Error loading userId: $e');
      setState(() {
        _isLoadingUserId = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        builder:(context, state) {
          if (state is UserLoading) {
            return const Scaffold(
              body: Center(
                child: CustomCircularIndicator(),
              ),
            );
          }

          if (state is UserLoadedSingle) {
            final user = state.user;
            return _buildProfileScreen(context, user);
          };

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
    );

  }
}

Widget _buildProfileScreen(BuildContext context, UserModel user){
  return GlobalScaffold(
      title: "User Profile",
      showBackButton: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/user_icon.png'),
              ),
            ),
            SizedBox(height: 30,),
            Text(user.firstName, style: AppText.SubHeadingText(),),
            Text(user.roles.join(', '), style: AppText.BodyText(),),
            SizedBox(height: 70,),
            ProfileScreenCard(icon: Icons.edit, header: "Edit Profile", onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateUserScreen(userId: user.userId))
              );
            },),
            ProfileScreenCard(icon: Icons.lock_clock_rounded, header: "Permissions", onTap: (){
              WarningSnackBar.show(context, message: "Sorry! Page not yet built.");
            },),
            ProfileScreenCard(icon: Icons.password, header: "Change Password", onTap: (){
              WarningSnackBar.show(context, message: "Sorry! Page not yet built.");
            },),
            ProfileScreenCard(icon: Icons.settings, header: "Settings", onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen())
              );
            },),
            ProfileScreenCard(icon: Icons.logout, header: "Logout", iconColor: Colors.red, onTap: (){
              _handleLogout(context);
            }),
            SizedBox(height: 70,)
          ],
        ),
      )
  );
}

// Logout confirmation dialog
Future<bool> _showLogoutConfirmation(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  ) ?? false;
}

// Handle logout
void _handleLogout(BuildContext context) async {
  final shouldLogout = await _showLogoutConfirmation(context);

  if (!shouldLogout) return;

  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  // Get AuthBloc and trigger logout
  final authBloc = context.read<AuthBloc>();
  authBloc.add(LogoutEvent());

  // Wait for logout to process
  await Future.delayed(const Duration(milliseconds: 500));

  // Close loading dialog
  if (context.mounted) {
    Navigator.of(context).pop(); // Close loading dialog

    // Navigate to login screen and clear all routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }
}
