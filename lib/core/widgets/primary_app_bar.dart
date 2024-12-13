import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const PrimaryAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appBarColor, // Background color of the app bar
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(5), // Circular bottom border
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            blurRadius: 4, // Shadow blur radius
            offset: const Offset(0, 2), // Shadow offset
          ),
        ],
      ),
      child: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.whiteTextColor, // Set the back icon color to white
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteTextColor, // White text color for the title
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        // Make AppBar transparent
        elevation: 0, // Remove AppBar elevation
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Include circular border height
}
