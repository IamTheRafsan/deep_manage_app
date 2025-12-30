import 'package:deep_manage_app/Component/GlobalScaffold/GlobalScaffold.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Repository/AuthRepository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getString('userId') ?? "N/A";
      final firstName = prefs.getString('firstName') ?? "N/A";
      final lastName = prefs.getString('lastName') ?? "N/A";
      final email = prefs.getString('email') ?? "N/A";
      final mobile = prefs.getString('mobile') ?? "N/A";
      final roles = prefs.getStringList('roles')?.join(', ') ?? "N/A";

      print("User ID: $userId");
      print("Name: $firstName $lastName");
      print("Email: $email");
      print("Mobile: $mobile");
      print("Roles: $roles");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Inventory Dashboard",
      showBackButton: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,


    ),
      ),
    );
  }

}