import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/PrimaryButton.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/features/admin/home/presentation/widgets/custom_app_bar.dart';
import 'package:nexus_condo/features/auth/presentation/widgets/passwordField.dart';

import '../../core/widgets/primary_app_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmNewPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isObsecured1 = true;
  bool isObsecured2 = true;
  var state;
  bool _obscurePassword = true;

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    setState(() {
      state = 'loading';
    });
    var user = FirebaseAuth.instance.currentUser;
    String email = user!.email!;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: oldPassword,
      );

      user.updatePassword(newPassword).then((_) {
        print("Successfully changed password");
        setState(() {
          state = 'success';
        });
        setState(() {
          newPasswordController.text = '';
        });
        setState(() {
          oldPasswordController.text = '';
        });
        setState(() {
          confirmNewPasswordController.text = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('password changed successfully',),backgroundColor: AppColors.successColor,),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('password change failed: $error')),
        );

        print("Password can't be changed" + error.toString());

        setState(() {
          state = 'error';
        });
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      setState(() {
        state = 'error';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('password change failed: ${e.code.toString()}')),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      appBar: PrimaryAppBar(title: 'Settings'),
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Change Password',
                    style: TextStyle(
                      color: AppColors.primaryTextColor,
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: size.height * .07,
                  ),
                  PasswordField(
                    text: 'Old Password',
                    controller: oldPasswordController,
                    obscureText: _obscurePassword,
                    onVisibilityToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  PasswordField(
                    text: 'New Password',
                    controller: newPasswordController,
                    obscureText: _obscurePassword,
                    onVisibilityToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  ConditionalBuilder(
                    condition: state != 'loading',
                    builder: (context) => PrimaryButton(
                      text: 'Change Password',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          changePassword(
                              oldPassword: oldPasswordController.text,
                              newPassword: newPasswordController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('please enter password')),
                          );
                        }
                      },

                    ),
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Get.to(() => ResetPasswordScreen(),
                  //         transition: Transition.circularReveal);
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: 28),
                  //     child: Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         "هل نسيت كلمة السر؟",
                  //         style: TextStyle(
                  //           fontSize: 15,
                  //           color: Color(0XFF2D005D),
                  //         ),
                  //         textAlign: TextAlign.left,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
