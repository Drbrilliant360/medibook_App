import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/medi_app_bar.dart';

class AdminDoctorsScreen extends StatelessWidget {
  const AdminDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return Scaffold(
      appBar: const MediAppBar.inner(
        title: 'Manage Doctors',
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: userService.getUsersByRoleStream('doctor'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final doctors = snapshot.data ?? [];

          if (doctors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.heart,
                      size: 64,
                      color: AppColors.textSecondary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('No registered doctors',
                      style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  Text('Doctors will appear here when they register',
                      style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      doctor.fullName?.isNotEmpty == true
                          ? doctor.fullName![0].toUpperCase()
                          : 'D',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  title: Text(
                    'Dr. ${doctor.fullName ?? 'Unknown'}',
                    style: AppTextStyles.label,
                  ),
                  subtitle: Text(
                    doctor.specialty ?? 'No specialty',
                    style: AppTextStyles.caption,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          _InfoRow(
                              label: 'Email', value: doctor.email),
                          if (doctor.hospital != null)
                            _InfoRow(
                                label: 'Hospital',
                                value: doctor.hospital!),
                          if (doctor.phone != null)
                            _InfoRow(
                                label: 'Phone', value: doctor.phone!),
                          if (doctor.licenseNumber != null)
                            _InfoRow(
                                label: 'License',
                                value: doctor.licenseNumber!),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _confirmRemove(context, doctor),
                                icon: const Icon(CupertinoIcons.trash,
                                    size: 18),
                                label: const Text('Remove'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: const BorderSide(
                                      color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmRemove(BuildContext context, UserModel doctor) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Doctor'),
        content: Text(
          'Are you sure you want to remove Dr. ${doctor.fullName ?? 'Unknown'}? '
          'This will delete their account data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await UserService().deleteUser(doctor.uid);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doctor removed'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: AppTextStyles.caption),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
