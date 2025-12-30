import 'package:deep_manage_app/Component/DrawerTiles/CustomExpensionTile.dart';
import 'package:deep_manage_app/Styles/Color.dart';
import 'package:deep_manage_app/View/Role/ViewRoleScreen.dart';
import 'package:deep_manage_app/View/User/AddUserScreen.dart';
import 'package:flutter/material.dart';

import '../../Styles/AppText.dart';
import '../../View/Role/AddRoleScreen.dart';
import '../../View/User/ViewUserScreen.dart';
import '../AppBar/CustomAppBar.dart';

class GlobalScaffold extends StatelessWidget{
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  GlobalScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.backgroundColor,
      appBar: CustomAppBar(
        title: title,
        actions: actions,
        showBackButton: showBackButton,
        onBackPressed: onBackPressed,
      ),
      endDrawer: Drawer(
        backgroundColor: color.backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: color.primaryColor),
              child: Text(
                "Menu",
                style: AppText.HeadingTextWhite(),
              ),
            ),

            //Role
            DrawerExpansionTile(
              icon: Icons.security_update_good_outlined,
              title: 'Role',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Role",
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ViewRoleScreen(),
                      ),
                    );
                  }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Role",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddRoleScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //User
            DrawerExpansionTile(
              icon: Icons.person_sharp,
              title: 'User',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View User",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewUserScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add User",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddUserScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: body,
    );
  }

}