import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onVisibilityToggle;

  const PasswordField({
    required this.controller,
    required this.obscureText,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle:
        TextStyle(color: AppColors.whiteTextColor),
        prefixIcon: Icon(
          Icons.vpn_key_outlined,
          color: AppColors.nexusGreen,
        ),        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: onVisibilityToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) =>
          value!.isEmpty ? 'Please enter your password' : null,
    );
  }
}
