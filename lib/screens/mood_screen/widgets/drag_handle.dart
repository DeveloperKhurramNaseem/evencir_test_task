import 'package:flutter/material.dart';
import 'dart:math' as math;

class DragHandle extends StatelessWidget {
  final double angle;
  final double radius;
  final Offset center;

  const DragHandle({super.key, 
    required this.angle,
    required this.radius,
    required this.center,
  });

  @override
  Widget build(BuildContext context) {
    const handleR = 22.0;
    const ringStroke = 22.0;
    final effectiveRadius = radius - ringStroke / 2;

    final dx = math.cos(angle) * effectiveRadius;
    final dy = math.sin(angle) * effectiveRadius;

    return Positioned(
      left: center.dx + dx - handleR,
      top: center.dy + dy - handleR,
      child: Container(
        width: handleR * 2,
        height: handleR * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.92),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2C2C40).withOpacity(0.85),
            ),
            child: const Center(
              child: Text(
                'R',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
