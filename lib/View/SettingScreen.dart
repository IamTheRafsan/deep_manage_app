import 'package:deep_manage_app/Component/GlobalScaffold/GlobalScaffold.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: 'Settings',
      body: Material(),
    );
  }
}