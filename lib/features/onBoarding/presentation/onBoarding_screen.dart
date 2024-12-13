import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/constants/app_images.dart';
import 'package:nexus_condo/core/shared_preferences/shared_preferences.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/features/splash/presentation/splash_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": AppImages.onBoarding1,
      "title": "Discover Your Perfect Dream House",
      "subtitle":
          "Lorem ipsum is simply dummy text of the printing and typesetting.",
    },
    {
      "image": AppImages.onBoarding2,
      "title": "Find Your Perfect Stay On A Budget",
      "subtitle":
          "Lorem ipsum is simply dummy text of the printing and typesetting.",
    },
    {
      "image": AppImages.onBoarding3,
      "title": "Book Real Estate Swiftly Just One Click",
      "subtitle":
          "Lorem ipsum is simply dummy text of the printing and typesetting.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  image: onboardingData[index]["image"]!,
                  title: onboardingData[index]["title"]!,
                  subtitle: onboardingData[index]["subtitle"]!,
                );
              },
            ),
          ),
          Container(color: AppColors.whiteColor, child: _buildBottomSection()),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () async {
              await _completeOnboarding();
            },
            child: Text(
              "Skip",
              style: TextStyle(color: AppColors.primaryTextColor),
            ),
          ),
          Row(
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppColors.primaryColor
                      : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (_currentIndex == onboardingData.length - 1) {
                await _completeOnboarding();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    await AppSettingsPreferences().setOnboarding(value: true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SplashScreen()));
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            children: [
              // Wrap the image with ClipRRect to make the bottom corners rounded
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40.0), // Adjust radius for bottom left
                  bottomRight: Radius.circular(40.0), // Adjust radius for bottom right
                ),
                child: Image.asset(
                  image, // Replace with the image path
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*.7,
                ),
              ),
              // Black overlay with 50% opacity
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40.0), // Adjust radius for bottom left
                  bottomRight: Radius.circular(40.0), // Adjust radius for bottom right
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*.7,
                ),
              ),
            ],
          ),
        ),
        // White background container for the bottom section
        Container(
          color: Colors.white, // White background
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: Dimensions.fontSizeSmall),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
