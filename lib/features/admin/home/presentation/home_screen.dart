import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/constants/app_images.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'widgets/GridScreen.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBarColor,
      appBar: CustomAppBar(title: 'Admin-Resident - Capital ceo'),
      body: BackgroundScreen(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ItemGrid(),
              ),
              SizedBox(height: Dimensions.paddingSizeDefault,),
              // Padding(
              //   padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              //   child: GestureDetector(
              //     onTap: () {},
              //     child: SizedBox(
              //       height: Dimensions.imgHeightDefault,
              //       width: double.infinity,
              //       child: ClipRRect(
              //         borderRadius:
              //             BorderRadius.circular(Dimensions.radiusExtraLarge),
              //         child: Image.asset(
              //           AppImages.bannerImg,
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
