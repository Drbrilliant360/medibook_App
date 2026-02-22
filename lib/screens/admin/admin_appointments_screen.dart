import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../services/appointment_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/medi_app_bar.dart';

class AdminAppointmentsScreen extends StatelessWidget {
  const AdminAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentService = AppointmentService();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const MediAppBar.inner(
          title: 'All Bookings',
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Confirmed'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: StreamBuilder<List<AppointmentModel>>(
          stream: appointmentService.getAllAppointmentsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final all = snapshot.data ?? [];
            final pending =
                all.where((a) => a.status == 'pending').toList();
            final confirmed =
                all.where((a) => a.status == 'confirmed').toList();
            final completed =
                all.where((a) => a.status == 'completed').toList();

            return TabBarView(
              children: [
                _buildList(context, all, 'No appointments',
                    appointmentService),
                _buildList(context, pending, 'No pending appointments',
                    appointmentService),
                _buildList(context, confirmed,
                    'No confirmed appointments', appointmentService),
                _buildList(context, completed,
                    'No completed appointments', appointmentService),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<AppointmentModel> appointments,
      String emptyMessage, AppointmentService service) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.calendar,
                size: 64, color: AppColors.textSecondary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(emptyMessage, style: AppTextStyles.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appt = appointments[index];
        final statusColor = switch (appt.status.toLowerCase()) {
          'confirmed' => AppColors.statusConfirmed,
          'cancelled' => AppColors.statusCancelled,
          'completed' => AppColors.info,
          _ => AppColors.statusPending,
        };

        return Card(
          margin:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appt.patientName,
                              style: AppTextStyles.label),
                          const SizedBox(height: 2),
                          Text(
                            appt.doctor,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        appt.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(CupertinoIcons.calendar,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(DateFormatter.display(appt.date),
                        style: AppTextStyles.caption),
                    if (appt.timeSlot != null) ...[
                      const SizedBox(width: 12),
                      const Icon(CupertinoIcons.clock,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(appt.timeSlot!, style: AppTextStyles.caption),
                    ],
                    if (appt.specialty != null) ...[
                      const SizedBox(width: 12),
                      Icon(CupertinoIcons.heart,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(appt.specialty!,
                          style: AppTextStyles.caption),
                    ],
                  ],
                ),
                // Admin action buttons
                if (appt.status != 'completed' &&
                    appt.status != 'cancelled') ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (appt.status == 'pending')
                        TextButton.icon(
                          onPressed: () async {
                            if (appt.id != null) {
                              await service.updateStatus(
                                  appt.id!, 'confirmed');
                            }
                          },
                          icon: const Icon(CupertinoIcons.checkmark,
                              size: 16),
                          label: const Text('Confirm',
                              style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.success,
                          ),
                        ),
                      TextButton.icon(
                        onPressed: () async {
                          if (appt.id != null) {
                            await service.updateStatus(
                                appt.id!, 'cancelled');
                          }
                        },
                        icon: const Icon(CupertinoIcons.xmark, size: 16),
                        label: const Text('Cancel',
                            style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
