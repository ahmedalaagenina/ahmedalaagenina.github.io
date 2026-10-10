import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../core/motion/spring_offset.dart';
import '../../core/motion/springs.dart';

/// Pulls its child toward the mouse while hovered, then lets go with a
/// small spring wobble.
///
/// Mouse only (touch has no hover), and disabled with reduced motion.
class Magnetic extends StatefulWidget {
  const Magnetic({
    super.key,
    required this.child,
    this.strength = 0.3,
    this.maxOffset = 10,
  });

  final Widget child;

  /// How much of the pointer's distance from the center the child follows.
  final double strength;

  /// Hard limit on the displacement, in logical pixels.
  final double maxOffset;

  @override
  State<Magnetic> createState() => _MagneticState();
}

class _MagneticState extends State<Magnetic>
    with SingleTickerProviderStateMixin {
  late final _offset = SpringOffset(vsync: this, spring: Springs.snappy);

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  void _onHover(PointerHoverEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final delta =
        (event.localPosition - box.size.center(Offset.zero)) * widget.strength;
    final distance = delta.distance;
    final clamped = distance > widget.maxOffset
        ? delta * (widget.maxOffset / distance)
        : delta;
    _offset.animateTo(clamped, spring: Springs.snappy);
  }

  void _onExit(PointerExitEvent _) =>
      _offset.animateTo(Offset.zero, spring: Springs.playful);

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return widget.child;
    return MouseRegion(
      opaque: false,
      onHover: _onHover,
      onExit: _onExit,
      // Own layer: following the mouse repaints only this button.
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _offset,
          builder: (context, child) =>
              Transform.translate(offset: _offset.value, child: child),
          child: widget.child,
        ),
      ),
    );
  }
}
