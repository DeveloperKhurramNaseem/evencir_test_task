class WeekInfo {
  final int weekOfMonth;
  final int totalWeeksInMonth;
  final DateTime selectedDate;

  const WeekInfo({
    required this.weekOfMonth,
    required this.totalWeeksInMonth,
    required this.selectedDate,
  });

  String get label => 'Week $weekOfMonth/$totalWeeksInMonth';

  static WeekInfo fromDate(DateTime date) {
    final weekOfMonth = _weekOfMonth(date);
    final totalWeeks = _totalWeeksInMonth(date.year, date.month);
    return WeekInfo(
      weekOfMonth: weekOfMonth,
      totalWeeksInMonth: totalWeeks,
      selectedDate: date,
    );
  }

  static int _weekOfMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final dayOfWeek = firstDay.weekday; // 1 = Monday
    final offset = dayOfWeek - 1; // 0-based offset from Monday
    return ((date.day + offset - 1) ~/ 7) + 1;
  }

  static int _totalWeeksInMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final offset = firstDay.weekday - 1;
    return ((lastDay.day + offset - 1) ~/ 7) + 1;
  }

  /// Returns the list of dates in the same week (Mon–Sun) as [date]
  static List<DateTime> weekDates(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }
}
