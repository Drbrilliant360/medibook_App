import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../utils/date_formatter.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;

  const AppointmentCard({super.key, required this.appointment, this.onTap});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.statusConfirmed;
      case 'cancelled':
        return AppColors.statusCancelled;
      default:
        return AppColors.statusPending;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return CupertinoIcons.checkmark_circle_fill;
      case 'cancelled':
        return CupertinoIcons.xmark_circle_fill;
      default:
        return CupertinoIcons.clock;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(appointment.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(CupertinoIcons.person, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appointment.doctor, style: AppTextStyles.heading3),
                        const SizedBox(height: 2),
                        if (appointment.specialty != null)
                          Text(appointment.specialty!, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon(appointment.status),
                            size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          appointment.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(CupertinoIcons.calendar,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    DateFormatter.display(appointment.date),
                    style: AppTextStyles.bodyMedium,
                  ),
                  if (appointment.timeSlot != null) ...[
                    const SizedBox(width: 16),
                    const Icon(CupertinoIcons.clock,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(appointment.timeSlot!, style: AppTextStyles.bodyMedium),
                  ],
                ],
              ),
              if (appointment.appointmentType == 'online')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.video_camera,
                          size: 16, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Text(
                        'Online Consultation',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
