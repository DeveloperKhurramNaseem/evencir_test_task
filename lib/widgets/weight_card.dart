import 'package:flutter/material.dart';
import '../theme/theme.dart';

class WeightCard extends StatelessWidget {
  final double weight;
  final double change;

  const WeightCard({super.key, required this.weight, required this.change});

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                weight.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 3),
              const Text(
                'kg',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green.withAlpha(80),
                ),
                child: Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: AppColors.green,
                  size: 11,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '${isPositive ? '+' : ''}${change.toStringAsFixed(1)}kg',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Weight',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
