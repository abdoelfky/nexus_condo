import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/constants/app_images.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/PrimaryButton.dart';
import 'package:nexus_condo/core/widgets/PrimaryLottie.dart';
import 'package:nexus_condo/core/widgets/PrimaryTextFormField.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/admin/add_user/controllers/add_user_controller.dart';
import 'package:nexus_condo/features/auth/presentation/widgets/passwordField.dart';

class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final signUpController = ref.read(addUserControllerProvider.notifier);

    try {
      await signUpController.addUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(), name: _nameController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: AppColors.successColor,
            content: Text('User added successfully')),

      );
      _emailController.clear();
      _passwordController.clear();
      _phoneController.clear();
      _nameController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: AppColors.errorColor, content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(addUserControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.appBarColor,
      appBar: const PrimaryAppBar(title: 'Add User'),
      body: BackgroundScreen(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const PrimaryLottie(
                  lottieAsset: AppLottie.loginAnimation,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraLarge,
                  ),
                  child: PrimaryTextFormField(
                    controller: _emailController,
                    label: 'Email',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter an email' : null,
                    prefixIcon: Icons.email,
                  ),
                ),
                SizedBox(height: Dimensions.fontSizeDefault),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraLarge,
                  ),
                  child: PasswordField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onVisibilityToggle: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                SizedBox(height: Dimensions.fontSizeDefault),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraLarge,
                  ),
                  child: PrimaryTextFormField(
                    controller: _phoneController,
                    label: 'Phone',
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a phone number'
                        : null,
                    prefixIcon: Icons.phone,
                  ),
                ),
                SizedBox(height: Dimensions.fontSizeDefault),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraLarge,
                  ),
                  child: PrimaryTextFormField(
                    controller: _nameController,
                    label: 'Name',
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a name'
                        : null,
                    prefixIcon: Icons.person_add_outlined,
                  ),
                ),
                SizedBox(height: Dimensions.fontSizeDefault),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraLarge,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButton(
                          text: 'Add User',
                          onPressed: _submit,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
