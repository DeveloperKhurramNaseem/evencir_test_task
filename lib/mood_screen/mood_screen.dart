import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MoodApp());
}

class MoodApp extends StatelessWidget {
  const MoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A14),
      ),
      home: const MoodScreen(),
    );
  }
}

// ─── Data ──────────────────────────────────────────────────────────────────

class MoodData {
  final String label;
  final String emoji;        // Unicode face fallback
  final Color faceColor;
  final List<Color> arcColors; // gradient segment colors
  final double startAngle;   // radians, 0 = right, going clockwise
  final double sweepAngle;   // radians

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
    arcColors: [Color(0xFF7EC8C8), Color(0xFF5BA4CF)],
    startAngle: -math.pi / 2,          // top
    sweepAngle: math.pi / 2,           // top → right
  ),
  MoodData(
    label: 'Happy',
    emoji: '😊',
    faceColor: Color(0xFFF5D08A),
    arcColors: [Color(0xFFF5A623), Color(0xFFFF6B6B)],
    startAngle: 0,                     // right
    sweepAngle: math.pi / 2,           // right → bottom
  ),
  MoodData(
    label: 'Anxious',
    emoji: '😟',
    faceColor: Color(0xFFB8C5E0),
    arcColors: [Color(0xFF9B59B6), Color(0xFF6C5CE7)],
    startAngle: math.pi / 2,           // bottom
    sweepAngle: math.pi / 2,           // bottom → left
  ),
  MoodData(
    label: 'Sad',
    emoji: '😔',
    faceColor: Color(0xFFA8B8D8),
    arcColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    startAngle: math.pi,               // left
    sweepAngle: math.pi / 2,           // left → top
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

class _MoodScreenState extends State<MoodScreen>
    with TickerProviderStateMixin {
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

    if (a >= -math.pi / 2 && a < 0) return 0;        // Calm
    if (a >= 0 && a < math.pi / 2) return 1;          // Happy
    if (a >= math.pi / 2 && a <= math.pi) return 2;   // Anxious
    return 3;                                          // Sad (top-left)
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
    final ringDiameter = size.width * 0.72;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: SafeArea(
        child: Column(
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
                      fontFamily: 'SF Pro Display',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start your day',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.45),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'How are you feeling at the\nMoment?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.3,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

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

            const SizedBox(height: 24),

            // ── Mood label ───────────────────────────────────────────
            FadeTransition(
              opacity: _labelFade,
              child: Center(
                child: Text(
                  mood.label,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),

            // ── Mood dots ────────────────────────────────────────────
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(kMoods.length, (i) {
                final isActive = i == _currentMoodIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isActive
                        ? kMoods[i].arcColors.first
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const Spacer(),

            // ── Continue button ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      mood.arcColors.first.withOpacity(0.9),
                      mood.arcColors.last.withOpacity(0.9),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: mood.arcColors.first.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {},
                    child: const SizedBox(
                      height: 58,
                      child: Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
      ),

      // ── Bottom Nav ───────────────────────────────────────────────────
      bottomNavigationBar: _BottomNav(activeMoodIndex: _currentMoodIndex),
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
      child: CustomPaint(
        painter: _FacePainter(mood: mood),
      ),
    );
  }
}

class _FacePainter extends CustomPainter {
  final MoodData mood;
  const _FacePainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final eyeColor = const Color(0xFF3D2C2C).withOpacity(0.8);
    final cheekColor = const Color(0xFFE88080).withOpacity(0.45);

    final eyePaint = Paint()..color = eyeColor;
    final cheekPaint = Paint()..color = cheekColor;

    switch (mood.label) {
      case 'Calm':
        // Closed happy eyes (arcs)
        _drawSmileEye(canvas, Offset(cx - size.width * 0.18, cy - size.height * 0.08), size.width * 0.13, eyePaint);
        _drawSmileEye(canvas, Offset(cx + size.width * 0.18, cy - size.height * 0.08), size.width * 0.13, eyePaint);
        // Tiny mouth
        _drawSmallSmile(canvas, Offset(cx, cy + size.height * 0.1), size.width * 0.12, eyePaint);
        break;

      case 'Happy':
        // Open circle eyes
        canvas.drawCircle(Offset(cx - size.width * 0.18, cy - size.height * 0.1), size.width * 0.055, eyePaint);
        canvas.drawCircle(Offset(cx + size.width * 0.18, cy - size.height * 0.1), size.width * 0.055, eyePaint);
        // Big smile
        _drawBigSmile(canvas, Offset(cx, cy + size.height * 0.06), size.width * 0.22, eyePaint);
        break;

      case 'Anxious':
        // Worried brows
        _drawWorriedEye(canvas, Offset(cx - size.width * 0.18, cy - size.height * 0.08), size.width * 0.11, eyePaint);
        _drawWorriedEye(canvas, Offset(cx + size.width * 0.18, cy - size.height * 0.08), size.width * 0.11, eyePaint);
        // Flat/worried mouth
        _drawFlatMouth(canvas, Offset(cx, cy + size.height * 0.12), size.width * 0.16, eyePaint);
        break;

      case 'Sad':
        // Droopy eyes
        canvas.drawCircle(Offset(cx - size.width * 0.18, cy - size.height * 0.08), size.width * 0.05, eyePaint);
        canvas.drawCircle(Offset(cx + size.width * 0.18, cy - size.height * 0.08), size.width * 0.05, eyePaint);
        // Frown
        _drawFrown(canvas, Offset(cx, cy + size.height * 0.16), size .width* 0.18, eyePaint);
        break;
    }

    // Rosy cheeks for all
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - size.width * 0.27, cy + size.height * 0.06), width: size.width * 0.16, height: size.height * 0.1), cheekPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + size.width * 0.27, cy + size.height * 0.06), width: size.width * 0.16, height: size.height * 0.1), cheekPaint);
  }

  void _drawSmileEye(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    final rect = Rect.fromCenter(center: center, width: r * 2, height: r * 2);
    path.addArc(rect, math.pi, math.pi);
    canvas.drawPath(path, paint..style = PaintingStyle.stroke..strokeWidth = r * 0.38..strokeCap = StrokeCap.round);
    paint.style = PaintingStyle.fill;
  }

  void _drawSmallSmile(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    final rect = Rect.fromCenter(center: center, width: r * 2, height: r * 1.2);
    path.addArc(rect, 0, math.pi);
    canvas.drawPath(path, paint..style = PaintingStyle.stroke..strokeWidth = r * 0.3..strokeCap = StrokeCap.round);
    paint.style = PaintingStyle.fill;
  }

  void _drawBigSmile(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    final rect = Rect.fromCenter(center: center, width: r * 2, height: r * 1.4);
    path.addArc(rect, 0, math.pi);
    canvas.drawPath(path, paint..style = PaintingStyle.stroke..strokeWidth = r * 0.28..strokeCap = StrokeCap.round);
    paint.style = PaintingStyle.fill;
  }

  void _drawWorriedEye(Canvas canvas, Offset center, double r, Paint paint) {
    canvas.drawOval(Rect.fromCenter(center: center, width: r * 1.8, height: r * 2.2),
        paint..style = PaintingStyle.fill);
  }

  void _drawFlatMouth(Canvas canvas, Offset center, double r, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: r * 2, height: r * 0.3), const Radius.circular(4)),
      paint..style = PaintingStyle.fill,
    );
  }

  void _drawFrown(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    final rect = Rect.fromCenter(center: center, width: r * 2, height: r * 1.2);
    path.addArc(rect, math.pi, math.pi);
    canvas.drawPath(path, paint..style = PaintingStyle.stroke..strokeWidth = r * 0.28..strokeCap = StrokeCap.round);
    paint.style = PaintingStyle.fill;
  }

  @override
  bool shouldRepaint(_FacePainter old) => old.mood.label != mood.label;
}

// ─── Ring Painter ──────────────────────────────────────────────────────────

class MoodRingPainter extends CustomPainter {
  final double handleAngle;
  final List<Color> colors;

  const MoodRingPainter({
    required this.handleAngle,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 22.0;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

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
      final inner = center + Offset(math.cos(angle), math.sin(angle)) * (radius - strokeWidth);
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

// ─── Bottom Nav ────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int activeMoodIndex;
  const _BottomNav({required this.activeMoodIndex});

  @override
  Widget build(BuildContext context) {
    final accentColor = kMoods[activeMoodIndex].arcColors.first;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1E),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.local_fire_department_outlined, label: 'Nutrition', isActive: false, accentColor: accentColor),
              _NavItem(icon: Icons.calendar_today_outlined, label: 'Plan', isActive: false, accentColor: accentColor),
              _NavItem(icon: Icons.sentiment_satisfied_outlined, label: 'Mood', isActive: true, accentColor: accentColor),
              _NavItem(icon: Icons.person_outline, label: 'Profile', isActive: false, accentColor: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color accentColor;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            icon,
            color: isActive ? accentColor : Colors.white.withOpacity(0.35),
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? accentColor : Colors.white.withOpacity(0.35),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
