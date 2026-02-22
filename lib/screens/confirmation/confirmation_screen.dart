import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../models/appointment_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/primary_button.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointment =
        ModalRoute.of(context)!.settings.arguments as AppointmentModel;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLG),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(CupertinoIcons.checkmark_circle_fill,
                    size: 60, color: AppColors.success),
              ),
              const SizedBox(height: AppConstants.paddingLG),
              Text(AppStrings.bookingConfirmed,
                  style: AppTextStyles.heading1, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(AppStrings.bookingSuccess,
                  style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppConstants.paddingXL),

              // Details Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLG),
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: CupertinoIcons.person,
                        label: 'Patient',
                        value: appointment.patientName,
                      ),
                      const Divider(height: 24),
                      _DetailRow(
                        icon: CupertinoIcons.heart,
                        label: 'Doctor',
                        value: appointment.doctor,
                      ),
                      if (appointment.specialty != null) ...[
                        const Divider(height: 24),
                        _DetailRow(
                          icon: CupertinoIcons.building_2_fill,
                          label: 'Specialty',
                          value: appointment.specialty!,
                        ),
                      ],
                      const Divider(height: 24),
                      _DetailRow(
                        icon: CupertinoIcons.calendar,
                        label: 'Date',
                        value: DateFormatter.display(appointment.date),
                      ),
                      if (appointment.timeSlot != null) ...[
                        const Divider(height: 24),
                        _DetailRow(
                          icon: CupertinoIcons.clock,
                          label: 'Time',
                          value: appointment.timeSlot!,
                        ),
                      ],
                      const Divider(height: 24),
                      _DetailRow(
                        icon: appointment.appointmentType == 'online'
                            ? CupertinoIcons.video_camera
                            : CupertinoIcons.building_2_fill,
                        label: 'Type',
                        value: appointment.appointmentType == 'online'
                            ? 'Online Consultation'
                            : 'Physical Visit',
                      ),
                      const Divider(height: 24),
                      _DetailRow(
                        icon: CupertinoIcons.info,
                        label: 'Status',
                        value: appointment.status.toUpperCase(),
                        valueColor: AppColors.statusPending,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingXL),
              PrimaryButton(
                label: AppStrings.goToDashboard,
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
              ),
              const SizedBox(height: AppConstants.paddingSM),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.booking),
                child: const Text(AppStrings.bookAnother),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(value,
                style: AppTextStyles.label.copyWith(color: valueColor)),
          ],
        ),
      ],
    );
  }
}
