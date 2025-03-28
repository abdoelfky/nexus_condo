import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'widgets/GridScreen.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class AdminServicesScreen extends ConsumerStatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<AdminServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBarColor,
      appBar: PrimaryAppBar(title: 'Services'),
      body: BackgroundScreen(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: SizedBox(
                  height: 400, // Set a fixed height for the grid
                  child: ItemGrid(), // Ensure ItemGrid is a properly configured GridView
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
