import 'package:evencir_test/models/training_models.dart';
import 'package:evencir_test/theme/app_colors.dart';
import 'package:flutter/material.dart';


class WeekSectionHeader extends StatelessWidget {
  final TrainingWeek week;

  const WeekSectionHeader({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gradient separator line
        Container(
          height: 2,
          decoration: const BoxDecoration(
            gradient: PlanColors.weekAccentGradient,
          ),
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // "Week N/M"
              Text(
                'Week ${week.weekNumber}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: PlanColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              // Date range + total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    week.dateRangeLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: PlanColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Total: ${week.totalMinutes}min',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: PlanColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
