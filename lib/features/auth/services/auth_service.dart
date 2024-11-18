import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_constants.dart';
import 'package:nexus_condo/core/shared_preferences/shared_preferences.dart';
import 'package:nexus_condo/features/admin/home/presentation/home_screen.dart';
import 'package:nexus_condo/features/auth/controllers/auth_provider.dart';
import 'package:nexus_condo/features/user/home/presentation/home_screen.dart';

class AuthService {
  final WidgetRef ref;

  AuthService(this.ref);

  Future<void> handleLogin(
      BuildContext context, String email, String password) async {
    final authService = ref.read(firebaseAuthServiceProvider);
    final success = await authService.signIn(
        context: context, email: email, password: password);
    if (success) {
      print(AppSettingsPreferences().userType.toLowerCase().toString());
      Future.delayed(Duration(milliseconds: 500), () {
        if (AppSettingsPreferences().userType.toLowerCase() == UserType.admin.value.toLowerCase()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AdminHomeScreen()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      });
    }
  }

  Future<void> handleForgetPassword(BuildContext context, String email) async {
    await ref
        .read(firebaseAuthServiceProvider)
        .resetPassword(context: context, email: email);
  }
}
