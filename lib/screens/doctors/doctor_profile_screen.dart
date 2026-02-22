import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_routes.dart';
import '../../data/mock_data.dart';
import '../../models/doctor_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor =
        ModalRoute.of(context)!.settings.arguments as DoctorModel;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsing Header with Doctor Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    doctor.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primary.withOpacity(0.1),
                      child: const Icon(CupertinoIcons.person, size: 100, color: AppColors.primary),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Doctor name overlay
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: AppTextStyles.heading1.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.specialty,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats Row
                  Row(
                    children: [
                      _StatBadge(
                        icon: CupertinoIcons.star_fill,
                        value: doctor.rating.toString(),
                        label: '${doctor.reviewCount} reviews',
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 12),
                      _StatBadge(
                        icon: CupertinoIcons.briefcase,
                        value: '${doctor.experienceYears}',
                        label: 'Years Exp.',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _StatBadge(
                        icon: CupertinoIcons.creditcard,
                        value: MockData.formatFee(doctor.consultationFee),
                        label: 'Per Visit',
                        color: AppColors.success,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Hospital & Location
                  _InfoTile(
                    icon: CupertinoIcons.building_2_fill,
                    title: doctor.hospital,
                    subtitle: doctor.location,
                  ),

                  if (doctor.isAvailableOnline)
                    const _InfoTile(
                      icon: CupertinoIcons.video_camera,
                      title: 'Online Consultation Available',
                      subtitle: 'Video call appointments supported',
                    ),

                  const SizedBox(height: 20),

                  // About
                  Text('About', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  Text(doctor.bio, style: AppTextStyles.bodyLarge),

                  const SizedBox(height: 20),

                  // Available Days
                  Text('Available Days', style: AppTextStyles.heading3),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allDays.map((day) {
                      final isAvailable = doctor.availableDays.contains(day);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.divider.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: isAvailable
                              ? Border.all(color: AppColors.primary.withOpacity(0.3))
                              : null,
                        ),
                        child: Text(
                          day.substring(0, 3),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isAvailable
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Languages
                  Text('Languages', style: AppTextStyles.heading3),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: doctor.languages.map((lang) {
                      return Chip(
                        label: Text(lang, style: const TextStyle(fontSize: 13)),
                        avatar: const Icon(CupertinoIcons.globe, size: 16),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Book Appointment Button
                  PrimaryButton(
                    label: 'Book Appointment',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.booking,
                      arguments: doctor,
                    ),
                    icon: const Icon(CupertinoIcons.calendar, color: Colors.white),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
