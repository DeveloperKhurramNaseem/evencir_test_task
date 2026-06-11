import 'package:flutter/material.dart';
import 'dart:math' as math;

class MoodRingPainter extends CustomPainter {
  final double handleAngle;
  final List<Color> colors;

  const MoodRingPainter({required this.handleAngle, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 22.0;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    // Background track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    canvas.drawCircle(center, radius - strokeWidth / 2, trackPaint);

    // Gradient arc (full circle)
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + 2 * math.pi,
      colors: colors,
    );

    final arcPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, arcPaint);

    // Subtle tick marks
    final tickPaint = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..strokeWidth = 1.5;
    const tickCount = 48;
    for (int i = 0; i < tickCount; i++) {
      final angle = (2 * math.pi / tickCount) * i - math.pi / 2;
      final inner =
          center +
          Offset(math.cos(angle), math.sin(angle)) * (radius - strokeWidth);
      final outer = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawLine(inner, outer, tickPaint);
    }
  }

  @override
  bool shouldRepaint(MoodRingPainter old) => old.handleAngle != handleAngle;
}