import 'package:deep_manage_app/Styles/AppText.dart';
import 'package:flutter/material.dart';

import '../../Styles/Color.dart';

class ProfileScreenCard extends StatelessWidget {
  final IconData? icon;
  final String header;
  final VoidCallback? onTap;
  final Color iconColor;

  const ProfileScreenCard({super.key,
  required this.icon,
    required this.header,
    required this.onTap,
    this.iconColor = color.primaryColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: color.cardBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(icon, color: iconColor,),
            ),
            Expanded(
              child:
                Text(
                  header,
                  style: TextStyle(
                    fontSize: 16,
                    color: iconColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ),
            Icon(
              Icons.arrow_right_outlined,
              color: iconColor,
            )
          ],
        ),
      ),
    );
  }
}
