import 'package:flutter/material.dart';
import '../theme/theme.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String date;
  final String duration;
  final VoidCallback? onTap;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.date,
    required this.duration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.seaGreenGradient,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 100,
            margin: EdgeInsets.only(left: 7),
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(1),
                bottomLeft: Radius.circular(1),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                // Accent left bar
                // Container(
                //   width: 7,
                //   height: 80,
                //   decoration: BoxDecoration(
                //     gradient: AppColors.seaGreenGradient,
                //     borderRadius: const BorderRadius.only(
                //       topLeft: Radius.circular(16),
                //       bottomLeft: Radius.circular(16),
                //     ),
                //   ),
                // ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$date · $duration',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Arrow
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
