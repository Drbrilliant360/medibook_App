import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_routes.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/medi_app_bar.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final userService = UserService();
    final authService = AuthService();

    return Scaffold(
      appBar: const MediAppBar.inner(
        title: 'Settings',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Admin Info
            StreamBuilder<UserModel?>(
              stream: userService
                  .getUserStream(firebaseUser?.uid ?? ''),
              builder: (context, snap) {
                final user = snap.data;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                          CupertinoIcons.shield_fill,
                          color: AppColors.primary),
                    ),
                    title: Text(
                      user?.fullName ?? 'Admin',
                      style: AppTextStyles.label,
                    ),
                    subtitle: Text(
                      firebaseUser?.email ?? '',
                      style: AppTextStyles.caption,
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ADMIN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Settings Options
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(CupertinoIcons.person_2,
                        color: AppColors.textSecondary),
                    title:
                        Text('Manage Users', style: AppTextStyles.label),
                    trailing: const Icon(CupertinoIcons.chevron_right,
                        color: AppColors.textSecondary),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(CupertinoIcons.chart_bar,
                        color: AppColors.textSecondary),
                    title:
                        Text('Reports', style: AppTextStyles.label),
                    trailing: const Icon(CupertinoIcons.chevron_right,
                        color: AppColors.textSecondary),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(
                        CupertinoIcons.bell,
                        color: AppColors.textSecondary),
                    title: Text('Notification Settings',
                        style: AppTextStyles.label),
                    trailing: const Icon(CupertinoIcons.chevron_right,
                        color: AppColors.textSecondary),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(CupertinoIcons.info,
                        color: AppColors.textSecondary),
                    title: Text('About MediBook',
                        style: AppTextStyles.label),
                    trailing: const Icon(CupertinoIcons.chevron_right,
                        color: AppColors.textSecondary),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'MediBook',
                        applicationVersion: '1.0.0',
                        applicationIcon: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                              CupertinoIcons.building_2_fill,
                              color: Colors.white,
                              size: 28),
                        ),
                        children: [
                          const Text(
                            'MediBook Admin Panel. Manage doctors, '
                            'monitor appointments, and oversee the platform.',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text(
                          'Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await authService.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.login);
                    }
                  }
                },
                icon: const Icon(CupertinoIcons.square_arrow_right),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
