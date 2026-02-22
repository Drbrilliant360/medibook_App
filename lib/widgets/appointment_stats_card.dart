import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class AppointmentStatsCard extends StatelessWidget {
  final List<AppointmentModel> appointments;

  const AppointmentStatsCard({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    final total = appointments.length;
    final pending =
        appointments.where((a) => a.status == 'pending').length;
    final confirmed =
        appointments.where((a) => a.status == 'confirmed').length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(label: 'Total', value: '$total', icon: CupertinoIcons.calendar),
          _Divider(),
          _StatItem(label: 'Pending', value: '$pending', icon: CupertinoIcons.clock),
          _Divider(),
          _StatItem(label: 'Confirmed', value: '$confirmed', icon: CupertinoIcons.checkmark_circle_fill),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(value,
            style: AppTextStyles.heading2.copyWith(color: Colors.white)),
        const SizedBox(height: 2),
        Text(label,
            style: AppTextStyles.caption.copyWith(color: Colors.white70)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.white24);
  }
}
