import 'package:deep_manage_app/Component/Inputs/TextInputField.dart';
import 'package:flutter/material.dart';

class Numberinputfield extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final double? min;
  final double? max;
  final String? Function(String?)? validator;

  const Numberinputfield({
    super.key,
    this.controller,
    required this.label,
    this.min,
    this.max,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      controller: controller,
      label: label,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (validator != null) {
          return validator!(value);
        }

        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }

        final number = double.tryParse(value);
        if (number == null) {
          return 'Please enter a valid number';
        }

        if (min != null && number < min!) {
          return 'Must be at least $min';
        }

        if (max != null && number > max!) {
          return 'Must be at most $max';
        }

        return null;
      },
    );
  }
}