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

class DoctorProfileSettingsScreen extends StatelessWidget {
  const DoctorProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final userService = UserService();
    final authService = AuthService();

    if (firebaseUser == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    return Scaffold(
      appBar: const MediAppBar.inner(
        title: 'My Profile',
      ),
      body: StreamBuilder<UserModel?>(
        stream: userService.getUserStream(firebaseUser.uid),
        builder: (context, snapshot) {
          final user = snapshot.data;
          final displayName = user?.fullName ?? 'Doctor';
          final email = firebaseUser.email ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : 'D',
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.primary,
                            fontSize: 36,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Dr. $displayName',
                          style: AppTextStyles.heading2),
                      const SizedBox(height: 4),
                      Text(email, style: AppTextStyles.bodyMedium),
                      if (user?.specialty != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user!.specialty!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Info Card
                Card(
                  child: Column(
                    children: [
                      if (user?.hospital != null)
                        ListTile(
                          leading: const Icon(CupertinoIcons.building_2_fill,
                              color: AppColors.primary),
                          title: Text('Hospital',
                              style: AppTextStyles.caption),
                          subtitle: Text(user!.hospital!,
                              style: AppTextStyles.label),
                        ),
                      if (user?.licenseNumber != null) ...[
                        const Divider(height: 1, indent: 56),
                        ListTile(
                          leading: const Icon(CupertinoIcons.creditcard,
                              color: AppColors.primary),
                          title: Text('License',
                              style: AppTextStyles.caption),
                          subtitle: Text(user!.licenseNumber!,
                              style: AppTextStyles.label),
                        ),
                      ],
                      if (user?.phone != null) ...[
                        const Divider(height: 1, indent: 56),
                        ListTile(
                          leading: const Icon(CupertinoIcons.phone,
                              color: AppColors.primary),
                          title:
                              Text('Phone', style: AppTextStyles.caption),
                          subtitle: Text(user!.phone!,
                              style: AppTextStyles.label),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Edit Profile
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.editProfile),
                    icon: const Icon(CupertinoIcons.pencil),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Settings
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(CupertinoIcons.info,
                            color: AppColors.textSecondary),
                        title: Text('About MediBook',
                            style: AppTextStyles.label),
                        trailing: const Icon(CupertinoIcons.chevron_right,
                            color: AppColors.textSecondary),
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(CupertinoIcons.question_circle,
                            color: AppColors.textSecondary),
                        title: Text('Help & Support',
                            style: AppTextStyles.label),
                        trailing: const Icon(CupertinoIcons.chevron_right,
                            color: AppColors.textSecondary),
                        onTap: () {},
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
          );
        },
      ),
    );
  }
}
