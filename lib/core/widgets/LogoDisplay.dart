import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_constants.dart';
import 'package:nexus_condo/core/constants/app_images.dart';

class LogoDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .15),
        child: SizedBox(
          height: iconSize,
          width: iconSize,
          child: Image.asset(AppImages.logo),
        ),
      ),
    );
  }
}
