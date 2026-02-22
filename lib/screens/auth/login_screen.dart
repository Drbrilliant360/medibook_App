import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _userService = UserService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final firebaseUser = await _authService.loginWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (firebaseUser != null && mounted) {
        await _navigateByRole(firebaseUser.uid);
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateByRole(String uid) async {
    final user = await _userService.getUser(uid);
    if (!mounted) return;

    final route = switch (user?.role) {
      'doctor' => AppRoutes.doctorDashboard,
      'admin' => AppRoutes.adminDashboard,
      _ => AppRoutes.dashboard,
    };

    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.paddingXXL),
                Text(AppStrings.appName, style: AppTextStyles.heading1),
                const SizedBox(height: 8),
                Text(AppStrings.tagline, style: AppTextStyles.bodyMedium),
                const SizedBox(height: AppConstants.paddingXXL),
                AppTextField(
                  label: AppStrings.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  prefixIcon: const Icon(CupertinoIcons.mail),
                ),
                const SizedBox(height: AppConstants.paddingMD),
                AppTextField(
                  label: AppStrings.password,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: Validators.password,
                  prefixIcon: const Icon(CupertinoIcons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingXL),
                PrimaryButton(
                  label: AppStrings.signIn,
                  onPressed: _login,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppConstants.paddingMD),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.dontHaveAccount,
                          style: AppTextStyles.bodyMedium),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                        child: Text(AppStrings.signUp,
                            style: AppTextStyles.linkText),
                      ),
                    ],
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
