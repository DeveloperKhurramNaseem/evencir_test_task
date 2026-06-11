import 'package:evencir_test/models/week_info.dart';
import 'package:evencir_test/theme/app_colors.dart';
import 'package:flutter/material.dart';

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

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bell icon
            Image.asset('assets/images/bell.png', width: 22),
        
            // Week selector
            GestureDetector(
              onTap: onWeekTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                // decoration: BoxDecoration(
                //   color: AppColors.grey,
                //   borderRadius: BorderRadius.circular(20),
                // ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Timer/clock icon
                    Image.asset('assets/images/timer.png', width: 22),
                    const SizedBox(width: 6),
                    Text(
                      weekInfo.label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset('assets/images/arrow_down.png', width: 10),
                  ],
                ),
              ),
            ),
        
            // Placeholder for right side
            const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }
}
