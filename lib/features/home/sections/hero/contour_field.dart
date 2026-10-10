import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/motion/spring_offset.dart';
import '../../../../core/motion/springs.dart';
import '../../../../theme/app_theme.dart';

/// Where the pointer is over the hero, in local pixels, or null when absent.
typedef PointerTarget = ValueListenable<Offset?>;

/// Animated topographic background (see `shaders/contour.frag`).
///
/// Performance contract:
/// - the ticker runs only while [active] (hero on screen) and motion is
///   allowed; off screen the field costs nothing,
/// - one shader object is created once and only its uniforms change,
/// - it sits in its own [RepaintBoundary], so the text on top of it is never
///   repainted by the animation.
class ContourField extends StatefulWidget {
  const ContourField({super.key, required this.pointer, required this.active});

  final PointerTarget pointer;
  final bool active;

  @override
  State<ContourField> createState() => _ContourFieldState();
}

class _ContourFieldState extends State<ContourField>
    with TickerProviderStateMixin {
  // Loaded once for the whole app; null if shaders are unavailable.
  static final Future<ui.FragmentProgram?> _program =
      ui.FragmentProgram.fromAsset(
        'shaders/contour.frag',
      ).then<ui.FragmentProgram?>((p) => p).catchError((Object _) => null);

  ui.FragmentShader? _shader;
  late final Ticker _ticker = createTicker(_onTick);
  late final SpringOffset _pointer = SpringOffset(
    vsync: this,
    spring: Springs.gentle,
  );
  final _frame = ValueNotifier<int>(0);
  double _time = 0;
  double _presence = 0;
  Duration _lastTick = Duration.zero;
  Duration _lastPointerSeen = Duration.zero;
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _program.then((program) {
      if (!mounted || program == null) return;
      setState(() => _shader = program.fragmentShader());
    });
    widget.pointer.addListener(_onPointer);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTicker();
  }

  @override
  void didUpdateWidget(ContourField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pointer != widget.pointer) {
      oldWidget.pointer.removeListener(_onPointer);
      widget.pointer.addListener(_onPointer);
    }
    _syncTicker();
  }

  @override
  void dispose() {
    widget.pointer.removeListener(_onPointer);
    _ticker.dispose();
    _pointer.dispose();
    _frame.dispose();
    _shader?.dispose();
    super.dispose();
  }

  void _syncTicker() {
    final shouldRun = widget.active && !context.reduceMotion;
    if (shouldRun && !_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    } else if (!shouldRun && _ticker.isActive) {
      _ticker.stop();
    }
  }

  void _onPointer() {
    final p = widget.pointer.value;
    if (p != null) _pointer.animateTo(p);
  }

  void _onTick(Duration elapsed) {
    final dt = _lastTick == Duration.zero
        ? 1 / 60
        : (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    _time = (_time + dt) % 600; // wrap to keep float precision on mobile GPUs

    final hasPointer = widget.pointer.value != null;
    if (hasPointer) _lastPointerSeen = elapsed;

    // No pointer for a while (or a touch device): a gentle hill wanders
    // along a Lissajous path so the field still feels alive.
    final idle = elapsed - _lastPointerSeen > const Duration(seconds: 2);
    if (idle && _size != Size.zero) {
      final s = _time * 0.18;
      _pointer.animateTo(
        Offset(
          _size.width * (0.62 + 0.25 * math.sin(s * 1.3)),
          _size.height * (0.45 + 0.22 * math.sin(s * 0.9 + 1.1)),
        ),
      );
    }
    final targetPresence = hasPointer ? 1.0 : 0.55;
    _presence += (targetPresence - _presence) * (1 - math.exp(-dt * 3));
    _frame.value++;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final shader = _shader;
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          _size = constraints.biggest;
          if (shader == null) return ColoredBox(color: t.background);
          return CustomPaint(
            size: _size,
            painter: _ContourPainter(
              shader: shader,
              repaint: _frame,
              time: () => _time,
              pointer: () => _pointer.value,
              presence: () => _presence,
              background: t.background,
              line: t.textMuted,
              glow: t.signal,
              lineAlpha: context.isDark ? 0.13 : 0.15,
            ),
          );
        },
      ),
    );
  }
}

class _ContourPainter extends CustomPainter {
  _ContourPainter({
    required this.shader,
    required Listenable repaint,
    required this.time,
    required this.pointer,
    required this.presence,
    required this.background,
    required this.line,
    required this.glow,
    required this.lineAlpha,
  }) : super(repaint: repaint);

  final ui.FragmentShader shader;
  final double Function() time;
  final Offset Function() pointer;
  final double Function() presence;
  final Color background;
  final Color line;
  final Color glow;
  final double lineAlpha;

  @override
  void paint(Canvas canvas, Size size) {
    final p = pointer();
    var i = 0;
    void f(double v) => shader.setFloat(i++, v);
    void rgb(Color c) {
      f(c.r);
      f(c.g);
      f(c.b);
    }

    f(size.width);
    f(size.height);
    f(time());
    f(p.dx);
    f(p.dy);
    f(presence());
    rgb(background);
    rgb(line);
    rgb(glow);
    f(lineAlpha);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_ContourPainter old) =>
      old.background != background ||
      old.line != line ||
      old.glow != glow ||
      old.lineAlpha != lineAlpha ||
      old.shader != shader;
}
