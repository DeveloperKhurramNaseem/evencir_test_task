import 'dart:math' as math;
import 'package:evencir_test/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoodData {
  final String label;
  final String emoji; // Unicode face fallback
  final Color faceColor;
  final List<Color> arcColors; // gradient segment colors
  final double startAngle; // radians, 0 = right, going clockwise
  final double sweepAngle; // radians

  const MoodData({
    required this.label,
    required this.emoji,
    required this.faceColor,
    required this.arcColors,
    required this.startAngle,
    required this.sweepAngle,
  });
}

/// Four moods mapped to arc quadrants (clockwise from top-right)
const List<MoodData> kMoods = [
  MoodData(
    label: 'Calm',
    emoji: '😌',
    faceColor: Color(0xFFF5C8A8),
    // arcColors: [Color(0xFF7EC8C8), Color(0xFF5BA4CF)],
    arcColors: [Color(0xFF6EB9AD)],
    startAngle: -math.pi / 2, // top
    sweepAngle: math.pi / 2, // top → right
  ),
  MoodData(
    label: 'Content',
    emoji: '😊',
    faceColor: Color(0xFFF5D08A),
    // arcColors: [Color(0xFFF5A623), Color(0xFFFF6B6B)],
arcColors: [Color(0xFFC9BBEF)],
    startAngle: 0, // right
    sweepAngle: math.pi / 2, // right → bottom
  ),
  MoodData(
    label: 'Peaceful',
    emoji: '😟',
    faceColor: Color(0xFFB8C5E0),
    // arcColors: [Color(0xFF9B59B6), Color(0xFF6C5CE7)],
    arcColors: [Color(0xFF28DB3)],
    startAngle: math.pi / 2, // bottom
    sweepAngle: math.pi / 2, // bottom → left
  ),
  MoodData(
    label: 'Happy',
    emoji: '😔',
    faceColor: Color(0xFFA8B8D8),
    arcColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    startAngle: math.pi, // left
    sweepAngle: math.pi / 2, // left → top
  ),
];

/// Full arc gradient stops (all four segments merged, clockwise from top)
final List<Color> kArcGradient = [
  const Color(0xFF7EC8C8), // teal  (top)
  const Color(0xFFF5A623), // orange
  const Color(0xFFFF6B6B), // coral (right → bottom)
  const Color(0xFF9B59B6), // purple
  const Color(0xFF6C5CE7), // indigo (bottom → left)
  const Color(0xFF764BA2), // violet
  const Color(0xFF7EC8C8), // back to teal (wrap)
];

// ─── Screen ────────────────────────────────────────────────────────────────

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> with TickerProviderStateMixin {
  // Drag angle: -π/2 = top (Calm default)
  double _handleAngle = -math.pi / 2;

  late AnimationController _faceController;
  late Animation<double> _faceScale;
  late AnimationController _labelController;
  late Animation<double> _labelFade;

  int _currentMoodIndex = 0;

  @override
  void initState() {
    super.initState();
    _faceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _faceScale = CurvedAnimation(
      parent: _faceController,
      curve: Curves.elasticOut,
    );
    _faceController.forward();

    _labelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _labelFade = CurvedAnimation(
      parent: _labelController,
      curve: Curves.easeInOut,
    );
    _labelController.forward();
  }

  @override
  void dispose() {
    _faceController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  int _angleToMoodIndex(double angle) {
    // Normalize angle to [-π, π]
    double a = angle;
    while (a > math.pi) a -= 2 * math.pi;
    while (a < -math.pi) a += 2 * math.pi;

    // Map to mood index:
    // Calm:    -π   to  -π/2   (top half, left quad) → actually top = -π/2
    // We divide the circle into 4 equal sectors starting from top (-π/2)
    // Sector 0 (Calm):   -π/2  ..  0          (top-right)
    // Sector 1 (Happy):   0    ..  π/2        (bottom-right)
    // Sector 2 (Anxious): π/2  ..  π          (bottom-left)
    // Sector 3 (Sad):    -π   .. -π/2        (top-left)

    if (a >= -math.pi / 2 && a < 0) return 0; // Calm
    if (a >= 0 && a < math.pi / 2) return 1; // Happy
    if (a >= math.pi / 2 && a <= math.pi) return 2; // Anxious
    return 3; // Sad (top-left)
  }

  void _onDragUpdate(DragUpdateDetails details, Offset center) {
    final dx = details.localPosition.dx - center.dx;
    final dy = details.localPosition.dy - center.dy;
    final newAngle = math.atan2(dy, dx);

    final newIndex = _angleToMoodIndex(newAngle);
    if (newIndex != _currentMoodIndex) {
      HapticFeedback.selectionClick();
      _faceController.forward(from: 0);
      _labelController.forward(from: 0);
      setState(() {
        _currentMoodIndex = newIndex;
      });
    }

    setState(() {
      _handleAngle = newAngle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mood = kMoods[_currentMoodIndex];
    final size = MediaQuery.of(context).size;
    final ringDiameter = size.width * 0.62;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/mood_bg.png'),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mood',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'Start your day',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: const Text(
                        'How are you feeling at the\nMoment?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.3,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Mood Ring + Face ─────────────────────────────────────
              Center(
                child: SizedBox(
                  width: ringDiameter + 60,
                  height: ringDiameter + 60,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final center = Offset(
                        constraints.maxWidth / 2,
                        constraints.maxHeight / 2,
                      );
                      return GestureDetector(
                        onPanUpdate: (d) => _onDragUpdate(d, center),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Gradient arc ring
                            CustomPaint(
                              size: Size(ringDiameter, ringDiameter),
                              painter: MoodRingPainter(
                                handleAngle: _handleAngle,
                                colors: kArcGradient,
                              ),
                            ),

                            // Face card
                            ScaleTransition(
                              scale: _faceScale,
                              child: _MoodFace(
                                mood: mood,
                                size: ringDiameter * 0.44,
                              ),
                            ),

                            // Draggable handle
                            _DragHandle(
                              angle: _handleAngle,
                              radius: ringDiameter / 2,
                              center: center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ── Mood label ───────────────────────────────────────────
              FadeTransition(
                opacity: _labelFade,
                child: Center(
                  child: Text(
                    mood.label,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // ── Continue button ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.textPrimary,
                    // gradient: LinearGradient(
                    //   colors: [
                    //     mood.arcColors.first.withOpacity(0.9),
                    //     mood.arcColors.last.withOpacity(0.9),
                    //   ],
                    // ),
                    boxShadow: [
                      // BoxShadow(
                      //   color: mood.arcColors.first.withOpacity(0.35),
                      //   blurRadius: 20,
                      //   offset: const Offset(0, 6),
                      // ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: const SizedBox(
                        height: 55,
                        child: Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Mood Face Widget ──────────────────────────────────────────────────────

class _MoodFace extends StatelessWidget {
  final MoodData mood;
  final double size;

  const _MoodFace({required this.mood, required this.size});

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

// ─── Ring Painter ──────────────────────────────────────────────────────────

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

// ─── Drag Handle ───────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  final double angle;
  final double radius;
  final Offset center;

  const _DragHandle({
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

