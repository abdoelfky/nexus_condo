import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexus_condo/features/auth/controllers/timer.dart';
import 'package:nexus_condo/features/auth/services/auth_service.dart';
import 'widgets/CountdownText.dart';
import 'widgets/CustomButton.dart';
import 'widgets/CustomTextFormField.dart';
import 'widgets/HeaderText.dart';

class ForgotPasswordForm extends ConsumerStatefulWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final AuthService authService;
  final int? countdown;

  const ForgotPasswordForm({
    required this.emailController,
    required this.formKey,
    required this.authService,
    required this.countdown,
  });

  @override
  ConsumerState<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends ConsumerState<ForgotPasswordForm> {
  bool _isSent = false;
  bool _isLoading = false; // Add a loading state

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          HeaderText('Forgot Password'),
          const SizedBox(height: 40),
          CustomTextFormField(
            controller: widget.emailController,
            label: 'Email',
            prefixIcon: Icons.email,
            validator: (value) =>
            value!.isEmpty ? 'Please enter your email' : null,
          ),
          const SizedBox(height: 16),
          _isLoading // Show loading animation if in loading state
              ? LoadingAnimationWidget.twistingDots(
            leftDotColor: const Color(0xFF1A1A3F),
            rightDotColor: const Color(0xFFEA3799),
            size: 30,
          )
              : CustomButton(
            text: _isSent ? 'Resend' : 'Send OTP',
            onPressed: widget.countdown == null
                ? () {
              if (widget.formKey.currentState?.validate() ?? false) {
                setState(() {
                  _isLoading = true; // Set loading state to true
                });

                widget.authService.handleForgetPassword(
                    context, widget.emailController.text.trim()).then((onValue) {
                  ref.read(timerProvider.notifier).startTimer();
                  setState(() {
                    _isSent = true;
                    _isLoading = false; // Reset loading state
                  });
                }).catchError((error) {
                  // Handle any errors here
                  setState(() {
                    _isLoading = false; // Reset loading state on error
                  });
                  // Show a snack bar or dialog for the error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to send email: $error')),
                  );
                });
              }
            }
                : null,
          ),
          CountdownText(countdown: widget.countdown),
        ],
      ),
    );
  }
}
