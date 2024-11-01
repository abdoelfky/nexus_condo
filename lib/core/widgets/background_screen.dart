import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_images.dart';


class BackgroundScreen extends ConsumerStatefulWidget {
  final Widget child;
  String imgSrc;

  BackgroundScreen({super.key, required this.child,
    this.imgSrc=AppImages.background });

  @override
  ConsumerState<BackgroundScreen> createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends ConsumerState<BackgroundScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            widget.imgSrc, // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        // Content on top of the background

        Positioned.fill(
          child: widget.child,
        ),

      ],

    );
  }
}
