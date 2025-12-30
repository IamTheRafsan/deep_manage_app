import 'package:deep_manage_app/Styles/Color.dart';
import 'package:flutter/material.dart';
import 'package:deep_manage_app/Styles/AppText.dart';

class SecondaryButton extends StatelessWidget{

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final double height;
  final Color? textColor;
  final IconData? icon;

  SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.height = 50,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed:(enabled && !isLoading && onPressed != null)
            ? onPressed
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.buttonBackgroundSecondaryColor,
          foregroundColor: color.buttonTextPrimaryColor,
          disabledBackgroundColor: Colors.grey[400],
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
        ),
        child: isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.black,
          ),
        )
            : icon != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Text(text , style: AppText.buttonSecondaryText()),
          ],
        )
            : Text(text, style: AppText.buttonSecondaryText()),
      ),
    );
  }
}