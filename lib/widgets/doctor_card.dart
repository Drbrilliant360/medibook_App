import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../data/mock_data.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback? onTap;

  const DoctorCard({super.key, required this.doctor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Doctor Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  doctor.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(CupertinoIcons.person, size: 40, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor.name, style: AppTextStyles.heading3),
                    const SizedBox(height: 4),
                    Text(doctor.specialty, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.location,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            doctor.hospital,
                            style: AppTextStyles.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Rating
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(CupertinoIcons.star_fill,
                                  size: 14, color: AppColors.warning),
                              const SizedBox(width: 2),
                              Text(
                                doctor.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${doctor.experienceYears} yrs exp.',
                          style: AppTextStyles.caption,
                        ),
                        const Spacer(),
                        Text(
                          MockData.formatFee(doctor.consultationFee),
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
