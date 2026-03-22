import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mycv/theme/theme.dart';

/// Animated floating orbs background — creates a living, breathing backdrop.
class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late final List<_FloatingOrb> _orbs;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    final rng = Random(42);
    _orbs = List.generate(6, (i) {
      return _FloatingOrb(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        radius: 80 + rng.nextDouble() * 180,
        speedX: (rng.nextDouble() - 0.5) * 0.3,
        speedY: (rng.nextDouble() - 0.5) * 0.3,
        colorIndex: i,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final isDark = context.isDarkMode;

    final orbColors = isDark
        ? [
            const Color(0xFF30B8F6).withValues(alpha: 0.08),
            const Color(0xFF6366F1).withValues(alpha: 0.06),
            const Color(0xFF8B5CF6).withValues(alpha: 0.05),
            const Color(0xFF06B6D4).withValues(alpha: 0.07),
            const Color(0xFF3B82F6).withValues(alpha: 0.04),
            const Color(0xFFA855F7).withValues(alpha: 0.05),
          ]
        : [
            // Light mode: softer, more pastel-blue tints
            const Color(0xFF0553B1).withValues(alpha: 0.06),
            const Color(0xFF6366F1).withValues(alpha: 0.05),
            const Color(0xFF8B5CF6).withValues(alpha: 0.04),
            const Color(0xFF0EA5E9).withValues(alpha: 0.06),
            const Color(0xFF3B82F6).withValues(alpha: 0.04),
            const Color(0xFFA855F7).withValues(alpha: 0.03),
          ];

    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      appTheme.colors.background,
                      const Color(0xFF0D1321),
                      const Color(0xFF0B0F19),
                    ]
                  : [
                      const Color(0xFFF8FAFC),
                      const Color(0xFFF0F4FF),
                      const Color(0xFFEEF2FF),
                    ],
            ),
          ),
        ),
        // Floating orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _OrbPainter(
                orbs: _orbs,
                colors: orbColors,
                progress: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class _FloatingOrb {
  final double x;
  final double y;
  final double radius;
  final double speedX;
  final double speedY;
  final int colorIndex;

  const _FloatingOrb({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.colorIndex,
  });
}

class _OrbPainter extends CustomPainter {
  final List<_FloatingOrb> orbs;
  final List<Color> colors;
  final double progress;

  _OrbPainter({
    required this.orbs,
    required this.colors,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final orb in orbs) {
      final dx = (orb.x + sin(progress * 2 * pi + orb.colorIndex) * orb.speedX) * size.width;
      final dy = (orb.y + cos(progress * 2 * pi + orb.colorIndex * 0.7) * orb.speedY) * size.height;

      final paint = Paint()
        ..color = colors[orb.colorIndex % colors.length]
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, orb.radius * 0.6);

      canvas.drawCircle(Offset(dx, dy), orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
