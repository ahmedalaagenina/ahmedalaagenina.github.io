import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../../core/motion/spring_offset.dart';
import '../../core/motion/springs.dart';
import '../../theme/app_theme.dart';
import 'cursor_scope.dart';

/// A soft ring that trails the mouse and grows over interactive elements.
///
/// - Mouse only: it appears on the first mouse hover and hides on touch, so
///   phones and tablets never see it.
/// - The system cursor stays visible. The ring is decoration, never a
///   replacement for a precise pointer.
/// - It paints in its own [RepaintBoundary] layer, driven by a spring that
///   only ticks while moving, so following the mouse never repaints the page.
class CursorFollower extends StatefulWidget {
  const CursorFollower({super.key, required this.child});

  final Widget child;

  @override
  State<CursorFollower> createState() => _CursorFollowerState();
}

class _CursorFollowerState extends State<CursorFollower>
    with TickerProviderStateMixin {
  final _controller = CursorController();
  late final _position = SpringOffset(vsync: this, spring: Springs.follow);
  late final _grow = AnimationController.unbounded(vsync: this);
  final _visible = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTargetChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _position.dispose();
    _grow.dispose();
    _visible.dispose();
    super.dispose();
  }

  void _onTargetChanged() {
    _grow.animateWith(
      SpringSimulation(
        Springs.snappy,
        _grow.value,
        _controller.overTarget ? 1 : 0,
        _grow.velocity,
      ),
    );
  }

  void _onPointer(PointerEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      _visible.value = false;
      return;
    }
    if (!_visible.value) {
      _position.jumpTo(event.position);
      _visible.value = true;
    } else {
      _position.animateTo(event.position);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scoped = CursorScope(controller: _controller, child: widget.child);
    if (context.reduceMotion) return scoped;

    final t = context.tokens;
    return Listener(
      onPointerHover: _onPointer,
      onPointerMove: _onPointer,
      onPointerDown: _onPointer,
      child: MouseRegion(
        opaque: false,
        onExit: (_) => _visible.value = false,
        child: Stack(
          children: [
            scoped,
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _RingPainter(
                      position: _position,
                      grow: _grow,
                      visible: _visible,
                      idle: t.textMuted,
                      active: t.signal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.position,
    required this.grow,
    required this.visible,
    required this.idle,
    required this.active,
  }) : super(repaint: Listenable.merge([position, grow, visible]));

  final SpringOffset position;
  final Animation<double> grow;
  final ValueListenable<bool> visible;
  final Color idle;
  final Color active;

  @override
  void paint(Canvas canvas, Size size) {
    if (!visible.value) return;
    final g = grow.value.clamp(0.0, 1.2);
    final radius = 10 + 14 * g;
    final center = position.value;
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = active.withValues(alpha: 0.10 * g.clamp(0.0, 1.0)),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Color.lerp(
          idle.withValues(alpha: 0.5),
          active.withValues(alpha: 0.9),
          g.clamp(0.0, 1.0),
        )!,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.idle != idle || old.active != active;
}
