import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: AppColors.primaryTextColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        // Enables filling the background
        fillColor: Colors.white.withOpacity(0.5),
        labelText: label,
        prefixIcon: Icon(
          prefixIcon,
          color: AppColors.nexusGreen,
        ),
      ),
      validator: validator,
    );
  }
}
