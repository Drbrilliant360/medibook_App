import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/medi_app_bar.dart';
import '../../widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _userService = UserService();

  String? _selectedGender;
  String? _selectedBloodGroup;
  bool _isLoading = false;
  bool _dataLoaded = false;

  static const _genders = ['Male', 'Female', 'Other'];
  static const _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final user = await _userService.getUser(uid);
    if (user != null && mounted) {
      setState(() {
        _nameController.text = user.fullName ?? '';
        _phoneController.text = user.phone ?? '';
        _dobController.text = user.dateOfBirth ?? '';
        _addressController.text = user.address ?? '';
        _selectedGender = user.gender;
        _selectedBloodGroup = user.bloodGroup;
        _dataLoaded = true;
      });
    } else {
      setState(() => _dataLoaded = true);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser!;
      final user = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        fullName: _nameController.text.trim().isEmpty
            ? null
            : _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        dateOfBirth: _dobController.text.trim().isEmpty
            ? null
            : _dobController.text.trim(),
        gender: _selectedGender,
        bloodGroup: _selectedBloodGroup,
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
      );
      await _userService.createOrUpdateUser(user);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MediAppBar.inner(title: 'Edit Profile'),
      body: !_dataLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personal Information',
                        style: AppTextStyles.heading3),
                    const SizedBox(height: 16),

                    AppTextField(
                      label: 'Full Name',
                      controller: _nameController,
                      prefixIcon: const Icon(CupertinoIcons.person),
                    ),
                    const SizedBox(height: 16),

                    AppTextField(
                      label: 'Phone Number',
                      hint: '+255 xxx xxx xxx',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(CupertinoIcons.phone),
                    ),
                    const SizedBox(height: 16),

                    AppTextField(
                      label: 'Date of Birth',
                      hint: 'DD/MM/YYYY',
                      controller: _dobController,
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(1990),
                          firstDate: DateTime(1930),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _dobController.text =
                              '${picked.day.toString().padLeft(2, '0')}/'
                              '${picked.month.toString().padLeft(2, '0')}/'
                              '${picked.year}';
                        }
                      },
                      prefixIcon: const Icon(CupertinoIcons.gift),
                      suffixIcon:
                          const Icon(CupertinoIcons.chevron_down),
                    ),
                    const SizedBox(height: 16),

                    // Gender
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      hint: const Text('Select Gender'),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(CupertinoIcons.person),
                        labelText: 'Gender',
                      ),
                      items: _genders
                          .map((g) =>
                              DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedGender = val),
                    ),
                    const SizedBox(height: 16),

                    // Blood Group
                    DropdownButtonFormField<String>(
                      value: _selectedBloodGroup,
                      hint: const Text('Select Blood Group'),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(CupertinoIcons.drop),
                        labelText: 'Blood Group',
                      ),
                      items: _bloodGroups
                          .map((b) =>
                              DropdownMenuItem(value: b, child: Text(b)))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedBloodGroup = val),
                    ),
                    const SizedBox(height: 16),

                    AppTextField(
                      label: 'Address',
                      hint: 'City, Region',
                      controller: _addressController,
                      prefixIcon:
                          const Icon(CupertinoIcons.location),
                    ),

                    const SizedBox(height: 32),

                    PrimaryButton(
                      label: 'Save Profile',
                      onPressed: _save,
                      isLoading: _isLoading,
                      icon: const Icon(CupertinoIcons.checkmark,
                          color: Colors.white),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
