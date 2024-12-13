import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/constants/app_images.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/admin/units/data/unit.dart';

class UnitDetailsScreen extends StatelessWidget {
  final Unit unit;

  const UnitDetailsScreen({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: ('Unit ${unit.unitNo}'),
      ),
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (unit.imageUrls.isNotEmpty)
                CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                  items: unit.imageUrls
                      .map(
                        (url) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              AppImages.placeHolder,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            )
                            //  Image.network(
                            //   url,
                            //   width: double.infinity,
                            //   fit: BoxFit.cover,
                            // ),
                            ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Unit Details',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                      fontSize: Dimensions.fontSizeExtraLarge),
                ),
                const Divider(),
                const SizedBox(height: 8),
                Text('Space: ${unit.space} m²',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                        fontSize: Dimensions.fontSizeDefault)),
                Text('Rooms: ${unit.roomNo}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                        fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(height: 16),
                Text(
                  'Details:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                      fontSize: Dimensions.fontSizeExtraLarge),
                ),
                Text(unit.details,
                    style: TextStyle(
                        color: AppColors.primaryTextColor,
                        fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(height: 16),
                Text('Pricing',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                        fontSize: Dimensions.fontSizeExtraLarge)),
                const Divider(),
                Text('Price Per Month: \$${unit.pricePerMonth}',
                    style: TextStyle(
                        color: AppColors.primaryTextColor,
                        fontSize: Dimensions.fontSizeDefault)),
                Text('Price Per Year: \$${unit.pricePerYear}',
                    style: TextStyle(
                        color: AppColors.primaryTextColor,
                        fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(height: 16),
                Container(
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
                    onPressed: () {
                      // Action when clicked
                    },
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
                    child: const Text(
                      'Contact for More Info',
                      style: TextStyle(color: AppColors.whiteTextColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
