import 'package:deep_manage_app/Styles/AppText.dart';
import 'package:flutter/material.dart';
import 'package:deep_manage_app/Styles/Color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: AppText.AppBarHeading(),),
      ),
      backgroundColor: color.primaryColor,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: _buildLeading(context),
      automaticallyImplyLeading: showBackButton,
      actions: [
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.grid_view_outlined, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ),
        // Custom actions passed from screen
        ...?actions,
      ],
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: color.buttonTextPrimaryColor,),
        iconSize: 25.0,
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }
}