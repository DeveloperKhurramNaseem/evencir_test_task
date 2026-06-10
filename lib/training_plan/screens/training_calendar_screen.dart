import 'package:flutter/material.dart';
import '../models/training_models.dart';
import '../theme/plan_colors.dart';
import '../widgets/widgets.dart';

/// Training Calendar screen.
///
/// Usage:
/// ```dart
/// TrainingCalendarScreen(
///   onWorkoutMoved: ({required workout, required fromDate, required toDate}) {
///     // called after every successful drag-drop
///   },
/// )
/// ```
class TrainingCalendarScreen extends StatefulWidget {
  /// Callback fired after a workout is successfully dragged to a new day.
  final OnWorkoutMoved? onWorkoutMoved;

  const TrainingCalendarScreen({super.key, this.onWorkoutMoved});

  @override
  State<TrainingCalendarScreen> createState() => _TrainingCalendarScreenState();
}

class _TrainingCalendarScreenState extends State<TrainingCalendarScreen> {
  /// Whether any card is currently being dragged (used to show drop zones)
  bool _isDraggingActive = false;

  /// All training weeks — drives the entire list
  late List<TrainingWeek> _weeks;

  @override
  void initState() {
    super.initState();
    _weeks = _buildSampleData();
  }

  // ── Sample seed data ────────────────────────────────────────────────────────

  List<TrainingWeek> _buildSampleData() {
    return [
      TrainingWeek(
        weekNumber: 1,
        days: [
          TrainingDay(
            date: DateTime(2024, 12, 2),
            workouts: [
              const WorkoutEntry(
                id: 'w1',
                title: 'Arm Blaster',
                category: WorkoutCategory.arms,
                durationRange: '25m - 30m',
              ),
            ],
          ),
          TrainingDay(date: DateTime(2024, 12, 3), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 4), workouts: []),
          TrainingDay(
            date: DateTime(2024, 12, 5),
            workouts: [
              const WorkoutEntry(
                id: 'w2',
                title: 'Leg Day Blitz',
                category: WorkoutCategory.legs,
                durationRange: '25m - 30m',
              ),
            ],
          ),
          TrainingDay(date: DateTime(2024, 12, 6), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 7), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 8), workouts: []),
        ],
      ),
      TrainingWeek(
        weekNumber: 2,
        days: [
          TrainingDay(date: DateTime(2024, 12, 9), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 10), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 11), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 12), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 13), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 14), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 15), workouts: []),
        ],
      ),
      TrainingWeek(
        weekNumber: 3,
        days: [
          TrainingDay(date: DateTime(2024, 12, 16), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 17), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 18), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 19), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 20), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 21), workouts: []),
          TrainingDay(date: DateTime(2024, 12, 22), workouts: []),
        ],
      ),
    ];
  }

  // ── Drag-drop logic ─────────────────────────────────────────────────────────

  /// Move [workout] from [fromDate] to [toDate] across the weeks structure
  void _handleWorkoutMoved({
    required WorkoutEntry workout,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    setState(() {
      _isDraggingActive = false;

      final updatedWeeks = _weeks.map((week) {
        final updatedDays = week.days.map((day) {
          // Remove from source day
          if (_isSameDay(day.date, fromDate)) {
            final newWorkouts = day.workouts
                .where((w) => w.id != workout.id)
                .toList();
            return day.copyWith(workouts: newWorkouts);
          }
          // Add to target day
          if (_isSameDay(day.date, toDate)) {
            return day.copyWith(workouts: [...day.workouts, workout]);
          }
          return day;
        }).toList();

        return week.copyWith(days: updatedDays);
      }).toList();

      _weeks = updatedWeeks;
    });

    // Fire the public callback for the parent to use
    widget.onWorkoutMoved?.call(
      workout: workout,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlanColors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(child: _buildCalendarList()),
            // _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Training Calendar',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: PlanColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          GestureDetector(
            onTap: _onSave,
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: PlanColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarList() {
    // Flatten weeks into a list of section items
    final items = <_ListItem>[];
    for (final week in _weeks) {
      items.add(_WeekHeaderItem(week));
      for (int i = 0; i < week.days.length; i++) {
        items.add(
          _DayItem(week.days[i], showDivider: i < week.days.length - 1),
        );
      }
    }

    return NotificationListener<DraggableScrollableNotification>(
      child: CustomScrollView(
        physics: _isDraggingActive
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildItem(items[index]),
              childCount: items.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildItem(_ListItem item) {
    if (item is _WeekHeaderItem) {
      return WeekSectionHeader(week: item.week);
    }
    if (item is _DayItem) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Wrap each day row in a Listener to detect when drag starts globally
          _DragStateListener(
            onDragActiveChanged: (active) {
              if (_isDraggingActive != active) {
                setState(() => _isDraggingActive = active);
              }
            },
            child: TrainingDayRow(
              day: item.day,
              isDraggingActive: _isDraggingActive,
              onWorkoutMoved: _handleWorkoutMoved,
              onGlobalDragStarted: () {
                if (!_isDraggingActive) {
                  setState(() => _isDraggingActive = true);
                }
              },
              onGlobalDragEnded: () {
                if (_isDraggingActive) {
                  setState(() => _isDraggingActive = false);
                }
              },
            ),
          ),
          if (item.showDivider) const DayDivider(),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomNavBar() {
    const items = [
      _NavItem(icon: Icons.local_fire_department_outlined, label: 'Nutrition'),
      _NavItem(
        icon: Icons.calendar_today_rounded,
        label: 'Plan',
        selected: true,
      ),
      _NavItem(icon: Icons.sentiment_satisfied_outlined, label: 'Mood'),
      _NavItem(icon: Icons.person_outline, label: 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: PlanColors.grey,
        border: Border(top: BorderSide(color: PlanColors.divider, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) => _buildNavItem(item)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(_NavItem item) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 22,
            color: item.selected
                ? PlanColors.textPrimary
                : PlanColors.textMuted,
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: item.selected ? FontWeight.w600 : FontWeight.w400,
              color: item.selected
                  ? PlanColors.textPrimary
                  : PlanColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _onSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Training plan saved'),
        backgroundColor: PlanColors.seaGreen,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// ── List item sealed types ────────────────────────────────────────────────────

abstract class _ListItem {}

class _WeekHeaderItem extends _ListItem {
  final TrainingWeek week;
  _WeekHeaderItem(this.week);
}

class _DayItem extends _ListItem {
  final TrainingDay day;
  final bool showDivider;
  _DayItem(this.day, {required this.showDivider});
}

// ── Drag state listener ───────────────────────────────────────────────────────

/// Notifies parent when a LongPressDraggable inside it starts/stops dragging
/// by listening to the drag notification bubbling up via callbacks on the card.
/// We use a simpler approach: the DraggableWorkoutCard fires directly via
/// the global drag active flag set in _TrainingCalendarScreenState.
class _DragStateListener extends StatelessWidget {
  final Widget child;
  final ValueChanged<bool> onDragActiveChanged;

  const _DragStateListener({
    required this.child,
    required this.onDragActiveChanged,
  });

  @override
  Widget build(BuildContext context) => child;
}

class _NavItem {
  final IconData icon;
  final String label;
  final bool selected;
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });
}
