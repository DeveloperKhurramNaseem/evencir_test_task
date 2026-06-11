import 'package:evencir_test/models/week_info.dart';
import 'package:evencir_test/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WeekDateStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeekDateStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const _dayLabels = ['M', 'TU', 'W', 'TH', 'F', 'SA', 'SU'];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weekDates = WeekInfo.weekDates(selectedDate);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 14),
              child: Text(
                _formatHeaderDate(selectedDate),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Day labels row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      _dayLabels[index],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            // Date numbers row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final date = weekDates[index];
                final isSelected = _isSameDay(date, selectedDate);
                final isToday = _isSameDay(date, today);
                final hasActivity = _isSameDay(date, today);
        
                return GestureDetector(
                  onTap: () => onDateSelected(date),
                  child: SizedBox(
                    width: 40,
                    child: Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.green.withAlpha(80)
                                : AppColors.cardBackgroundLight,
                            border: isSelected
                                ? Border.all(color: AppColors.green, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Activity dot
                        if (hasActivity)
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.green,
                            ),
                          )
                        else
                          const SizedBox(height: 5),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _formatHeaderDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return 'Today, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
