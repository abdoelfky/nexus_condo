import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';

class CountdownText extends StatelessWidget {
  final int? countdown;

  const CountdownText({this.countdown});

  @override
  Widget build(BuildContext context) {
    if (countdown == null) return Container();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Resend available in ${countdown}s",
            style: TextStyle(color: AppColors.nexusGreen, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
