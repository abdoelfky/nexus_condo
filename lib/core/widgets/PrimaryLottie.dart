import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PrimaryLottie extends StatelessWidget {
  final lottieAsset;
  const PrimaryLottie({super.key,required this.lottieAsset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        lottieAsset,
        width: 200, // Optional: Control animation size
        height: 200,
        fit: BoxFit.fill, // Adjust how the animation fits the space
      ),
    );
  }
}
