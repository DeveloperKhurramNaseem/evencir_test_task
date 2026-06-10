import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../models/week_info.dart';

class WeekSelectorBar extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onWeekTap;

  const WeekSelectorBar({
    super.key,
    required this.selectedDate,
    required this.onWeekTap,
  });

  @override
  Widget build(BuildContext context) {
    final weekInfo = WeekInfo.fromDate(selectedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bell icon
          const Icon(
            Icons.notifications_outlined,
            color: AppColors.textSecondary,
            size: 22,
          ),

          // Week selector
          GestureDetector(
            onTap: onWeekTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Timer/clock icon
                  const Icon(
                    Icons.timelapse_rounded,
                    color: AppColors.textSecondary,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    weekInfo.label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          // Placeholder for right side
          const SizedBox(width: 22),
        ],
      ),
    );
  }
}
