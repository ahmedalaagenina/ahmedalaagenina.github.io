import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Glassmorphic card with an optional hover lift + accent border glow.
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool hoverable;
  final VoidCallback? onTap;
  final double radius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.hoverable = true,
    this.onTap,
    this.radius = 20,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final lifted = _hovered && widget.hoverable;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final restingShadow = BoxShadow(
      color: isDark
          ? Colors.black.withValues(alpha: .35)
          : const Color(0xFF101B3A).withValues(alpha: .06),
      blurRadius: 20,
      offset: const Offset(0, 6),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, lifted ? -4 : 0, 0),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: t.glassFill,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
              color: lifted
                  ? t.accentA.withValues(alpha: .55)
                  : t.glassBorder,
            ),
            boxShadow: lifted
                ? [
                    restingShadow,
                    BoxShadow(
                      color: t.accentA.withValues(alpha: .16),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [restingShadow],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
