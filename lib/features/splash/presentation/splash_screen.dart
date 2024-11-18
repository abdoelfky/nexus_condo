import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/constants/app_constants.dart';
import 'package:nexus_condo/core/constants/app_images.dart';
import 'package:nexus_condo/core/shared_preferences/shared_preferences.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/features/admin/home/presentation/home_screen.dart';
import 'package:nexus_condo/features/auth/presentation/auth_screen.dart';
import 'package:nexus_condo/features/user/home/presentation/home_screen.dart';

import 'bouncy_widget.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use a stateful approach for the delayed navigation
    Future.delayed(Duration(seconds: 2), () {
      // Check if the widget is still mounted
      if (context.mounted) {

        if(AppSettingsPreferences().id != '') {
          if (AppSettingsPreferences().userType.toLowerCase() == UserType.admin.value.toLowerCase()) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => AdminHomeScreen()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          }
        }else
        {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        }
      }
    });

    return Scaffold(
      body: BackgroundScreen(
        child: Stack(
          children: [
            // Centered Image
            Positioned(
              top: MediaQuery.of(context).size.height*.4,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 180,
                width: 180,
                child: BouncyWidget(
                    duration: const Duration(milliseconds: 2000),
                    lift: 50,
                    ratio: 0.5,
                    pause: 0.25,
                    child: SizedBox(width: 150,
                        child: Image.asset(AppImages.logo, width: 150.0))),
              ),
        
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
        
                Spacer(), // Pushes the "Approved" text to the bottom
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Take up minimum space
                      children: [
                        Text(
                          'App Version 1.1.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.whiteTextColor, // Text color for version
                          ),
                        ),
                        const SizedBox(width: 8), // Space between text
                        Text(
                          'Nexus Design Studios',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.nexusGreen, // Use your defined green color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
