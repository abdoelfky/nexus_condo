import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/features/auth/controllers/auth_provider.dart';
import 'package:nexus_condo/features/home/presentation/home_screen.dart';

class AuthService {
  final WidgetRef ref;

  AuthService(this.ref);

  Future<void> handleLogin(BuildContext context, String email, String password) async {
    final authService = ref.read(firebaseAuthServiceProvider);
    final success = await authService.signIn(context: context, email: email, password: password);
    if (success) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  Future<void> handleForgetPassword(BuildContext context, String email) async {
    await ref.read(firebaseAuthServiceProvider).resetPassword(context: context, email: email);
  }
}
