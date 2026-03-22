import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mycv/theme/theme.dart';

/// A premium glassmorphic card with backdrop blur, gradient border,
/// outer glow, and hover animation (scale + intensified glow).
class GlassmorphicCard extends StatefulWidget {
  final Widget child;
  final Color? glowColor;
  final double blurAmount;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool enableHover;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.glowColor,
    this.blurAmount = 16.0,
    this.onTap,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.enableHover = true,
  });

  @override
  State<GlassmorphicCard> createState() => _GlassmorphicCardState();
}

class _GlassmorphicCardState extends State<GlassmorphicCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final isDark = context.isDarkMode;
    final glow = widget.glowColor ?? appTheme.colors.primary;

    final bgOpacity = isDark ? 0.08 : 0.55;
    final borderOpacity = _isHovered ? 0.5 : 0.1;
    final scale = _isHovered && widget.enableHover ? 1.02 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(scale, scale, 1.0),
        transformAlignment: Alignment.center,
        child: GestureDetector(
          onTap: widget.onTap,
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.blurAmount,
                sigmaY: widget.blurAmount,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: widget.padding,
                decoration: BoxDecoration(
                  // Gradient background for premium feel
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Colors.white.withValues(alpha: bgOpacity + 0.02),
                            Colors.white.withValues(alpha: bgOpacity),
                          ]
                        : [
                            appTheme.colors.surface.withValues(alpha: bgOpacity + 0.1),
                            appTheme.colors.surface.withValues(alpha: bgOpacity),
                          ],
                  ),
                  borderRadius: widget.borderRadius,
                  border: Border.all(
                    color: _isHovered
                        ? glow.withValues(alpha: borderOpacity)
                        : (isDark ? Colors.white : appTheme.colors.outline).withValues(alpha: 0.08),
                    width: _isHovered ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    // Outer glow
                    BoxShadow(
                      color: glow.withValues(alpha: _isHovered ? 0.2 : 0.0),
                      blurRadius: 28,
                      spreadRadius: 2,
                    ),
                    // Subtle depth shadow
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
