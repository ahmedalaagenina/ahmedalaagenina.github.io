import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A modern phone body drawn with plain decorations, no image assets: any
/// size is crisp, and the whole frame costs one cached picture.
///
/// The frame stays dark in both themes, like real hardware. [screen] fills
/// the display area and is clipped to its rounded corners.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({
    super.key,
    required this.screen,
    this.width = 300,
    this.glow = true,
    this.glowColor,
    this.lowCost = false,
  });

  final Widget screen;
  final double width;

  /// Soft accent light under the phone. Off for small thumbnails.
  final bool glow;

  /// Glow color; defaults to the accent.
  final Color? glowColor;

  /// One small shadow instead of two large blurs. CanvasKit has no raster
  /// cache, so a tilting phone replays its blurs every frame; on phones,
  /// where several frames are on screen while scrolling, that adds up.
  final bool lowCost;

  /// Height / width of a current 6.1" phone, rounded.
  static const double aspectRatio = 2.12;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final height = width * aspectRatio;
    final bezel = width * 0.034;
    final outerRadius = width * 0.16;
    final innerRadius = outerRadius - bezel;

    // RepaintBoundary: the frame and its shadows are rasterized once and
    // reused while a parent Transform tilts it every frame.
    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Side buttons, drawn first so the body overlaps them.
            for (final (top, h, left) in [
              (0.17, 0.05, true),
              (0.25, 0.09, true),
              (0.36, 0.09, true),
              (0.27, 0.14, false),
            ])
              Positioned(
                top: height * top,
                left: left ? -2 : null,
                right: left ? null : -2,
                child: Container(
                  width: 4,
                  height: height * h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B3243),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            Container(
              width: width,
              height: height,
              padding: EdgeInsets.all(bezel),
              decoration: BoxDecoration(
                color: t.phoneBody,
                borderRadius: BorderRadius.circular(outerRadius),
                border: Border.all(color: const Color(0xFF353D50), width: 1.2),
                boxShadow: lowCost
                    ? [
                        BoxShadow(
                          color: (glowColor ?? t.signal).withValues(
                            alpha: context.isDark ? 0.18 : 0.12,
                          ),
                          blurRadius: width * 0.12,
                          offset: Offset(0, width * 0.06),
                        ),
                      ]
                    : [
                        if (glow)
                          BoxShadow(
                            color: (glowColor ?? t.signal).withValues(
                              alpha: context.isDark ? 0.22 : 0.16,
                            ),
                            blurRadius: width * 0.3,
                            spreadRadius: -width * 0.04,
                            offset: Offset(0, width * 0.12),
                          ),
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: context.isDark ? 0.45 : 0.2,
                          ),
                          blurRadius: width * 0.1,
                          offset: Offset(0, width * 0.06),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(innerRadius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Own layer: screen transitions repaint only the
                    // screen, never the blurred shadows of the frame.
                    RepaintBoundary(child: screen),
                    // Dynamic island.
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: width * 0.03),
                        child: Container(
                          width: width * 0.3,
                          height: width * 0.085,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(width),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
