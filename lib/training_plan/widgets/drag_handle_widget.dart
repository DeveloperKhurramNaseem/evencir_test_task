import 'package:flutter/material.dart';
import '../theme/plan_colors.dart';

/// Six-dot (2×3 grid) drag handle — identical to the one in the screenshot
class DragHandleWidget extends StatelessWidget {
  final bool isActive;

  const DragHandleWidget({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? PlanColors.dragDotActive : PlanColors.dragDot;
    return SizedBox(
      width: 14,
      height: 22,
      child: Column(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (row) {
          return Row(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (col) {
              return Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              );
            }),
          );
        }),
      ),
    );
  }
}
