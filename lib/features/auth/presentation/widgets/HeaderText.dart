import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';

class HeaderText extends StatelessWidget {
  final String text;

  const HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.whiteTextColor,
      ),
    );
  }
}
