import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/features/admin/home/presentation/home_screen.dart';
import 'package:nexus_condo/features/profile/profile_screen.dart';
import 'package:nexus_condo/features/user/home/controllers/bottom_nav_provider.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class AdminDashBoardScreen extends ConsumerWidget {
  const AdminDashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current index from the bottomNavProvider
    final currentIndex = ref.watch(bottomNavProvider).selectedIndex;

    // Define the screens corresponding to each tab
    final List<Widget> screens = [
      AdminHomeScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageStorage(
        bucket: PageStorageBucket(),
        child: screens[currentIndex], // Display the selected screen
      ),
      bottomNavigationBar: CustomBottomNavBar(), // Bottom navigation bar
    );
  }
}
