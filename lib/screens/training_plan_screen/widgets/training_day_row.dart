import 'package:evencir_test/models/training_models.dart';
import 'package:evencir_test/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'draggable_workout_card.dart';

class TrainingDayRow extends StatefulWidget {
  final TrainingDay day;
  final bool isDraggingActive; // true when any card is being dragged globally
  final OnWorkoutMoved onWorkoutMoved;
  final VoidCallback? onGlobalDragStarted;
  final VoidCallback? onGlobalDragEnded;

  const TrainingDayRow({
    super.key,
    required this.day,
    required this.isDraggingActive,
    required this.onWorkoutMoved,
    this.onGlobalDragStarted,
    this.onGlobalDragEnded,
  });

  @override
  State<TrainingDayRow> createState() => _TrainingDayRowState();
}

class _TrainingDayRowState extends State<TrainingDayRow>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _borderOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _borderOpacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<WorkoutDragData>(
      onWillAcceptWithDetails: (details) {
        // Don't accept drops on the same date
        final isSameDay = _isSameDay(details.data.fromDate, widget.day.date);
        return !isSameDay;
      },
      onAcceptWithDetails: (details) {
        HapticFeedback.lightImpact();
        setState(() => _isHovered = false);
        widget.onWorkoutMoved(
          workout: details.data.workout,
          fromDate: details.data.fromDate,
          toDate: widget.day.date,
        );
      },
      onMove: (_) {
        if (!_isHovered) setState(() => _isHovered = true);
      },
      onLeave: (_) {
        setState(() => _isHovered = false);
      },
      builder: (context, candidateData, rejectedData) {
        final isAccepting = candidateData.isNotEmpty;
        final showDropZone = widget.isDraggingActive;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            color: isAccepting ? PlanColors.dropTargetBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isAccepting
                ? Border.all(color: PlanColors.dropTargetBorder, width: 1.5)
                : showDropZone && widget.day.workouts.isEmpty
                ? Border.all(
                    color: PlanColors.divider.withOpacity(0.0),
                    width: 1,
                  )
                : null,
          ),
          child: Stack(
            // mainAxisSize: MainAxisSize.min,
            alignment: Alignment.center,
            children: [
              ColoredBox(
                color: Colors.transparent,
                child: _buildDayHeader(isAccepting, showDropZone),
              ),
              // Cards
              if (widget.day.workouts.isNotEmpty)
                ColoredBox(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(65, 8, 7, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.day.workouts.map((workout) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: DraggableWorkoutCard(
                            workout: workout,
                            date: widget.day.date,
                            onGlobalDragStarted: widget.onGlobalDragStarted,
                            onGlobalDragEnded: widget.onGlobalDragEnded,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              // else if (isAccepting)
              //   _buildDropPlaceholder(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayHeader(bool isAccepting, bool showDropZone) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, headerBottomPad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Day label column
          SizedBox(
            width: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.day.dayAbbr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isAccepting
                        ? PlanColors.seaGreen
                        : PlanColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '${widget.day.date.day}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isAccepting
                        ? PlanColors.textPrimary
                        : PlanColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Drop hint on empty rows during drag
          if (widget.day.workouts.isEmpty && showDropZone)
            Expanded(
              child: AnimatedOpacity(
                opacity: isAccepting ? 1.0 : 0.45,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: isAccepting
                        ? PlanColors.dropTargetBg
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isAccepting
                          ? PlanColors.dropTargetBorder
                          : PlanColors.divider,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isAccepting ? 'Drop here' : 'Empty',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isAccepting
                            ? PlanColors.seaGreen
                            : PlanColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropPlaceholder() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(56, 0, 16, 12),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: PlanColors.dropTargetBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PlanColors.dropTargetBorder, width: 1.5),
        ),
        child: const Center(
          child: Text(
            'Drop workout here',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PlanColors.seaGreen,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // bottom padding for day header — less when workouts follow
  double get headerBottomPad => widget.day.workouts.isEmpty ? 14.0 : 4.0;
}
