import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Reusable custom text field widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isNumber;
  final int maxLines;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isNumber = false,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppConstants.cardBackgroundColor,
      ),
      validator: validator ??
          (value) => value == null || value.isEmpty
              ? AppConstants.getRequiredFieldMessage(label)
              : null,
    );
  }
}

