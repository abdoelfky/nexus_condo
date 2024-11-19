import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_constants.dart';
import 'package:nexus_condo/core/widgets/LogoDisplay.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/features/auth/controllers/timer.dart';
import 'package:nexus_condo/features/auth/services/auth_service.dart';
import '../controllers/toggle_index_notifier.dart';
import 'forget_password_form.dart';
import 'login_form.dart';
import 'widgets/AuthToggleButtons.dart';
import 'widgets/BlurredContainer.dart';

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final authService = AuthService(ref);
    final selectedIndex = ref.watch(toggleIndexProvider);
    final countdown = ref.watch(timerProvider);

    return Scaffold(
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Column(
            children: [
              LogoDisplay(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingVertical),
                child: BlurredContainer(
                  child: selectedIndex == 0
                      ? LoginForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    formKey: _formKey,
                    authService: authService,
                  )
                      : ForgotPasswordForm(
                    emailController: _emailController,
                    formKey: _formKey,
                    authService: authService,
                    countdown: countdown,
                  ),
                ),
              ),
              AuthToggleButtons(selectedIndex: selectedIndex, ref: ref),
            ],
          ),
        ),
      ),
    );
  }
}
