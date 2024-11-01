import 'package:flutter/material.dart';
import 'package:nexus_condo/features/auth/services/auth_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Import for loading animation
import 'widgets/CustomButton.dart';
import 'widgets/CustomTextFormField.dart';
import 'widgets/HeaderText.dart';
import 'widgets/passwordField.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final AuthService authService;

  const LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.authService,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _showPasswordField = false;
  bool _obscurePassword = true;
  bool _isLoading = false; // Loading state variable

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          HeaderText('Sign In'),
          const SizedBox(height: 40),
          CustomTextFormField(
            controller: widget.emailController,
            label: 'Email',
            prefixIcon: Icons.email,
            validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
          ),
          const SizedBox(height: 16),
          if (_showPasswordField)
            PasswordField(
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              onVisibilityToggle: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          if (_showPasswordField) const SizedBox(height: 16),
          _isLoading // Show loading animation if logging in
              ? LoadingAnimationWidget.twistingDots(
            leftDotColor: const Color(0xFF1A1A3F),
            rightDotColor: const Color(0xFFEA3799),
            size: 30,
          )
              : CustomButton(
            text: _showPasswordField ? 'Login' : 'Next',
            onPressed: () {
              if (widget.formKey.currentState?.validate() ?? false) {
                if (!_showPasswordField) {
                  setState(() => _showPasswordField = true);
                } else {
                  setState(() {
                    _isLoading = true; // Set loading state to true
                  });
                  widget.authService.handleLogin(
                    context,
                    widget.emailController.text.trim(),
                    widget.passwordController.text,
                  ).then((_) {
                    // Handle successful login
                    setState(() {
                      _isLoading = false; // Reset loading state
                    });
                  }).catchError((error) {
                    // Handle error here
                    setState(() {
                      _isLoading = false; // Reset loading state on error
                    });
                    // Show a snack bar or dialog for the error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed: $error')),
                    );
                  });
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
