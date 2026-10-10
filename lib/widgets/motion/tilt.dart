import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../core/motion/spring_offset.dart';
import '../../core/motion/springs.dart';

/// Rotates its child in 3D toward an input point, with real perspective.
///
/// The input is a normalized offset in -1..1 on both axes. By default it
/// comes from the mouse position over the widget; pass [input] to drive it
/// from anything else (scroll position, page offset, a sibling's hover).
///
/// Perspective comes from setting entry (3, 2) of the matrix: it makes w
/// depend on z, so points rotated "toward" the viewer get bigger. Without
/// it, a rotation around X or Y just squashes the widget flat.
class Tilt extends StatefulWidget {
  const Tilt({
    super.key,
    required this.child,
    this.input,
    this.maxAngle = 0.14,
    this.perspective = 0.0011,
    this.overlayBuilder,
  });

  final Widget child;
  final ValueListenable<Offset>? input;

  /// Maximum rotation per axis, in radians (0.14 rad ≈ 8°).
  final double maxAngle;
  final double perspective;

  /// Optional layer painted on top of the child, receiving the current
  /// normalized tilt (for a glare that moves with the angle).
  final Widget Function(BuildContext context, Offset tilt)? overlayBuilder;

  @override
  State<Tilt> createState() => _TiltState();
}

class _TiltState extends State<Tilt> with SingleTickerProviderStateMixin {
  late final _tilt = SpringOffset(vsync: this, spring: Springs.gentle);

  @override
  void initState() {
    super.initState();
    widget.input?.addListener(_onInput);
  }

  @override
  void didUpdateWidget(Tilt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.input != widget.input) {
      oldWidget.input?.removeListener(_onInput);
      widget.input?.addListener(_onInput);
    }
  }

  @override
  void dispose() {
    widget.input?.removeListener(_onInput);
    _tilt.dispose();
    super.dispose();
  }

  void _onInput() => _tilt.animateTo(_clamp(widget.input!.value));

  Offset _clamp(Offset o) =>
      Offset(o.dx.clamp(-1.0, 1.0), o.dy.clamp(-1.0, 1.0));

  void _onHover(PointerHoverEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final size = box.size;
    _tilt.animateTo(
      _clamp(
        Offset(
          event.localPosition.dx / size.width * 2 - 1,
          event.localPosition.dy / size.height * 2 - 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return widget.child;

    Widget result = AnimatedBuilder(
      animation: _tilt,
      builder: (context, child) {
        final t = _tilt.value;
        final matrix = Matrix4.identity()
          ..setEntry(3, 2, widget.perspective)
          ..rotateX(-t.dy * widget.maxAngle)
          ..rotateY(t.dx * widget.maxAngle);
        final overlay = widget.overlayBuilder;
        return Transform(
          transform: matrix,
          alignment: Alignment.center,
          child: overlay == null
              ? child
              : Stack(
                  children: [
                    child!,
                    Positioned.fill(
                      child: IgnorePointer(child: overlay(context, t)),
                    ),
                  ],
                ),
        );
      },
      child: widget.child,
    );

    if (widget.input == null) {
      result = MouseRegion(
        opaque: false,
        onHover: _onHover,
        onExit: (_) => _tilt.animateTo(Offset.zero),
        child: result,
      );
    }
    return result;
  }
}
