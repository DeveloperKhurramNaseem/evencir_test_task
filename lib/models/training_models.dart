import 'package:flutter/material.dart';

/// Category tag shown on the workout card chip
enum WorkoutCategory {
  arms,
  legs,
  chest,
  back,
  cardio,
  core,
}

extension WorkoutCategoryX on WorkoutCategory {
  String get label {
    switch (this) {
      case WorkoutCategory.arms:
        return 'Arms Workout';
      case WorkoutCategory.legs:
        return 'Leg Workout';
      case WorkoutCategory.chest:
        return 'Chest Workout';
      case WorkoutCategory.back:
        return 'Back Workout';
      case WorkoutCategory.cardio:
        return 'Cardio';
      case WorkoutCategory.core:
        return 'Core Workout';
    }
  }

  Color get chipColor {
    switch (this) {
      case WorkoutCategory.arms:
        return const Color(0xFF20B76F); // green
      case WorkoutCategory.legs:
        return const Color(0xFF48A4E5); // blue
      case WorkoutCategory.chest:
        return const Color(0xFFE57648); // orange
      case WorkoutCategory.back:
        return const Color(0xFF9B48E5); // purple
      case WorkoutCategory.cardio:
        return const Color(0xFFE54888); // pink
      case WorkoutCategory.core:
        return const Color(0xFF32AAB7); // sea-green
    }
  }

  IconData get icon {
    switch (this) {
      case WorkoutCategory.arms:
        return Icons.fitness_center;
      case WorkoutCategory.legs:
        return Icons.directions_run;
      case WorkoutCategory.chest:
        return Icons.sports_gymnastics;
      case WorkoutCategory.back:
        return Icons.accessibility_new;
      case WorkoutCategory.cardio:
        return Icons.favorite_border;
      case WorkoutCategory.core:
        return Icons.rotate_right;
    }
  }
}

/// A single workout entry that lives on a calendar day
class WorkoutEntry {
  final String id;
  final String title;
  final WorkoutCategory category;
  final String durationRange; // e.g. "25m - 30m"

  const WorkoutEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.durationRange,
  });

  WorkoutEntry copyWith({
    String? id,
    String? title,
    WorkoutCategory? category,
    String? durationRange,
  }) {
    return WorkoutEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      durationRange: durationRange ?? this.durationRange,
    );
  }
}

/// One day row in the training calendar
class TrainingDay {
  final DateTime date;
  final List<WorkoutEntry> workouts;

  const TrainingDay({
    required this.date,
    required this.workouts,
  });

  TrainingDay copyWith({
    DateTime? date,
    List<WorkoutEntry>? workouts,
  }) {
    return TrainingDay(
      date: date ?? this.date,
      workouts: workouts ?? List.from(this.workouts),
    );
  }

  String get dayAbbr {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}

/// A full training week group
class TrainingWeek {
  final int weekNumber;
  final List<TrainingDay> days;

  const TrainingWeek({
    required this.weekNumber,
    required this.days,
  });

  TrainingWeek copyWith({
    int? weekNumber,
    List<TrainingDay>? days,
  }) {
    return TrainingWeek(
      weekNumber: weekNumber ?? this.weekNumber,
      days: days ?? List.from(this.days),
    );
  }

  DateTime get startDate => days.first.date;
  DateTime get endDate => days.last.date;

  int get totalMinutes {
    int total = 0;
    for (final day in days) {
      for (final workout in day.workouts) {
        // Parse e.g. "25m - 30m" → take the upper bound
        final match =
            RegExp(r'(\d+)m\s*-\s*(\d+)m').firstMatch(workout.durationRange);
        if (match != null) {
          total += int.parse(match.group(2)!);
        }
      }
    }
    return total;
  }

  String get dateRangeLabel {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final s = startDate;
    final e = endDate;
    if (s.month == e.month) {
      return '${months[s.month - 1]} ${s.day}-${e.day}';
    }
    return '${months[s.month - 1]} ${s.day} - ${months[e.month - 1]} ${e.day}';
  }
}

/// Callback type for when a workout is moved
typedef OnWorkoutMoved = void Function({
  required WorkoutEntry workout,
  required DateTime fromDate,
  required DateTime toDate,
});
