import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/appointment_model.dart';
import '../../models/user_model.dart';
import '../../services/appointment_service.dart';
import '../../services/user_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/medi_app_bar.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final userService = UserService();
    final appointmentService = AppointmentService();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const MediAppBar(
          title: 'Appointments',
          style: MediAppBarStyle.primary,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Confirmed'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: FutureBuilder<UserModel?>(
          future: userService.getUser(uid),
          builder: (context, userSnap) {
            if (!userSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final doctorName = 'Dr. ${userSnap.data?.fullName ?? ''}';

            return StreamBuilder<List<AppointmentModel>>(
              stream: appointmentService
                  .getDoctorAppointmentsStream(doctorName),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final all = snap.data ?? [];
                final pending =
                    all.where((a) => a.status == 'pending').toList();
                final confirmed =
                    all.where((a) => a.status == 'confirmed').toList();
                final completed =
                    all.where((a) => a.status == 'completed').toList();
                final cancelled =
                    all.where((a) => a.status == 'cancelled').toList();

                return TabBarView(
                  children: [
                    _buildList(context, pending, 'No pending appointments',
                        appointmentService),
                    _buildList(context, confirmed,
                        'No confirmed appointments', appointmentService),
                    _buildList(context, completed,
                        'No completed appointments', appointmentService),
                    _buildList(context, cancelled,
                        'No cancelled appointments', appointmentService),
                  ],
                );
              },
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
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                appt.patientName.isNotEmpty
                    ? appt.patientName[0].toUpperCase()
                    : 'P',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            title: Text(appt.patientName, style: AppTextStyles.label),
            subtitle: Text(
              '${DateFormatter.display(appt.date)}${appt.timeSlot != null ? ' | ${appt.timeSlot}' : ''}',
              style: AppTextStyles.caption,
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                if (appt.id != null) {
                  await service.updateStatus(appt.id!, value);
                }
              },
              itemBuilder: (context) {
                final items = <PopupMenuEntry<String>>[];
                if (appt.status == 'pending') {
                  items.add(const PopupMenuItem(
                      value: 'confirmed', child: Text('Confirm')));
                }
                if (appt.status == 'confirmed') {
                  items.add(const PopupMenuItem(
                      value: 'completed', child: Text('Mark Complete')));
                }
                if (appt.status != 'cancelled' &&
                    appt.status != 'completed') {
                  items.add(const PopupMenuItem(
                      value: 'cancelled', child: Text('Cancel')));
                }
                return items;
              },
              child: Container(
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
            ),
          ),
        );
      },
    );
  }
}
