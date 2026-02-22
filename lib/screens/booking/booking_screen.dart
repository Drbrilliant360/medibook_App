import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../data/mock_data.dart';
import '../../models/doctor_model.dart';
import '../../utils/date_formatter.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/medi_app_bar.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  DoctorModel? _doctor;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String _appointmentType = 'physical';
  bool _doctorFromArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_doctorFromArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is DoctorModel) {
        _doctor = args;
        _doctorFromArgs = true;
        if (!args.isAvailableOnline) {
          _appointmentType = 'physical';
        }
      }
    }
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormatter.display(picked);
        _selectedTimeSlot = null; // reset time when date changes
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_doctor == null) {
      _showError('Please select a doctor');
      return;
    }

    final dateError = Validators.appointmentDate(_selectedDate);
    if (dateError != null) {
      _showError(dateError);
      return;
    }

    if (_selectedTimeSlot == null) {
      _showError('Please select a time slot');
      return;
    }

    // Navigate to payment screen with booking data
    Navigator.pushNamed(
      context,
      AppRoutes.payment,
      arguments: {
        'doctor': _doctor!,
        'bookingData': {
          'patientName': _patientNameController.text.trim(),
          'date': _selectedDate!,
          'timeSlot': _selectedTimeSlot,
          'appointmentType': _appointmentType,
          'notes': _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        },
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MediAppBar.inner(title: 'Book Appointment'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLG),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info Card (if pre-selected)
              if (_doctor != null) _buildDoctorHeader(),
              if (_doctor == null) _buildDoctorSelector(),

              const SizedBox(height: AppConstants.paddingLG),

              // Patient Name
              AppTextField(
                label: AppStrings.patientName,
                controller: _patientNameController,
                validator: Validators.requiredField,
                prefixIcon: const Icon(CupertinoIcons.person),
              ),

              const SizedBox(height: AppConstants.paddingMD),

              // Appointment Type Toggle
              Text('Appointment Type', style: AppTextStyles.label),
              const SizedBox(height: 8),
              _buildAppointmentTypeSelector(),

              const SizedBox(height: AppConstants.paddingMD),

              // Date Picker
              AppTextField(
                label: AppStrings.selectDate,
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                validator: (_) => Validators.appointmentDate(_selectedDate),
                prefixIcon: const Icon(CupertinoIcons.calendar),
                suffixIcon: const Icon(CupertinoIcons.chevron_down),
              ),

              const SizedBox(height: AppConstants.paddingMD),

              // Time Slots
              if (_selectedDate != null) ...[
                Text('Select Time', style: AppTextStyles.label),
                const SizedBox(height: 10),
                _buildTimeSlotSection('Morning', MockData.morningSlots),
                const SizedBox(height: 12),
                _buildTimeSlotSection('Afternoon', MockData.afternoonSlots),
                const SizedBox(height: 12),
                _buildTimeSlotSection('Evening', MockData.eveningSlots),
                const SizedBox(height: AppConstants.paddingMD),
              ],

              // Patient Notes
              AppTextField(
                label: 'Symptoms / Notes (Optional)',
                hint: 'Describe your symptoms or reason for visit...',
                controller: _notesController,
                maxLines: 3,
                prefixIcon: const Icon(CupertinoIcons.doc_text),
              ),

              const SizedBox(height: AppConstants.paddingXL),

              // Submit
              PrimaryButton(
                label: AppStrings.bookNow,
                onPressed: _submit,
                isLoading: false,
                icon: const Icon(CupertinoIcons.checkmark, color: Colors.white),
              ),

              const SizedBox(height: AppConstants.paddingLG),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              _doctor!.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(CupertinoIcons.person, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_doctor!.name, style: AppTextStyles.heading3),
                Text(_doctor!.specialty, style: AppTextStyles.bodyMedium),
                Text(
                  MockData.formatFee(_doctor!.consultationFee),
                  style: AppTextStyles.label.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          if (!_doctorFromArgs)
            IconButton(
              onPressed: () => setState(() => _doctor = null),
              icon: const Icon(CupertinoIcons.xmark),
            ),
        ],
      ),
    );
  }

  Widget _buildDoctorSelector() {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(context, AppRoutes.doctors);
      },
      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.inputBorder),
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        child: Row(
          children: [
            Icon(CupertinoIcons.heart,
                color: AppColors.textSecondary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select a Doctor', style: AppTextStyles.label),
                  Text('Browse and choose your doctor',
                      style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_right,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _TypeOption(
            icon: CupertinoIcons.building_2_fill,
            label: 'Physical Visit',
            isSelected: _appointmentType == 'physical',
            onTap: () => setState(() => _appointmentType = 'physical'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TypeOption(
            icon: CupertinoIcons.video_camera,
            label: 'Online',
            isSelected: _appointmentType == 'online',
            enabled: _doctor?.isAvailableOnline ?? true,
            onTap: () {
              if (_doctor != null && !_doctor!.isAvailableOnline) {
                _showError('This doctor is not available for online consultations');
                return;
              }
              setState(() => _appointmentType = 'online');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSection(String title, List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.caption),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots.map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            return GestureDetector(
              onTap: () => setState(() => _selectedTimeSlot = slot),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TypeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _TypeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : enabled
                    ? AppColors.inputBorder
                    : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : enabled
                      ? AppColors.textSecondary
                      : AppColors.textHint,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppColors.primary
                    : enabled
                        ? AppColors.textSecondary
                        : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
