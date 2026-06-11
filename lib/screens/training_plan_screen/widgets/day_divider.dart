import 'package:evencir_test/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DayDivider extends StatelessWidget {
  const DayDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 72),
      height: 0.5,
      color: PlanColors.divider,
    );
  }
}
