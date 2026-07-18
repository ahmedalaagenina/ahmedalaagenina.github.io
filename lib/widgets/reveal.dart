import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fades + slides its child in the first time it scrolls into view.
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset offset;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 36),
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  bool _played = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibility(VisibilityInfo info) {
    if (_played || info.visibleFraction < 0.08) return;
    _played = true;
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    return VisibilityDetector(
      key: ValueKey(hashCode),
      onVisibilityChanged: _onVisibility,
      child: AnimatedBuilder(
        animation: _curve,
        builder: (context, child) => Opacity(
          opacity: _curve.value,
          child: Transform.translate(
            offset: Offset.lerp(widget.offset, Offset.zero, _curve.value)!,
            child: child,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
