import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inspire_me/app/views/home_screen.dart';
import 'package:inspire_me/utils/app_constants.dart';
import 'package:inspire_me/utils/app_theme.dart';

/// Branded splash screen shown on app launch before navigating to [HomeScreen].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;

  static const Duration _splashDuration = Duration(milliseconds: 2800);

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: _splashDuration,
    )..forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Get.off(
          () => const HomeScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 400),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF9F2), Color(0xFFFFE8D4), Color(0xFFFFDCC4)],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              _SparkleLogo()
                  .animate()
                  .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                  .scale(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1, 1),
                    duration: 700.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 28),
              Text(
                    'InspireMe',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightPrimary,
                      letterSpacing: -0.5,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.15, end: 0, curve: Curves.easeOut),
              const SizedBox(height: 10),
              Text(
                    AppConstants.splashTagline,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9E9E9E),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 350.ms, duration: 500.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
              const Spacer(flex: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, _) {
                    return _SplashProgressBar(
                      progress: _progressController.value,
                    );
                  },
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

/// Three sparkle stars with a soft orange glow.
class _SparkleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightPrimary.withValues(alpha: 0.28),
                  blurRadius: 36,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
          const Positioned(
            left: 18,
            bottom: 18,
            child: _SparkleStar(size: 22, color: Color(0xFFFFB347)),
          ),
          const _SparkleStar(size: 44, color: AppTheme.lightPrimary),
          const Positioned(
            right: 16,
            top: 12,
            child: _SparkleStar(size: 18, color: Color(0xFFFFB347)),
          ),
        ],
      ),
    );
  }
}

class _SparkleStar extends StatelessWidget {
  const _SparkleStar({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SparklePainter(color: color),
    );
  }
}

class _SparklePainter extends CustomPainter {
  _SparklePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final Path path = Path();
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double outer = size.width / 2;
    final double inner = outer * 0.28;

    for (int i = 0; i < 4; i++) {
      final double angle = (i * 90 - 90) * math.pi / 180;
      final double outerX = cx + outer * math.cos(angle);
      final double outerY = cy + outer * math.sin(angle);
      final double innerAngle1 = angle - 0.45;
      final double innerAngle2 = angle + 0.45;
      final double innerX1 = cx + inner * math.cos(innerAngle1);
      final double innerY1 = cy + inner * math.sin(innerAngle1);
      final double innerX2 = cx + inner * math.cos(innerAngle2);
      final double innerY2 = cy + inner * math.sin(innerAngle2);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX1, innerY1);
      path.lineTo(innerX2, innerY2);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SplashProgressBar extends StatelessWidget {
  const _SplashProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppTheme.lightPrimary.withValues(alpha: 0.15)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
