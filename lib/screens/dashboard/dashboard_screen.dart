import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../data/mock_data.dart';
import '../../models/appointment_model.dart';
import '../../models/doctor_model.dart';
import '../../services/appointment_service.dart';
import '../../services/auth_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/medi_app_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    final appointmentService = AppointmentService();
    final authService = AuthService();
    final topDoctors = MockData.getTopRatedDoctors(limit: 5);

    return Scaffold(
      appBar: MediAppBar(
        title: 'MediBook',
        subtitle: _greeting(),
        style: MediAppBarStyle.primary,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.square_arrow_right),
            tooltip: AppStrings.logout,
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                user?.email?.split('@').first ?? 'User',
                style: AppTextStyles.heading2,
              ),
            ),

            // Search Banner
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  // Switch to doctors tab - handled by parent MainNavigation
                  // For now navigate to doctors route
                  Navigator.pushNamed(context, AppRoutes.doctors);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.search,
                          color: AppColors.textHint),
                      const SizedBox(width: 10),
                      Text(
                        'Search doctors, specialties...',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Specialties Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text('Specialties', style: AppTextStyles.heading3),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: MockData.departments.length,
                itemBuilder: (context, index) {
                  final dept = MockData.departments[index];
                  return _SpecialtyChip(
                    name: dept['name'] as String,
                    icon: _departmentIcon(dept['icon'] as String),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.doctors,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Top Rated Doctors
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Top Doctors', style: AppTextStyles.heading3),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.doctors),
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: topDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = topDoctors[index];
                  return _TopDoctorCard(
                    doctor: doctor,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.doctorProfile,
                      arguments: doctor,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Upcoming Appointments
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text('Upcoming Appointments', style: AppTextStyles.heading3),
            ),
            StreamBuilder<List<AppointmentModel>>(
              stream: appointmentService.getAppointmentsStream(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'Could not load appointments',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  );
                }

                final appointments = (snapshot.data ?? [])
                    .where((a) =>
                        a.status == 'pending' || a.status == 'confirmed')
                    .take(3)
                    .toList();

                if (appointments.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.calendar,
                              size: 48,
                              color: AppColors.textSecondary.withOpacity(0.3)),
                          const SizedBox(height: 12),
                          Text(AppStrings.noAppointments,
                              style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pushNamed(
                                context, AppRoutes.doctors),
                            icon: const Icon(CupertinoIcons.add),
                            label: const Text('Book Now'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: appointments
                      .map((a) => AppointmentCard(
                            appointment: a,
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.appointmentDetail,
                              arguments: a,
                            ),
                          ))
                      .toList(),
                );
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  IconData _departmentIcon(String iconName) {
    switch (iconName) {
      case 'favorite':
        return CupertinoIcons.heart_fill;
      case 'face':
        return CupertinoIcons.person;
      case 'child_care':
        return CupertinoIcons.person_2;
      case 'accessibility_new':
        return CupertinoIcons.person;
      case 'pregnant_woman':
        return CupertinoIcons.person;
      case 'psychology':
        return CupertinoIcons.lightbulb;
      case 'visibility':
        return CupertinoIcons.eye;
      case 'mood':
        return CupertinoIcons.smiley;
      case 'hearing':
        return CupertinoIcons.ear;
      default:
        return CupertinoIcons.building_2_fill;
    }
  }
}

class _SpecialtyChip extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const _SpecialtyChip({
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopDoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const _TopDoctorCard({required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    doctor.imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(CupertinoIcons.person,
                          size: 36, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.specialty,
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.star_fill,
                        size: 14, color: AppColors.warning),
                    const SizedBox(width: 2),
                    Text(
                      doctor.rating.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
