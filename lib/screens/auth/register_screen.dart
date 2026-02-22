import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_constants.dart';
import '../../data/mock_data.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _adminCodeController = TextEditingController();
  final _licenseController = TextEditingController();
  final _authService = AuthService();
  final _userService = UserService();

  String _selectedRole = 'patient';
  String? _selectedSpecialty;
  String? _selectedHospital;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  static const String _adminCode = 'MEDIBOOK2024';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _adminCodeController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate admin code
    if (_selectedRole == 'admin') {
      if (_adminCodeController.text.trim() != _adminCode) {
        _showError('Invalid admin code');
        return;
      }
    }

    // Validate doctor fields
    if (_selectedRole == 'doctor') {
      if (_selectedSpecialty == null) {
        _showError('Please select your specialty');
        return;
      }
      if (_selectedHospital == null) {
        _showError('Please select your hospital');
        return;
      }
    }

    setState(() => _isLoading = true);
    try {
      final firebaseUser = await _authService.registerWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (firebaseUser != null) {
        // Create user profile in Firestore
        final user = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? _emailController.text.trim(),
          role: _selectedRole,
          fullName: _fullNameController.text.trim().isEmpty
              ? null
              : _fullNameController.text.trim(),
          specialty: _selectedRole == 'doctor' ? _selectedSpecialty : null,
          hospital: _selectedRole == 'doctor' ? _selectedHospital : null,
          licenseNumber: _selectedRole == 'doctor'
              ? _licenseController.text.trim().isEmpty
                  ? null
                  : _licenseController.text.trim()
              : null,
        );
        await _userService.createOrUpdateUser(user);

        if (mounted) {
          final route = switch (_selectedRole) {
            'doctor' => AppRoutes.doctorDashboard,
            'admin' => AppRoutes.adminDashboard,
            _ => AppRoutes.dashboard,
          };
          Navigator.pushReplacementNamed(context, route);
        }
      }
    } on Exception catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.paddingSM),
                Text('Create Account', style: AppTextStyles.heading1),
                const SizedBox(height: 8),
                Text('Fill in your details to get started.',
                    style: AppTextStyles.bodyMedium),
                const SizedBox(height: AppConstants.paddingLG),

                // Role Selector
                Text('I am a', style: AppTextStyles.label),
                const SizedBox(height: 8),
                _buildRoleSelector(),
                const SizedBox(height: AppConstants.paddingMD),

                // Full Name
                AppTextField(
                  label: 'Full Name',
                  controller: _fullNameController,
                  validator: Validators.requiredField,
                  prefixIcon: const Icon(CupertinoIcons.person),
                ),
                const SizedBox(height: AppConstants.paddingMD),

                // Email
                AppTextField(
                  label: AppStrings.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  prefixIcon: const Icon(CupertinoIcons.mail),
                ),
                const SizedBox(height: AppConstants.paddingMD),

                // Doctor-specific fields
                if (_selectedRole == 'doctor') ...[
                  DropdownButtonFormField<String>(
                    value: _selectedSpecialty,
                    hint: const Text('Select Specialty'),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.heart),
                      labelText: 'Specialty',
                    ),
                    items: MockData.specialties
                        .map((s) =>
                            DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    validator: (val) =>
                        val == null ? 'Please select a specialty' : null,
                    onChanged: (val) =>
                        setState(() => _selectedSpecialty = val),
                  ),
                  const SizedBox(height: AppConstants.paddingMD),
                  DropdownButtonFormField<String>(
                    value: _selectedHospital,
                    hint: const Text('Select Hospital'),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.building_2_fill),
                      labelText: 'Hospital',
                    ),
                    items: MockData.hospitals
                        .map((h) =>
                            DropdownMenuItem(value: h, child: Text(h)))
                        .toList(),
                    validator: (val) =>
                        val == null ? 'Please select a hospital' : null,
                    onChanged: (val) =>
                        setState(() => _selectedHospital = val),
                  ),
                  const SizedBox(height: AppConstants.paddingMD),
                  AppTextField(
                    label: 'License Number (Optional)',
                    controller: _licenseController,
                    prefixIcon: const Icon(CupertinoIcons.creditcard),
                  ),
                  const SizedBox(height: AppConstants.paddingMD),
                ],

                // Admin code field
                if (_selectedRole == 'admin') ...[
                  AppTextField(
                    label: 'Admin Access Code',
                    controller: _adminCodeController,
                    validator: Validators.requiredField,
                    prefixIcon: const Icon(CupertinoIcons.shield_fill),
                    obscureText: true,
                  ),
                  const SizedBox(height: AppConstants.paddingMD),
                ],

                // Password
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
                const SizedBox(height: AppConstants.paddingMD),
                AppTextField(
                  label: AppStrings.confirmPassword,
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  validator: (val) => Validators.confirmPassword(
                      val, _passwordController.text),
                  prefixIcon: const Icon(CupertinoIcons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),

                const SizedBox(height: AppConstants.paddingXL),
                PrimaryButton(
                  label: AppStrings.signUp,
                  onPressed: _register,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppConstants.paddingMD),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.alreadyHaveAccount,
                          style: AppTextStyles.bodyMedium),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(AppStrings.signIn,
                            style: AppTextStyles.linkText),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLG),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      children: [
        _RoleChip(
          icon: CupertinoIcons.person,
          label: 'Patient',
          isSelected: _selectedRole == 'patient',
          onTap: () => setState(() => _selectedRole = 'patient'),
        ),
        const SizedBox(width: 10),
        _RoleChip(
          icon: CupertinoIcons.heart,
          label: 'Doctor',
          isSelected: _selectedRole == 'doctor',
          onTap: () => setState(() => _selectedRole = 'doctor'),
        ),
        const SizedBox(width: 10),
        _RoleChip(
          icon: CupertinoIcons.shield_fill,
          label: 'Admin',
          isSelected: _selectedRole == 'admin',
          onTap: () => setState(() => _selectedRole = 'admin'),
        ),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.inputBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 26),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
