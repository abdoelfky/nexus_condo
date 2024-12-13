import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_constants.dart';
import 'package:nexus_condo/core/shared_preferences/shared_preferences.dart';
import 'package:nexus_condo/features/admin/home/presentation/dashboard.dart';
import 'package:nexus_condo/features/auth/controllers/auth_provider.dart';
import 'package:nexus_condo/features/user/home/presentation/dashboard.dart';

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
      if (AppSettingsPreferences().userType.toLowerCase() ==
          UserType.admin.value.toLowerCase()) {
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => AdminDashBoardScreen()));
        });
      } else {
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => UserDashBoardScreen()));
        });
      }
    }
  }

  Future<void> handleForgetPassword(BuildContext context, String email) async {
    await ref
        .read(firebaseAuthServiceProvider)
        .resetPassword(context: context, email: email);
  }
}
