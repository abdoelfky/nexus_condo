import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomButton({
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.nexusGreen,
        // Green color at the botton
        borderRadius: BorderRadius.circular(15),
        // Match button border radius
        boxShadow: [
          BoxShadow(
            color: AppColors.nexusShadowGreen, // Shadow color
            offset: Offset(0, 5), // Shadow position (bottom)
            blurRadius: 2, // Shadow blur radius
          ),
        ],
      ),

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          // Make button background transparent
          elevation: 0,
          // Remove default button elevation
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15), // Match border radius
          ),
          minimumSize: Size(
              double.infinity, 50), // Same width as TextFormField
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 16,color: AppColors.whiteTextColor)),
      ),
    );
  }
}
