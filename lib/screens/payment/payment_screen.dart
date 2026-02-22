import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_routes.dart';
import '../../data/mock_data.dart';
import '../../models/appointment_model.dart';
import '../../models/doctor_model.dart';
import '../../services/appointment_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/medi_app_bar.dart';
import '../../widgets/primary_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'mpesa';
  bool _isLoading = false;
  final _appointmentService = AppointmentService();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final doctor = args['doctor'] as DoctorModel;
    final bookingData = args['bookingData'] as Map<String, dynamic>;

    return Scaffold(
      appBar: const MediAppBar.inner(title: 'Payment'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Summary
            Text('Booking Summary', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SummaryRow(label: 'Doctor', value: doctor.name),
                    const Divider(height: 20),
                    _SummaryRow(
                        label: 'Specialty', value: doctor.specialty),
                    const Divider(height: 20),
                    _SummaryRow(
                      label: 'Date',
                      value: DateFormatter.display(
                          bookingData['date'] as DateTime),
                    ),
                    if (bookingData['timeSlot'] != null) ...[
                      const Divider(height: 20),
                      _SummaryRow(
                          label: 'Time',
                          value: bookingData['timeSlot'] as String),
                    ],
                    const Divider(height: 20),
                    _SummaryRow(
                      label: 'Type',
                      value: bookingData['appointmentType'] == 'online'
                          ? 'Online Consultation'
                          : 'Physical Visit',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Fee Breakdown
            Text('Fee Breakdown', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: 'Consultation Fee',
                      value: MockData.formatFee(doctor.consultationFee),
                    ),
                    const Divider(height: 20),
                    _SummaryRow(
                      label: 'Service Fee',
                      value: MockData.formatFee(2000),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: AppTextStyles.heading3),
                        Text(
                          MockData.formatFee(
                              doctor.consultationFee + 2000),
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Payment Method
            Text('Payment Method', style: AppTextStyles.heading3),
            const SizedBox(height: 12),

            _PaymentMethodTile(
              icon: CupertinoIcons.device_phone_portrait,
              title: 'M-Pesa',
              subtitle: 'Vodacom Mobile Money',
              value: 'mpesa',
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val!),
            ),
            const SizedBox(height: 8),
            _PaymentMethodTile(
              icon: CupertinoIcons.device_phone_portrait,
              title: 'Tigo Pesa',
              subtitle: 'Tigo Mobile Money',
              value: 'tigopesa',
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val!),
            ),
            const SizedBox(height: 8),
            _PaymentMethodTile(
              icon: CupertinoIcons.device_phone_portrait,
              title: 'Airtel Money',
              subtitle: 'Airtel Mobile Money',
              value: 'airtel',
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val!),
            ),
            const SizedBox(height: 8),
            _PaymentMethodTile(
              icon: CupertinoIcons.building_2_fill,
              title: 'Pay at Hospital',
              subtitle: 'Cash payment on arrival',
              value: 'cash',
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val!),
            ),

            const SizedBox(height: 32),

            // Confirm Button
            PrimaryButton(
              label: _selectedMethod == 'cash'
                  ? 'Confirm Booking'
                  : 'Pay ${MockData.formatFee(doctor.consultationFee + 2000)}',
              onPressed: () => _processPayment(doctor, bookingData),
              isLoading: _isLoading,
              icon: Icon(
                _selectedMethod == 'cash'
                    ? CupertinoIcons.checkmark
                    : CupertinoIcons.creditcard,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment(
      DoctorModel doctor, Map<String, dynamic> bookingData) async {
    setState(() => _isLoading = true);

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      final userId = FirebaseAuth.instance.currentUser!.uid;
      final appointment = AppointmentModel(
        patientName: bookingData['patientName'] as String,
        doctor: doctor.name,
        doctorId: doctor.id,
        specialty: doctor.specialty,
        date: bookingData['date'] as DateTime,
        timeSlot: bookingData['timeSlot'] as String?,
        appointmentType: bookingData['appointmentType'] as String,
        notes: bookingData['notes'] as String?,
        userId: userId,
      );

      final id = await _appointmentService.addAppointment(appointment);

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.confirmation,
          arguments: appointment.copyWith(id: id),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.label),
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.divider,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        title: Text(title, style: AppTextStyles.label),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        secondary: Icon(icon, color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        activeColor: AppColors.primary,
      ),
    );
  }
}
