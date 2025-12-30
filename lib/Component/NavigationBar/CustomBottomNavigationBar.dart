import 'package:deep_manage_app/Styles/Color.dart';
import 'package:deep_manage_app/View/HomeScreen.dart';
import 'package:deep_manage_app/View/PurchaseScreen.dart';
import 'package:deep_manage_app/View/SaleScreen.dart';
import 'package:deep_manage_app/View/SettingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Navigation/NavigationBloc.dart';
import '../../Bloc/Navigation/NavigationEvent.dart';
import '../../Bloc/Navigation/NavigationState.dart';
import '../../View/Role/ViewRoleScreen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const HomeScreen(),
      const SaleScreen(),
      const PurchaseScreen(),
      const SettingScreen()
    ];

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: _pages[state.currentTab],
          bottomNavigationBar: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ClipRRect(
              child: BottomNavigationBar(
                currentIndex: state.currentTab,
                onTap: (index) {
                  context.read<NavigationBloc>().add(NavigationTabChanged(index));
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: color.primaryColor,
                selectedItemColor: color.secondaryColor,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: state.currentTab == 0 ? 30 : 25),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_bag_rounded, size: state.currentTab == 1 ? 30 : 25),
                    label: 'Sale',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart, size: state.currentTab == 2 ? 30 : 25),
                    label: 'Purchase',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings, size: state.currentTab == 3 ? 30 : 25),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}