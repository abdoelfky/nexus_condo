import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/constants/app_images.dart';
import 'package:nexus_condo/core/shared_preferences/shared_preferences.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/auth/controllers/auth_provider.dart';
import 'package:nexus_condo/features/info/info_screen.dart';
import 'package:nexus_condo/features/settings/settings.dart';
import 'package:url_launcher/url_launcher.dart';

String? instagram;
String? facebook;
String? whatsApp;

class ProfileScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PrimaryAppBar(
        title: 'Profile',
      ),
      body: BackgroundScreen(
        child: Stack(
          children: [
            // Profile header
            SizedBox(
              height: Dimensions.imgHeightDefault,
              child: profileHeader(context),
            ),
            // Scrollable content
            Positioned.fill(
              top: Dimensions.profileTileDefault,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Group 1 (No spacing between tiles)
                    buildListTile("Account Settings", Icons.settings, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SettingsScreen()));
                    }),
                    buildListTile("Terms and Conditions", Icons.description, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InfoScreen(
                              data: 'conditions', title: 'Terms and Conditions'),
                        ),
                      );
                    }),

                    // Add spacing only after the first group
                    SizedBox(height: 20),

                    // Group 2 (No spacing between tiles)
                    buildListTile("Privacy Policy", Icons.privacy_tip, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InfoScreen(data: 'faq', title: 'Privacy Policy'),
                        ),
                      );
                    }),
                    buildListTile("About Us", Icons.info, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InfoScreen(data: 'aboutUs', title: 'About Us'),
                        ),
                      );
                    }),

                    // Add spacing only after the second group
                    SizedBox(height: 20),

                    // Group 3 (No spacing between tiles)
                    buildListTile("Stay in Touch", Icons.contact_mail, () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildBottomSheet(context);
                        },
                      );
                    }),
                    buildListTile("Log Out", Icons.exit_to_app, () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            elevation: 24.0,
                            title: Center(
                              child: Text(
                                'Are you sure?',
                                style: TextStyle(fontSize: 22, color: Colors.black),
                              ),
                            ),
                            content: Text(
                              'You will be logged out from your account.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(fontSize: 16, color: Colors.red),
                                ),
                                onPressed: () {
                                  ref
                                      .read(firebaseAuthServiceProvider)
                                      .signOut(context);
                                },
                              ),
                              CupertinoDialogAction(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ));
                    }),

                    // Add bottom padding to ensure the last item is fully visible
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget profileHeader(BuildContext context) {
  return Stack(
    children: [
      Stack(
        children: [
          Image.asset(
            AppImages.profile, // Replace with the image path
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            // Black layer with 50% opacity
            width: double.infinity,
            height: double.infinity,
          ),
        ],
      ),
      Positioned(
        right: 0,
        left: 0,
        top: Dimensions.paddingSizeSmall,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.whiteColor,
              backgroundImage: AssetImage(AppImages.user),
            ),
            SizedBox(height: 10),
            Text(
              AppSettingsPreferences().name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.whiteColor),
            ),
            AppSettingsPreferences().user().unitNo == null
                ? Text(
                    'Unite Number${AppSettingsPreferences().user().unitNo}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 14,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 20),
          ],
        ),
      ),
    ],
  );
}

Widget buildListTile(String title, IconData icon, VoidCallback onTapHandler) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 7),
    child: Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(10)),
      ),
      elevation: 5.0,
      child: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              icon,
              size: 20, // Adjust the size of the icon as needed
              color: AppColors.primaryColor, // Adjust icon color if needed
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16, // Size of the arrow icon
            ),
            onTap: onTapHandler,
          ),
        ),
      ),
    ),
  );
}

Widget _buildBottomSheet(BuildContext context) {
  return SizedBox(
    height: 200.0,
    child: GridView.count(
      crossAxisCount: 3,
      children: List.generate(apps.length, (index) {
        return GestureDetector(
          onTap: () {
            _launchApp(context, apps[index]['package']);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      apps[index]['image'],
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                apps[index]['name'],
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      }),
    ),
  );
}

void _launchApp(BuildContext context, String packageName) async {
  final url = packageName;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cannot open $packageName')),
    );
  }
}

List<Map<String, dynamic>> apps = [
  {
    'name': 'Instagram',
    'image': AppImages.instagramIcon,
    'package': instagram ?? ''
  },
  {
    'name': 'Facebook',
    'image': AppImages.facebookIcon,
    'package': facebook ?? ''
  },
  {
    'name': 'WhatsApp',
    'image': AppImages.whatsappIcon,
    'package': whatsApp ?? ''
  },
];
