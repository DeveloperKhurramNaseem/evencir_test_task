import 'package:evencir_test/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CalendarBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarBottomSheet({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
  }) async {
    DateTime? result;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => CalendarBottomSheet(
        initialDate: initialDate,
        onDateSelected: (date) {
          result = date;
          Navigator.pop(ctx);
        },
      ),
    );
    return result;
  }

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime _viewMonth;
  late DateTime _selectedDate;

  static const _fullMonthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _viewMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  void _previousMonth() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Month navigation header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _previousMonth,
                  child: const Icon(
                    Icons.chevron_left,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
                Text(
                  '${_fullMonthNames[_viewMonth.month - 1]} ${_viewMonth.year}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: _nextMonth,
                  child: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Day labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _DayLabel('MON'),
                _DayLabel('TUE'),
                _DayLabel('WED'),
                _DayLabel('THU'),
                _DayLabel('FRI'),
                _DayLabel('SAT'),
                _DayLabel('SUN'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Calendar grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _CalendarGrid(
              viewMonth: _viewMonth,
              selectedDate: _selectedDate,
              onDateTap: (date) {
                setState(() => _selectedDate = date);
                widget.onDateSelected(date);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;
  const _DayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime viewMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateTap;

  const _CalendarGrid({
    required this.viewMonth,
    required this.selectedDate,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(viewMonth.year, viewMonth.month, 1);
    // weekday: 1=Mon, 7=Sun; offset for Mon-first grid
    final startOffset = firstDay.weekday - 1;
    final daysInMonth = DateTime(viewMonth.year, viewMonth.month + 1, 0).day;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final today = DateTime.now();

    return Column(
      children: List.generate(rows, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final dayNumber = cellIndex - startOffset + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox(width: 40, height: 40);
              }

              final date = DateTime(viewMonth.year, viewMonth.month, dayNumber);
              final isSelected = _isSameDay(date, selectedDate);
              final isToday = _isSameDay(date, today);

              return GestureDetector(
                onTap: () => onDateTap(date),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.green.withAlpha(80)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: AppColors.green, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNumber',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected || isToday
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.textPrimary
                            : isToday
                            ? AppColors.green
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
