import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_images.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';

class CarouselBanner extends StatelessWidget {
  final List<String> bannerImages = [
    AppImages.bannerImg1,
    AppImages.bannerImg2,
    AppImages.bannerImg3,
  ];

  CarouselBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: bannerImages.map((imagePath) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          child: Image.asset(
            imagePath,
            fit: BoxFit.fill,
            width: double.infinity,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: Dimensions.imgHeightDefault, // Set the height of the carousel
        autoPlay: true,                     // Enable auto-scrolling
        autoPlayInterval: const Duration(seconds: 3), // Scroll interval
        viewportFraction: 1.0,              // Show one image at a time
        enlargeCenterPage: true,            // Add a slight zoom effect
      ),
    );
  }
}
