import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_routes.dart';
import '../../data/mock_data.dart';
import '../../models/appointment_model.dart';
import '../../services/appointment_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/medi_app_bar.dart';
import '../../widgets/primary_button.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final _appointmentService = AppointmentService();
  bool _isLoading = false;

  Future<void> _cancelAppointment(AppointmentModel appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
          'Are you sure you want to cancel this appointment? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != true || appointment.id == null) return;

    setState(() => _isLoading = true);
    try {
      await _appointmentService.updateStatus(appointment.id!, 'cancelled');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment cancelled successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to cancel appointment'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _rescheduleAppointment(AppointmentModel appointment) {
    final doctor = MockData.getDoctorById(appointment.doctorId ?? '');
    Navigator.pushNamed(
      context,
      AppRoutes.booking,
      arguments: doctor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointment =
        ModalRoute.of(context)!.settings.arguments as AppointmentModel;

    final statusColor = _statusColor(appointment.status);
    final isActive = appointment.status == 'pending' ||
        appointment.status == 'confirmed';

    return Scaffold(
      appBar: const MediAppBar.inner(
        title: 'Appointment Details',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(_statusIcon(appointment.status),
                            color: statusColor, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          _statusLabel(appointment.status),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Doctor Info
                  _buildSection(
                    'Doctor',
                    CupertinoIcons.heart,
                    [
                      _InfoRow(label: 'Name', value: appointment.doctor),
                      if (appointment.specialty != null)
                        _InfoRow(
                            label: 'Specialty',
                            value: appointment.specialty!),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Patient Info
                  _buildSection(
                    'Patient',
                    CupertinoIcons.person,
                    [
                      _InfoRow(
                          label: 'Name', value: appointment.patientName),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Schedule
                  _buildSection(
                    'Schedule',
                    CupertinoIcons.calendar,
                    [
                      _InfoRow(
                        label: 'Date',
                        value: DateFormatter.display(appointment.date),
                      ),
                      if (appointment.timeSlot != null)
                        _InfoRow(
                            label: 'Time', value: appointment.timeSlot!),
                      _InfoRow(
                        label: 'Type',
                        value: appointment.appointmentType == 'online'
                            ? 'Online Consultation'
                            : 'Physical Visit',
                      ),
                    ],
                  ),

                  if (appointment.notes != null &&
                      appointment.notes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSection(
                      'Notes',
                      CupertinoIcons.doc_text,
                      [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            appointment.notes!,
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Consultation Fee
                  if (appointment.doctorId != null) ...[
                    const SizedBox(height: 16),
                    Builder(builder: (context) {
                      final doctor =
                          MockData.getDoctorById(appointment.doctorId!);
                      if (doctor == null) return const SizedBox.shrink();
                      return _buildSection(
                        'Fee',
                        CupertinoIcons.creditcard,
                        [
                          _InfoRow(
                            label: 'Consultation Fee',
                            value:
                                MockData.formatFee(doctor.consultationFee),
                          ),
                        ],
                      );
                    }),
                  ],

                  const SizedBox(height: 32),

                  // Action Buttons
                  if (isActive) ...[
                    PrimaryButton(
                      label: 'Reschedule Appointment',
                      onPressed: () =>
                          _rescheduleAppointment(appointment),
                      icon: const Icon(CupertinoIcons.calendar,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _cancelAppointment(appointment),
                        icon: const Icon(CupertinoIcons.xmark_circle_fill),
                        label: const Text('Cancel Appointment'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(
      String title, IconData icon, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(title, style: AppTextStyles.heading3),
              ],
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.statusConfirmed;
      case 'cancelled':
        return AppColors.statusCancelled;
      case 'completed':
        return AppColors.info;
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
      case 'completed':
        return CupertinoIcons.checkmark_seal_fill;
      default:
        return CupertinoIcons.clock;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      default:
        return 'Pending Confirmation';
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.label),
          ),
        ],
      ),
    );
  }
}
