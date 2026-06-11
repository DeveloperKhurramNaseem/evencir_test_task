import 'package:evencir_test/models/training_models.dart';
import 'package:flutter/material.dart';

class WorkoutCategoryChip extends StatelessWidget {
  final WorkoutCategory category;

  const WorkoutCategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: category.chipColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, color: category.chipColor, size: 11),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: category.chipColor,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
