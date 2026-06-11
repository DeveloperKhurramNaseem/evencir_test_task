import 'package:evencir_test/screens/mood_screen/mood_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MoodFace extends StatelessWidget {
  final MoodData mood;
  final double size;

  const MoodFace({super.key, required this.mood, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: mood.faceColor,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: mood.faceColor.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      // child: CustomPaint(painter: _FacePainter(mood: mood)),
      child: Builder(
        builder: (context) {
          if (mood.label == 'Calm') {
            return SvgPicture.asset('assets/images/calm.svg');
          } else if (mood.label == 'Content') {
            return SvgPicture.asset('assets/images/content.svg');
          } else if (mood.label == 'Peaceful') {
            return SvgPicture.asset('assets/images/peaceful.svg');
          } else {
            return SvgPicture.asset('assets/images/happy.svg');
          }
        },
      ),
    );
  }
}