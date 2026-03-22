import 'package:flutter/material.dart';
import 'package:mycv/theme/theme.dart';

/// A premium section title with shimmering gradient underline.
class SectionTitle extends StatefulWidget {
  final String title;
  final IconData? icon;

  const SectionTitle({
    super.key,
    required this.title,
    this.icon,
  });

  @override
  State<SectionTitle> createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        appTheme.colors.primary.withValues(alpha: 0.15),
                        const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon, color: appTheme.colors.primary, size: 22),
                ),
                const SizedBox(width: 14),
              ],
              Text(
                widget.title,
                style: appTheme.typography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: appTheme.colors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Animated shimmer underline
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              return Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + 2 * _shimmerController.value, 0),
                    end: Alignment(1 + 2 * _shimmerController.value, 0),
                    colors: [
                      appTheme.colors.primary.withValues(alpha: 0.3),
                      appTheme.colors.primary,
                      const Color(0xFF8B5CF6),
                      appTheme.colors.primary.withValues(alpha: 0.3),
                    ],
                    stops: const [0.0, 0.35, 0.65, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
