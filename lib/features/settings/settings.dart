import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/profile/profile_screen.dart';
import '../../core/widgets/background_screen.dart';
import '../auth/controllers/auth_provider.dart';
import 'change_password.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final bool isHomeStore;

  const SettingsScreen({super.key, this.isHomeStore = false});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PrimaryAppBar(
        title: 'Settings',
      ),
      body: BackgroundScreen(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              // buildListTile(
              //     // Colors.black,
              //     "تعديل بيانات الحساب",
              //     Icons.edit_outlined, () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (_) => EditProfileScreen(
              //                 isHomeStore: widget.isHomeStore,
              //               )));
              // }),
              buildListTile(
                  // Colors.black,
                  "Change password",
                  Icons.lock_outlined, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ChangePasswordScreen()));
              }),
              buildListTile(
                  // Colors.black,
                  "Delete my account",
                  Icons.delete_outline_outlined, () async {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          elevation: 24.0,
                          title: const Text(
                            'Are you sure',
                          ),
                          content: const Text('We can\'t recover your account again' ),
                          actions: [
                            CupertinoDialogAction(
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                setState(() {
                                  var user = FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    user.delete().then((value) async {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'account deleted successfully',
                                          ),
                                          backgroundColor: AppColors.successColor,
                                        ),
                                      );
                                      ref.read(firebaseAuthServiceProvider).signOut(context);

                                      // FbAuthController().signOut();
                                    }).catchError((onError) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'account delete failed: ${onError.toString()}')),
                                      );
                                    });
                                  }
                                });
                                Navigator.pop(context);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 15),
                              child: Container(
                                width: double.infinity,
                                height: 0.4,
                                color: Colors.grey,
                              ),
                            ),
                            CupertinoDialogAction(
                              child: Text('Cancel'),
                              onPressed: () {
                                setState(() {});
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
