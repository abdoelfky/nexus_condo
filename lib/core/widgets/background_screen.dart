import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/constants/app_images.dart';

class BackgroundScreen extends ConsumerStatefulWidget {
  final Widget child;
  // final String? imgSrc;
  final Color? backgroundColor;

  BackgroundScreen({
    super.key,
    required this.child,
    // this.imgSrc = AppImages.splashBackground, // Default background image
    this.backgroundColor = AppColors.backgroundColor,              // Optional background color
  });

  @override
  ConsumerState<BackgroundScreen> createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends ConsumerState<BackgroundScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Conditionally render background color or image
        if (widget.backgroundColor != null)
          Positioned.fill(
            child: Container(
              color: widget.backgroundColor, // Fill with the specified color
            ),
          ),
        // else if (widget.imgSrc != null)
        //   Positioned.fill(
        //     child: Image.asset(
        //       widget.imgSrc!, // Replace with the image path
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // Content on top of the background
        Positioned.fill(
          child: widget.child,
        ),
      ],
    );
  }
}
