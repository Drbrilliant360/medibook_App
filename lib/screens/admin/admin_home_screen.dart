import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../models/user_model.dart';
import '../../services/appointment_service.dart';
import '../../services/user_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/medi_app_bar.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentService = AppointmentService();
    final userService = UserService();

    return Scaffold(
      appBar: const MediAppBar(
        title: 'Admin Dashboard',
        style: MediAppBarStyle.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text('Overview', style: AppTextStyles.heading2),
            ),

            // Stats from streams
            StreamBuilder<List<AppointmentModel>>(
              stream: appointmentService.getAllAppointmentsStream(),
              builder: (context, apptSnap) {
                final allAppts = apptSnap.data ?? [];
                final pending =
                    allAppts.where((a) => a.status == 'pending').length;
                final confirmed =
                    allAppts.where((a) => a.status == 'confirmed').length;
                final completed =
                    allAppts.where((a) => a.status == 'completed').length;
                final cancelled =
                    allAppts.where((a) => a.status == 'cancelled').length;

                return Column(
                  children: [
                    // Appointments Stats
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Appointments',
                              style: AppTextStyles.heading3),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _AdminStatCard(
                                icon: CupertinoIcons.calendar,
                                label: 'Total',
                                value: '${allAppts.length}',
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              _AdminStatCard(
                                icon: CupertinoIcons.clock,
                                label: 'Pending',
                                value: '$pending',
                                color: AppColors.warning,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _AdminStatCard(
                                icon: CupertinoIcons.checkmark_circle_fill,
                                label: 'Confirmed',
                                value: '$confirmed',
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 12),
                              _AdminStatCard(
                                icon: CupertinoIcons.checkmark_seal_fill,
                                label: 'Completed',
                                value: '$completed',
                                color: AppColors.info,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _AdminStatCard(
                                icon: CupertinoIcons.xmark_circle_fill,
                                label: 'Cancelled',
                                value: '$cancelled',
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Recent appointments
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text('Recent Activity',
                          style: AppTextStyles.heading3),
                    ),

                    if (allAppts.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Text('No appointments yet',
                              style: AppTextStyles.bodyMedium),
                        ),
                      )
                    else
                      ...allAppts.take(10).map((a) => _RecentActivityTile(
                            appointment: a,
                          )),
                  ],
                );
              },
            ),

            // Users Stats
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Users', style: AppTextStyles.heading3),
            ),
            FutureBuilder<List<List<UserModel>>>(
              future: Future.wait([
                userService.getUsersByRole('patient'),
                userService.getUsersByRole('doctor'),
              ]),
              builder: (context, snap) {
                final patients = snap.data?[0].length ?? 0;
                final doctors = snap.data?[1].length ?? 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _AdminStatCard(
                        icon: CupertinoIcons.person_2,
                        label: 'Patients',
                        value: '$patients',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _AdminStatCard(
                        icon: CupertinoIcons.heart,
                        label: 'Doctors',
                        value: '$doctors',
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _AdminStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: AppTextStyles.heading2.copyWith(color: color)),
                Text(label, style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivityTile extends StatelessWidget {
  final AppointmentModel appointment;

  const _RecentActivityTile({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (appointment.status.toLowerCase()) {
      'confirmed' => AppColors.statusConfirmed,
      'cancelled' => AppColors.statusCancelled,
      'completed' => AppColors.info,
      _ => AppColors.statusPending,
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: statusColor.withOpacity(0.12),
          child: Icon(CupertinoIcons.calendar,
              size: 16, color: statusColor),
        ),
        title: Text(
          '${appointment.patientName} - ${appointment.doctor}',
          style: AppTextStyles.label.copyWith(fontSize: 13),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          appointment.specialty ?? appointment.appointmentType,
          style: AppTextStyles.caption,
        ),
        trailing: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            appointment.status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ),
    );
  }
}
