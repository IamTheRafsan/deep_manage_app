import 'package:deep_manage_app/Styles/Color.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            _buildAppLogo(),
            SizedBox(height: 20),
            // App name
            Text(
              'Inventory Management App',
              style: TextStyle(
                fontSize: 24,
                color: color.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Loading indicator
            CircularProgressIndicator(color: color.primaryColor),
          ],
        ),
      ),
    );
  }
}


Widget _buildAppLogo() {
  return SizedBox(
    width: 120,
    height: 120,
    child: Image.asset(
      "assets/images/logo_with_no_bg.png",
      fit: BoxFit.contain,
      // If image fails to load, show a placeholder
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            size: 60,
            color: Colors.blue,
          ),
        );
      },
    ),
  );
}