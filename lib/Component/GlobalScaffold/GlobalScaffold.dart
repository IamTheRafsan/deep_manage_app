import 'package:deep_manage_app/Component/DrawerTiles/CustomExpensionTile.dart';
import 'package:deep_manage_app/Styles/Color.dart';
import 'package:deep_manage_app/View/Expense/ViewExpenseCategory.dart';
import 'package:deep_manage_app/View/ExpenseCategory/AddExpenseCategoryScreen.dart';
import 'package:deep_manage_app/View/ExpenseCategory/ViewExpenseCategory.dart';
import 'package:deep_manage_app/View/Outlet/AddOutletScreen.dart';
import 'package:deep_manage_app/View/Outlet/ViewOutletScreen.dart';
import 'package:deep_manage_app/View/Role/ViewRoleScreen.dart';
import 'package:deep_manage_app/View/User/AddUserScreen.dart';
import 'package:deep_manage_app/View/Warehouse/AddWarehouseScreen.dart';
import 'package:deep_manage_app/View/Warehouse/ViewWarehouseScreen.dart';
import 'package:flutter/material.dart';
import '../../Styles/AppText.dart';
import '../../View/Expense/AddExpenseScreen.dart';
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

            //Warehouse
            DrawerExpansionTile(
              icon: Icons.warehouse,
              title: 'Warehouse',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Warehouse",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewWarehouseScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Warehouse",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddWarehouseScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //Outlet
            DrawerExpansionTile(
              icon: Icons.shopping_basket_rounded,
              title: 'Outlet',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Outlet",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewOutletScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Outlet",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddOutletScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //Expense
            DrawerExpansionTile(
              icon: Icons.money_rounded,
              title: 'Expense',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Expense",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewExpenseScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Expense",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddExpenseScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //Expense Category
            DrawerExpansionTile(
              icon: Icons.category_rounded,
              title: 'Expense Category',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Expense Category",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewExpenseCategoryScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Expense Category",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddExpenseCategoryScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),


            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red,),
              title: const Text("Logout", style: TextStyle(color: Colors.red),),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: body,
    );
  }

}