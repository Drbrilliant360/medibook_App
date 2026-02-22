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

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final uid = firebaseUser?.uid ?? '';
    final userService = UserService();
    final appointmentService = AppointmentService();

    return Scaffold(
      appBar: MediAppBar(
        title: 'Dashboard',
        subtitle: _greeting(),
        style: MediAppBarStyle.primary,
      ),
      body: StreamBuilder<UserModel?>(
        stream: userService.getUserStream(uid),
        builder: (context, userSnap) {
          final user = userSnap.data;
          final doctorName = user?.fullName ?? 'Doctor';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_greeting(), style: AppTextStyles.bodyMedium),
                      Text('Dr. $doctorName', style: AppTextStyles.heading2),
                      if (user?.specialty != null)
                        Text(user!.specialty!,
                            style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Stats from appointments stream
                StreamBuilder<List<AppointmentModel>>(
                  stream: appointmentService
                      .getDoctorAppointmentsStream(
                          'Dr. ${user?.fullName ?? ''}'),
                  builder: (context, snap) {
                    final all = snap.data ?? [];
                    final today = DateTime.now();
                    final todayAppts = all.where((a) =>
                        a.date.year == today.year &&
                        a.date.month == today.month &&
                        a.date.day == today.day).toList();
                    final pending =
                        all.where((a) => a.status == 'pending').length;
                    final confirmed =
                        all.where((a) => a.status == 'confirmed').length;
                    final completed =
                        all.where((a) => a.status == 'completed').length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Grid
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              _StatCard(
                                icon: CupertinoIcons.calendar,
                                label: 'Today',
                                value: '${todayAppts.length}',
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              _StatCard(
                                icon: CupertinoIcons.clock,
                                label: 'Pending',
                                value: '$pending',
                                color: AppColors.warning,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              _StatCard(
                                icon: CupertinoIcons.checkmark_circle_fill,
                                label: 'Confirmed',
                                value: '$confirmed',
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 12),
                              _StatCard(
                                icon: CupertinoIcons.checkmark_seal_fill,
                                label: 'Completed',
                                value: '$completed',
                                color: AppColors.info,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Today's Appointments
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Today's Appointments",
                              style: AppTextStyles.heading3),
                        ),
                        const SizedBox(height: 8),

                        if (todayAppts.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(CupertinoIcons.calendar,
                                      size: 48,
                                      color: AppColors.textSecondary
                                          .withOpacity(0.3)),
                                  const SizedBox(height: 12),
                                  Text('No appointments today',
                                      style: AppTextStyles.bodyMedium),
                                ],
                              ),
                            ),
                          )
                        else
                          ...todayAppts.map((a) => _DoctorAppointmentTile(
                                appointment: a,
                                appointmentService: appointmentService,
                              )),

                        // Recent Appointments
                        if (all.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Recent Appointments',
                                style: AppTextStyles.heading3),
                          ),
                          const SizedBox(height: 8),
                          ...all
                              .where((a) => !(a.date.year == today.year &&
                                  a.date.month == today.month &&
                                  a.date.day == today.day))
                              .take(5)
                              .map((a) => _DoctorAppointmentTile(
                                    appointment: a,
                                    appointmentService: appointmentService,
                                  )),
                        ],

                        const SizedBox(height: 100),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
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

class _DoctorAppointmentTile extends StatelessWidget {
  final AppointmentModel appointment;
  final AppointmentService appointmentService;

  const _DoctorAppointmentTile({
    required this.appointment,
    required this.appointmentService,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (appointment.status.toLowerCase()) {
      'confirmed' => AppColors.statusConfirmed,
      'cancelled' => AppColors.statusCancelled,
      'completed' => AppColors.info,
      _ => AppColors.statusPending,
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    appointment.patientName.isNotEmpty
                        ? appointment.patientName[0].toUpperCase()
                        : 'P',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.patientName,
                          style: AppTextStyles.label),
                      Text(
                        '${DateFormatter.display(appointment.date)}${appointment.timeSlot != null ? ' at ${appointment.timeSlot}' : ''}',
                        style: AppTextStyles.caption,
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
                    appointment.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            if (appointment.notes != null &&
                appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${appointment.notes}',
                style: AppTextStyles.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (appointment.status == 'pending' ||
                appointment.status == 'confirmed') ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (appointment.status == 'pending')
                    _ActionButton(
                      label: 'Confirm',
                      color: AppColors.success,
                      icon: CupertinoIcons.checkmark,
                      onTap: () => _updateStatus(
                          context, appointment.id!, 'confirmed'),
                    ),
                  const SizedBox(width: 8),
                  if (appointment.status == 'confirmed')
                    _ActionButton(
                      label: 'Complete',
                      color: AppColors.info,
                      icon: CupertinoIcons.checkmark_seal_fill,
                      onTap: () => _updateStatus(
                          context, appointment.id!, 'completed'),
                    ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    label: 'Cancel',
                    color: AppColors.error,
                    icon: CupertinoIcons.xmark,
                    onTap: () => _updateStatus(
                        context, appointment.id!, 'cancelled'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _updateStatus(
      BuildContext context, String id, String status) async {
    try {
      await appointmentService.updateStatus(id, status);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment $status'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
