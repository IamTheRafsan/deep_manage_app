import 'package:flutter/material.dart';
import '../../Styles/AppText.dart';
import '../../Styles/Color.dart';

class DrawerExpansionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<DrawerSubMenuItem> children;

  const DrawerExpansionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(icon, color: color.primaryColor),
      title: Text(
        title,
        style: AppText.SubHeadingText(),
      ),
      childrenPadding: const EdgeInsets.only(left: 16),
      children: children
          .map(
            (item) => ListTile(
          leading: Icon(item.icon),
          title: Text(
            item.title,
            style: AppText.BodyText(),
          ),
          onTap: () {
            Navigator.pop(context); // close drawer
            item.onTap?.call();
          },
        ),
      )
          .toList(),
    );
  }
}

class DrawerSubMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  DrawerSubMenuItem({
    required this.icon,
    required this.title,
    this.onTap,
  });
}
