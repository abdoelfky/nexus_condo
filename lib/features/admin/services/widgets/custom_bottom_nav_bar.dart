import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/features/user/home/controllers/bottom_nav_provider.dart';

class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNavState = ref.watch(bottomNavProvider);

    return BottomNavigationBar(
      currentIndex: bottomNavState.selectedIndex,
      onTap: (index) {
        ref.read(bottomNavProvider.notifier).selectIndex(index);
      },
      backgroundColor: AppColors.bottomNavBarColor,
      selectedItemColor: AppColors.whiteColor,
      unselectedItemColor: AppColors.greyColor,
      selectedLabelStyle: TextStyle(
          fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w700),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.maps_home_work,
              size: Dimensions.iconSizeLarge,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_2, size: Dimensions.iconSizeDefault),
            label: 'Profile'),
      ],
    );
  }
}
