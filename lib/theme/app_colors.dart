import 'package:flutter/material.dart';

class AppColors {
  // Base palette
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF18181C);
  static const Color blue = Color(0xFF48A4E5);
  static const Color green = Color(0xFF20B76F);
  static const Color seaGreen = Color(0xFF32AAB7);
  static const Color darkSeaGreen = Color(0xFF1B3D45);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A8E);
  static const Color textMuted = Color(0xFF5A5A5E);

  // Card/Surface colors
  static const Color cardBackground = Color(0xFF18181C);
  static const Color cardBackgroundLight = Color(0xFF1E1E22);
  static const Color divider = Color(0xFF2A2A2E);

  // Progress gradient colors
  static const Color gradientStart = Color(0xFF7BBDE2);
  static const Color gradientMid = Color(0xFF69C0B1);
  static const Color gradientEnd = Color(0xFF60C198);

  // Gradient
  static const LinearGradient progressGradient = LinearGradient(
    colors: [gradientStart, gradientMid, gradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient seaGreenGradient = LinearGradient(
    colors: [seaGreen, Color(0xFF2A8F9A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}


class PlanColors {
  // Base
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF18181C);
  static const Color cardBg = Color(0xFF1E1E24);
  static const Color blue = Color(0xFF48A4E5);
  static const Color green = Color(0xFF20B76F);
  static const Color seaGreen = Color(0xFF32AAB7);
  static const Color divider = Color(0xFF2A2A30);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A8E);
  static const Color textMuted = Color(0xFF5A5A60);

  // Drag handle dots
  static const Color dragDot = Color(0xFF4A4A52);
  static const Color dragDotActive = Color(0xFF8A8A8E);

  // Week separator accent gradient
  static const LinearGradient weekAccentGradient = LinearGradient(
    colors: [Color(0xFF32AAB7), Color(0xFF20B76F)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Drop target highlight
  static const Color dropTargetBg = Color(0xFF1B3D45);
  static const Color dropTargetBorder = Color(0xFF32AAB7);
}