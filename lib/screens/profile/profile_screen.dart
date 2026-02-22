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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final userService = UserService();
    final authService = AuthService();

    if (firebaseUser == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: const MediAppBar(
        title: 'Profile',
        style: MediAppBarStyle.primary,
      ),
      body: StreamBuilder<UserModel?>(
        stream: userService.getUserStream(firebaseUser.uid),
        builder: (context, snapshot) {
          final user = snapshot.data;
          final displayName =
              user?.fullName ?? firebaseUser.email?.split('@').first ?? 'User';
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
                              : 'U',
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.primary,
                            fontSize: 36,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(displayName, style: AppTextStyles.heading2),
                      const SizedBox(height: 4),
                      Text(email, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.editProfile,
                    ),
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

                const SizedBox(height: 24),

                // Info Cards
                if (user != null) ...[
                  _buildInfoCard([
                    if (user.phone != null)
                      _ProfileTile(
                        icon: CupertinoIcons.phone,
                        title: 'Phone',
                        subtitle: user.phone!,
                      ),
                    if (user.dateOfBirth != null)
                      _ProfileTile(
                        icon: CupertinoIcons.gift,
                        title: 'Date of Birth',
                        subtitle: user.dateOfBirth!,
                      ),
                    if (user.gender != null)
                      _ProfileTile(
                        icon: CupertinoIcons.person,
                        title: 'Gender',
                        subtitle: user.gender!,
                      ),
                    if (user.bloodGroup != null)
                      _ProfileTile(
                        icon: CupertinoIcons.drop,
                        title: 'Blood Group',
                        subtitle: user.bloodGroup!,
                      ),
                    if (user.address != null)
                      _ProfileTile(
                        icon: CupertinoIcons.location,
                        title: 'Address',
                        subtitle: user.address!,
                      ),
                  ]),
                  const SizedBox(height: 16),
                ],

                // Settings Section
                Card(
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: CupertinoIcons.bell,
                        title: 'Notifications',
                        trailing: Switch(
                          value: true,
                          onChanged: (_) {},
                          activeColor: AppColors.primary,
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      _SettingsTile(
                        icon: CupertinoIcons.lock,
                        title: 'Privacy Policy',
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56),
                      _SettingsTile(
                        icon: CupertinoIcons.info,
                        title: 'About MediBook',
                        onTap: () => _showAbout(context),
                      ),
                      const Divider(height: 1, indent: 56),
                      _SettingsTile(
                        icon: CupertinoIcons.question_circle,
                        title: 'Help & Support',
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

  Widget _buildInfoCard(List<Widget> tiles) {
    final validTiles = tiles.where((t) => t is _ProfileTile).toList();
    if (validTiles.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Column(
        children: [
          for (int i = 0; i < validTiles.length; i++) ...[
            validTiles[i],
            if (i < validTiles.length - 1)
              const Divider(height: 1, indent: 56),
          ],
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
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
        child: const Icon(CupertinoIcons.building_2_fill,
            color: Colors.white, size: 28),
      ),
      children: [
        const Text(
          'MediBook is a doctor booking application designed for Tanzania. '
          'Find doctors, book appointments, and manage your healthcare easily.',
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.caption),
      subtitle: Text(subtitle, style: AppTextStyles.label),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title, style: AppTextStyles.label),
      trailing: trailing ??
          const Icon(CupertinoIcons.chevron_right,
              color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
