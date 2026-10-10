import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../core/motion/springs.dart';

/// Springs its child into place the first time it scrolls into view.
///
/// Used deliberately, not on every section: only where an entrance carries
/// meaning (timeline cards arriving in order).
///
/// Once the entrance has played, the widget stops wrapping its child at all
/// (no detector, no transform, no opacity layer), so a revealed element
/// costs exactly what the plain child costs.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 28),
    this.scale = 1,
    this.threshold = 0.12,
    this.spring,
  });

  final Widget child;
  final Duration delay;

  /// Where the child starts, relative to its final position.
  final Offset offset;

  /// Starting scale (1 = no scale).
  final double scale;
  final double threshold;
  final SpringDescription? spring;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _progress = AnimationController.unbounded(
    vsync: this,
  );
  late final Key _key = UniqueKey();

  /// Lets the child keep its State when the wrappers are dropped after the
  /// entrance: Flutter *reparents* a GlobalKey'd subtree instead of
  /// rebuilding it, so e.g. an expanded panel inside stays expanded.
  final GlobalKey _childKey = GlobalKey();
  bool _started = false;
  bool _done = false;

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  void _onVisibility(VisibilityInfo info) {
    if (_started || info.visibleFraction < widget.threshold) return;
    _started = true;
    Future.delayed(widget.delay, () {
      if (!mounted) return;
      _progress
          .animateWith(
            SpringSimulation(widget.spring ?? Springs.gentle, 0, 1, 0),
          )
          .whenComplete(() {
            if (mounted) setState(() => _done = true);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = KeyedSubtree(key: _childKey, child: widget.child);
    if (_done || context.reduceMotion) return child;

    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: _onVisibility,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) {
          final t = _progress.value;
          final scale = widget.scale + (1 - widget.scale) * t;
          return Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform(
              transform: Matrix4.translationValues(
                widget.offset.dx * (1 - t),
                widget.offset.dy * (1 - t),
                0,
              )..scaleByDouble(scale, scale, 1, 1),
              alignment: Alignment.center,
              child: child,
            ),
          );
        },
        // Cached during the entrance: only the opacity/transform layers
        // change per frame, the content's paint is recorded once.
        child: RepaintBoundary(child: child),
      ),
    );
  }
}
