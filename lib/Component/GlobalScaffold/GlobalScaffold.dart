import 'package:deep_manage_app/Bloc/Authentication/AuthBloc.dart';
import 'package:deep_manage_app/Bloc/Authentication/AuthEvent.dart';
import 'package:deep_manage_app/Component/DrawerTiles/CustomExpensionTile.dart';
import 'package:deep_manage_app/Styles/Color.dart';
import 'package:deep_manage_app/View/Brand/AddBrandScreen.dart';
import 'package:deep_manage_app/View/Brand/ViewBrandScreen.dart';
import 'package:deep_manage_app/View/DepositCategory/AddDepositCategoryScreen.dart';
import 'package:deep_manage_app/View/DepositCategory/ViewDepositCategoryScreen.dart';
import 'package:deep_manage_app/View/Expense/ViewExpenseCategory.dart';
import 'package:deep_manage_app/View/ExpenseCategory/AddExpenseCategoryScreen.dart';
import 'package:deep_manage_app/View/ExpenseCategory/ViewExpenseCategory.dart';
import 'package:deep_manage_app/View/Outlet/AddOutletScreen.dart';
import 'package:deep_manage_app/View/Outlet/ViewOutletScreen.dart';
import 'package:deep_manage_app/View/PaymentType/AddPaymentTypeScreen.dart';
import 'package:deep_manage_app/View/PaymentType/ViewPaymentTypeScreen.dart';
import 'package:deep_manage_app/View/Product/ViewProductScreen.dart';
import 'package:deep_manage_app/View/ProductCategory/AddProductCategoryScreen.dart';
import 'package:deep_manage_app/View/ProductCategory/ViewProductCategoryScreen.dart';
import 'package:deep_manage_app/View/Purchase/AddPurchaseScreen.dart';
import 'package:deep_manage_app/View/Role/ViewRoleScreen.dart';
import 'package:deep_manage_app/View/Sale/AddSaleScreen.dart';
import 'package:deep_manage_app/View/Sale/ViewSaleScreen.dart';
import 'package:deep_manage_app/View/User/AddUserScreen.dart';
import 'package:deep_manage_app/View/Warehouse/AddWarehouseScreen.dart';
import 'package:deep_manage_app/View/Warehouse/ViewWarehouseScreen.dart';
import 'package:deep_manage_app/View/WeightLess/AddWeightLessScreen.dart';
import 'package:deep_manage_app/View/WeightLess/ViewWeightLessScreen.dart';
import 'package:deep_manage_app/View/WeightWastage/ViewWeightWastageScreen.dart';
import 'package:deep_manage_app/View/WeightWastage/WeightWastageScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Styles/AppText.dart';
import '../../View/Authentication/LoginScreen.dart';
import '../../View/Deposit/AddDepositScreen.dart';
import '../../View/Deposit/ViewDepositScreen.dart';
import '../../View/Expense/AddExpenseScreen.dart';
import '../../View/Product/AddProductScreen.dart';
import '../../View/Purchase/ViewPurchaseScreen.dart';
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

            //Deposit
            DrawerExpansionTile(
              icon: Icons.credit_card_sharp,
              title: 'Deposit',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Deposit",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewDepositScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Deposit",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddDepositScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //Deposit Category
            DrawerExpansionTile(
              icon: Icons.category_rounded,
              title: 'Deposit Category',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Deposit Category",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewDepositCategoryScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Deposit Category",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddDepositCategoryScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //Brand
            DrawerExpansionTile(
              icon: Icons.branding_watermark_rounded,
              title: 'Brand',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Brand",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewBrandScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Brand",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddBrandScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //Category
            DrawerExpansionTile(
              icon: Icons.category,
              title: 'Product Category',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Product Category",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewProductCategoryScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Product Category",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProductCategoryScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //Product
            DrawerExpansionTile(
              icon: Icons.card_giftcard_rounded,
              title: 'Product',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Product",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewProductScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Product",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProductScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //Payment Type
            DrawerExpansionTile(
              icon: Icons.credit_card_rounded,
              title: 'Payment Type',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Payment Type",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewPaymentTypeScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Payment Type",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddPaymentTypeScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //Purchase
            DrawerExpansionTile(
              icon: Icons.attach_money_rounded,
              title: 'Purchase',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Purchase",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewPurchaseScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Purchase",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddPurchaseScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //Sale
            DrawerExpansionTile(
              icon: Icons.attach_money_rounded,
              title: 'Sale',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Sale",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewSaleScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Sale",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddSaleScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //WeightLess
            DrawerExpansionTile(
              icon: Icons.balance_rounded,
              title: 'Weight Less',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Weight Less",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewWeightLessScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Weight Less",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddWeightLessScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),

            //WeightWastage
            DrawerExpansionTile(
              icon: Icons.balance_rounded,
              title: 'Weight Wastage',
              children: [
                DrawerSubMenuItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "View Weight Wastage",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewWeightWastageScreen(),
                        ),
                      );
                    }
                ),
                DrawerSubMenuItem(
                    icon: Icons.add_box_outlined,
                    title: "Add Weight Wastage",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddWeightWastageScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),


            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red,),
              title: const Text("Logout", style: TextStyle(color: Colors.red),),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
      body: body,
    );
  }

}