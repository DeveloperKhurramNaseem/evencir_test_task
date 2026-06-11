
import 'package:evencir_test/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}


class WorkoutSectionHeader extends StatelessWidget {
  const WorkoutSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return  SectionHeader(
            title: 'Workouts',
            trailing: Row(
              children: [
                Image.asset('assets/images/sun.png', width: 24),
                SizedBox(width: 8),
                Text(
                  '9°',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
  }
}