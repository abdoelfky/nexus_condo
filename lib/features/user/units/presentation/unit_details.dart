import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/constants/app_images.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/features/admin/units/data/unit.dart';

class UserUnitDetailsScreen extends StatelessWidget {
  final Unit unit;

  const UserUnitDetailsScreen({super.key, required this.unit});

  // Method to open WhatsApp
  void _contactForMoreInfo() async {
    final message =
        "Hello, I'm interested in Unit ${unit.unitNo}. Could you provide more information?";
    final url = "https://wa.me/<YOUR_PHONE_NUMBER>?text=$message";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch WhatsApp";
    }
  }

  // Method to send rent request to Firebase
  Future<void> _sendRentRequest(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You need to log in to send a request")),
      );
      return;
    }

    final request = {
      'unitId': unit.id,
      'unitNo': unit.unitNo,
      'userId': user.uid,
      'userEmail': user.email,
      'requestDate': DateTime.now().toIso8601String(),
      'status': 'Pending', // Default status
    };

    try {
      await FirebaseFirestore.instance.collection('rent_requests').add(request);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rent request sent successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending request: $e")),
      );
    }
  }

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
                // Image Carousel
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
                      child: Image.asset(AppImages.placeHolder),
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 16),
                // Unit Details
                Text(
                  'Unit Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                    fontSize: Dimensions.fontSizeExtraLarge,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Space: ${unit.space} m²',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                Text(
                  'Rooms: ${unit.roomNo}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Details:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                    fontSize: Dimensions.fontSizeExtraLarge,
                  ),
                ),
                Text(
                  unit.details,
                  style: TextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pricing',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                    fontSize: Dimensions.fontSizeExtraLarge,
                  ),
                ),
                const Divider(),
                Text(
                  'Price Per Month: \$${unit.pricePerMonth}',
                  style: TextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                Text(
                  'Price Per Year: \$${unit.pricePerYear}',
                  style: TextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Contact for More Info Button
                    Container(
                      width: Dimensions.buttonWidthDefault,
                      decoration: BoxDecoration(
                        color: AppColors.nexusGreen,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.nexusShadowGreen,
                            offset: Offset(0, 5),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _contactForMoreInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Contact for More Info',
                          style: TextStyle(
                            color: AppColors.whiteTextColor,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Rent Request Button
                    Container(
                      width: Dimensions.buttonWidthDefault - 30,
                      decoration: BoxDecoration(
                        color: AppColors.nexusGreen,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.nexusShadowGreen,
                            offset: Offset(0, 5),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _sendRentRequest(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Rent Request',
                          style: TextStyle(
                            color: AppColors.whiteTextColor,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
