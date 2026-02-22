import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/mock_data.dart';
import '../../services/user_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/medi_app_bar.dart';
import '../../widgets/primary_button.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  final _userService = UserService();
  bool _isLoading = false;

  final _allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Set<String> _selectedDays = {};
  Set<String> _selectedSlots = {};
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final user = await _userService.getUser(uid);
    if (user != null && mounted) {
      // Load saved schedule from Firestore or use defaults
      setState(() {
        _dataLoaded = true;
      });
    } else {
      setState(() => _dataLoaded = true);
    }
  }

  Future<void> _saveSchedule() async {
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await _userService.updateProfile(uid, {
        'availableDays': _selectedDays.toList(),
        'availableSlots': _selectedSlots.toList(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Schedule updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save schedule'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MediAppBar.inner(
        title: 'My Schedule',
      ),
      body: !_dataLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available Days', style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  Text('Select the days you are available for appointments',
                      style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 12),

                  // Days selection
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allDays.map((day) {
                      final isSelected = _selectedDays.contains(day);
                      return FilterChip(
                        label: Text(day),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedDays.add(day);
                            } else {
                              _selectedDays.remove(day);
                            }
                          });
                        },
                        selectedColor: AppColors.primary.withOpacity(0.15),
                        checkmarkColor: AppColors.primary,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  Text('Available Time Slots',
                      style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  Text('Select your preferred consultation times',
                      style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 16),

                  // Morning
                  _buildSlotSection('Morning', MockData.morningSlots),
                  const SizedBox(height: 16),

                  // Afternoon
                  _buildSlotSection('Afternoon', MockData.afternoonSlots),
                  const SizedBox(height: 16),

                  // Evening
                  _buildSlotSection('Evening', MockData.eveningSlots),

                  const SizedBox(height: 32),

                  // Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Schedule Summary',
                              style: AppTextStyles.heading3),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Working Days',
                                  style: AppTextStyles.bodyMedium),
                              Text('${_selectedDays.length} days',
                                  style: AppTextStyles.label),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Time Slots',
                                  style: AppTextStyles.bodyMedium),
                              Text('${_selectedSlots.length} slots',
                                  style: AppTextStyles.label),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  PrimaryButton(
                    label: 'Save Schedule',
                    onPressed: _saveSchedule,
                    isLoading: _isLoading,
                    icon: const Icon(CupertinoIcons.checkmark,
                        color: Colors.white),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSlotSection(String title, List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots.map((slot) {
            final isSelected = _selectedSlots.contains(slot);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedSlots.remove(slot);
                  } else {
                    _selectedSlots.add(slot);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
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
                    color:
                        isSelected ? Colors.white : AppColors.primary,
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
