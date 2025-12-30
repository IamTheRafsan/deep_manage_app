import 'package:flutter/material.dart';
import '../../Styles/AppText.dart';
import '../../Styles/Color.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.titleStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.cardBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor ?? color.primaryColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor ?? color.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: titleStyle ??
                      TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: valueStyle ?? AppText.BodyTextBold(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
