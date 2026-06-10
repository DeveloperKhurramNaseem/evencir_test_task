import 'package:flutter/material.dart';
import '../theme/theme.dart';

class HydrationCard extends StatelessWidget {
  final double currentLitres;
  final double targetLitres;
  final String? toastMessage;

  const HydrationCard({
    super.key,
    required this.currentLitres,
    required this.targetLitres,
    this.toastMessage,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentLitres / targetLitres).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();
    final currentMl = (currentLitres * 1000).round();

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //       // Left: percentage + label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Hydration',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Log Now',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                //       // Right: vertical progress bar
                // _VerticalWaterBar(
                //   progress: progress,
                //   currentMl: currentMl,
                //   targetLitres: targetLitres,
                // ),
              ],
            ),
          ),

          // Bottom toast/action bar
          if (toastMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.seaGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                toastMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VerticalWaterBar extends StatelessWidget {
  final double progress;
  final int currentMl;
  final double targetLitres;

  const _VerticalWaterBar({
    required this.progress,
    required this.currentMl,
    required this.targetLitres,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Labels
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${targetLitres.toStringAsFixed(0)} L',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
              //     const Spacer(),
              Text(
                '${currentMl == 0 ? '0' : currentMl} ml',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                '0 L',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          // const SizedBox(width: 6),
          // The bar itself
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(6),
          //   child: Container(
          //     width: 10,
          //     height: 90,
          //     decoration: BoxDecoration(
          //       color: AppColors.divider,
          //       borderRadius: BorderRadius.circular(6),
          //     ),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         // Filled portion (from bottom)
          //         FractionallySizedBox(
          //           heightFactor: progress,
          //           child: Container(
          //             decoration: const BoxDecoration(
          //               gradient: LinearGradient(
          //                 colors: [AppColors.blue, Color(0xFF3FC8E0)],
          //                 begin: Alignment.bottomCenter,
          //                 end: Alignment.topCenter,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
