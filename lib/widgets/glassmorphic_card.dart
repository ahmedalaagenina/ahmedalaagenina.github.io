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
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: widget.borderRadius,
                  border: Border.all(
                    color: _isHovered
                        ? glow.withValues(alpha: isDark ? 0.5 : 0.4)
                        : isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : appTheme.colors.outlineVariant.withValues(alpha: 0.5),
                    width: _isHovered ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    // Outer glow on hover
                    if (_isHovered)
                      BoxShadow(
                        color: glow.withValues(alpha: isDark ? 0.2 : 0.12),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    // Depth shadow — stronger in light mode
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.06),
                      blurRadius: isDark ? 16 : 24,
                      offset: const Offset(0, 6),
                    ),
                    // Light mode extra soft shadow
                    if (!isDark)
                      BoxShadow(
                        color: appTheme.colors.primary.withValues(alpha: 0.04),
                        blurRadius: 40,
                        offset: const Offset(0, 12),
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
