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
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 7,
                  decoration: BoxDecoration(
                    gradient: AppColors.seaGreenGradient,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                ),
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
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
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
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
