import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/training_models.dart';
import '../theme/plan_colors.dart';
import 'drag_handle_widget.dart';
import 'workout_category_chip.dart';

/// Data payload carried during a drag
class WorkoutDragData {
  final WorkoutEntry workout;
  final DateTime fromDate;

  const WorkoutDragData({required this.workout, required this.fromDate});
}

/// The visual card shown both in place and as the drag feedback
class WorkoutCardContent extends StatelessWidget {
  final WorkoutEntry workout;
  final bool isDragging;
  final bool isHandleActive;

  const WorkoutCardContent({
    super.key,
    required this.workout,
    this.isDragging = false,
    this.isHandleActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isDragging
            ? PlanColors.cardBg.withOpacity(0.85)
            : PlanColors.cardBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(1),
          bottomLeft: Radius.circular(1),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Left accent bar ─────────────────────────
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: workout.category.chipColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),

            // ── Drag handle ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: DragHandleWidget(isActive: isHandleActive),
            ),

            // ── Card body ───────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WorkoutCategoryChip(category: workout.category),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            workout.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: PlanColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          workout.durationRange,
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
            ),
          ],
        ),
      ),
    );
  }
}

/// Full draggable workout card — wraps [WorkoutCardContent] with
/// LongPressDraggable on the drag-handle area only
class DraggableWorkoutCard extends StatefulWidget {
  final WorkoutEntry workout;
  final DateTime date;

  /// Called when this card starts being dragged (to animate the placeholder)
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;

  /// Global drag state — notifies screen-level state to show drop zones
  final VoidCallback? onGlobalDragStarted;
  final VoidCallback? onGlobalDragEnded;

  const DraggableWorkoutCard({
    super.key,
    required this.workout,
    required this.date,
    this.onDragStarted,
    this.onDragEnd,
    this.onGlobalDragStarted,
    this.onGlobalDragEnded,
  });

  @override
  State<DraggableWorkoutCard> createState() => _DraggableWorkoutCardState();
}

class _DraggableWorkoutCardState extends State<DraggableWorkoutCard> {
  bool _isDragging = false;
  bool _isHandleActive = false;

  @override
  Widget build(BuildContext context) {
    final dragData = WorkoutDragData(
      workout: widget.workout,
      fromDate: widget.date,
    );

    return LongPressDraggable<WorkoutDragData>(
      data: dragData,
      delay: const Duration(milliseconds: 200),
      axis: null, // free movement
      onDragStarted: () {
        HapticFeedback.mediumImpact();
        setState(() {
          _isDragging = true;
          _isHandleActive = true;
        });
        widget.onDragStarted?.call();
        widget.onGlobalDragStarted?.call();
      },
      onDragEnd: (_) {
        setState(() {
          _isDragging = false;
          _isHandleActive = false;
        });
        widget.onDragEnd?.call();
        widget.onGlobalDragEnded?.call();
      },
      onDraggableCanceled: (_, __) {
        setState(() {
          _isDragging = false;
          _isHandleActive = false;
        });
        widget.onDragEnd?.call();
        widget.onGlobalDragEnded?.call();
      },
      // The ghost that follows the finger
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          // Match the card width based on screen; we use a fixed width for feedback
          width:
              MediaQuery.of(context).size.width -
              32 -
              56, // screen - padding - day column
          child: WorkoutCardContent(
            workout: widget.workout,
            isDragging: true,
            isHandleActive: true,
          ),
        ),
      ),
      // The placeholder left behind in the original slot
      childWhenDragging: AnimatedOpacity(
        opacity: _isDragging ? 0.25 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: WorkoutCardContent(
          workout: widget.workout,
          isHandleActive: false,
        ),
      ),
      child: WorkoutCardContent(
        workout: widget.workout,
        isHandleActive: _isHandleActive,
      ),
    );
  }
}
