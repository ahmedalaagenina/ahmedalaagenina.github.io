import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

import '../../../../../core/motion/springs.dart';
import '../../../../../data/copy.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../../widgets/pressable.dart';
import '../logic/page_geometry.dart';

/// Drag a signature field onto a fake PDF page, then sign it.
///
/// Nods to iDara Sign's real problems: the field lives in PDF coordinates
/// (bottom-left origin) and is converted for display, the drag must win
/// against page scrolling on touch screens, and keyboard users get the
/// same control with the arrow keys.
class SignDemo extends StatefulWidget {
  const SignDemo({super.key, required this.copy});

  final SignCopy copy;

  @override
  State<SignDemo> createState() => _SignDemoState();
}

class _SignDemoState extends State<SignDemo> with TickerProviderStateMixin {
  static const _page = Size(612, 792); // US Letter, in points
  static const _field = Size(176, 58);
  static const _start = Offset(396, 640);

  /// The signature line drawn on the page (PDF y of the field's bottom).
  static const _lineY = 118.0;

  Offset _origin = _start;
  bool _signed = false;
  bool _dragging = false;
  bool _focused = false;
  PageGeometry? _geometry;

  late final AnimationController _ink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final AnimationController _snap = AnimationController.unbounded(
    vsync: this,
  );
  final _focusNode = FocusNode(debugLabel: 'signature field');

  @override
  void initState() {
    super.initState();
    _snap.addListener(() {
      setState(() => _origin = Offset(_origin.dx, _snap.value));
    });
  }

  @override
  void dispose() {
    _ink.dispose();
    _snap.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _moveBy(Offset screenDelta) {
    final g = _geometry;
    if (g == null) return;
    _snap.stop();
    setState(() => _origin = g.moveBy(_origin, _field, screenDelta));
  }

  void _moveByPoints(Offset pdfDelta) {
    _snap.stop();
    final g = _geometry;
    if (g == null) return;
    setState(() => _origin = g.clamp(_origin + pdfDelta, _field));
  }

  /// Released close to the signature line: spring onto it.
  void _maybeSnap() {
    if ((_origin.dy - _lineY).abs() > 40) return;
    if (context.reduceMotion) {
      setState(() => _origin = Offset(_origin.dx, _lineY));
      return;
    }
    _snap.value = _origin.dy;
    _snap.animateWith(SpringSimulation(Springs.playful, _origin.dy, _lineY, 0));
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final step = HardwareKeyboard.instance.isShiftPressed ? 24.0 : 6.0;
    final delta = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowLeft => Offset(-step, 0),
      LogicalKeyboardKey.arrowRight => Offset(step, 0),
      LogicalKeyboardKey.arrowUp => Offset(0, step), // PDF y grows upward
      LogicalKeyboardKey.arrowDown => Offset(0, -step),
      _ => null,
    };
    if (delta == null) return KeyEventResult.ignored;
    _moveByPoints(delta);
    return KeyEventResult.handled;
  }

  void _sign() {
    setState(() => _signed = true);
    if (context.reduceMotion) {
      _ink.value = 1;
    } else {
      _ink.forward(from: 0);
    }
  }

  void _reset() {
    _snap.stop();
    _ink.reset();
    setState(() {
      _origin = _start;
      _signed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final copy = widget.copy;

    return ColoredBox(
      color: t.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 46),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    copy.documentTitle,
                    style: type.title.copyWith(fontSize: 16),
                  ),
                ),
                Text(copy.pageLabel, style: type.mono.copyWith(fontSize: 11)),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth - 24;
                final maxH = constraints.maxHeight - 8;
                var w = maxW;
                var h = w * _page.height / _page.width;
                if (h > maxH) {
                  h = maxH;
                  w = h * _page.width / _page.height;
                }
                final geometry = PageGeometry(page: _page, view: Size(w, h));
                _geometry = geometry;
                final rect = geometry.toView(_origin, _field);
                final lineTop = (_page.height - _lineY) * geometry.scale;
                return Center(
                  child: SizedBox(
                    width: w,
                    height: h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _PagePainter(lineTop: lineTop),
                          ),
                        ),
                        Positioned(
                          left: w * 0.08,
                          top: h * 0.05,
                          child: Text(
                            copy.documentTitle,
                            style: TextStyle(
                              fontFamily: Fonts.body,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.045,
                              color: const Color(0xFF1B2433),
                            ),
                          ),
                        ),
                        Positioned(
                          left: w * 0.08,
                          top: lineTop + 4,
                          child: Text(
                            copy.field,
                            style: TextStyle(
                              fontFamily: Fonts.body,
                              fontSize: w * 0.026,
                              color: const Color(0xFF7A8496),
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: rect,
                          child: _buildField(rect.size),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Text(
              copy.coordinates.fill({
                'x': _origin.dx.round(),
                'y': _origin.dy.round(),
              }),
              style: type.mono.copyWith(fontSize: 11.5, color: t.signalText),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 16),
            child: Row(
              children: [
                Expanded(
                  child: _DemoButton(
                    label: copy.sign,
                    primary: true,
                    onTap: _signed ? null : _sign,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DemoButton(label: copy.reset, onTap: _reset),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(Size size) {
    final t = context.tokens;
    final copy = widget.copy;
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _onKey,
      onFocusChange: (f) => setState(() => _focused = f),
      child: Semantics(
        label:
            '${copy.fieldSemantics} '
            '${copy.coordinates.fill({'x': _origin.dx.round(), 'y': _origin.dy.round()})}',
        child: RawGestureDetector(
          gestures: {
            _ImmediatePanRecognizer:
                GestureRecognizerFactoryWithHandlers<_ImmediatePanRecognizer>(
                  _ImmediatePanRecognizer.new,
                  (r) {
                    r
                      ..onStart = (_) {
                        _focusNode.requestFocus();
                        setState(() => _dragging = true);
                      }
                      ..onUpdate = (d) {
                        _moveBy(d.delta);
                      }
                      ..onEnd = (_) {
                        setState(() => _dragging = false);
                        _maybeSnap();
                      }
                      ..onCancel = () {
                        setState(() => _dragging = false);
                      };
                  },
                ),
          },
          child: MouseRegion(
            cursor: _dragging
                ? SystemMouseCursors.grabbing
                : SystemMouseCursors.grab,
            child: AnimatedScale(
              scale: _dragging ? 1.04 : 1,
              duration: const Duration(milliseconds: 180),
              child: CustomPaint(
                painter: _FieldPainter(
                  color: t.signal,
                  focused: _focused,
                  filled: _dragging,
                ),
                child: _signed
                    ? AnimatedBuilder(
                        animation: _ink,
                        builder: (context, _) => CustomPaint(
                          size: size,
                          painter: _SignaturePainter(progress: _ink.value),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              copy.field,
                              style: TextStyle(
                                fontFamily: Fonts.body,
                                fontWeight: FontWeight.w600,
                                fontSize: (size.height * 0.24).clamp(9.0, 13.0),
                                color: const Color(0xFF0B5C93),
                              ),
                            ),
                            Text(
                              copy.dragHint,
                              style: TextStyle(
                                fontFamily: Fonts.body,
                                fontSize: (size.height * 0.18).clamp(8.0, 11.0),
                                color: const Color(0xFF4A6A85),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Accepts the gesture on pointer down. A normal pan recognizer waits for
/// 36px of movement on touch, while the page's vertical drag only waits for
/// 18px, so a vertical drag of the field would scroll the page instead.
class _ImmediatePanRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
}

/// A white page with skeleton text lines and a signature line.
class _PagePainter extends CustomPainter {
  _PagePainter({required this.lineTop});

  final double lineTop;

  @override
  void paint(Canvas canvas, Size size) {
    final page = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(3),
    );
    canvas.drawRRect(
      page.shift(const Offset(0, 3)),
      Paint()
        ..color = const Color(0x40000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawRRect(page, Paint()..color = Colors.white);

    final bar = Paint()..color = const Color(0xFFE4E8EF);
    final left = size.width * 0.08;
    final full = size.width * 0.84;
    const widths = [1.0, 0.94, 0.98, 0.7, 0.0, 1.0, 0.9, 0.96, 0.52, 0.0, 0.97];
    var y = size.height * 0.15;
    final step = size.height * 0.04;
    for (final w in widths) {
      if (w > 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(left, y, full * w, size.height * 0.012),
            const Radius.circular(2),
          ),
          bar,
        );
      }
      y += step;
    }
    canvas.drawLine(
      Offset(left, lineTop),
      Offset(left + size.width * 0.4, lineTop),
      Paint()
        ..color = const Color(0xFF9AA3B2)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_PagePainter old) => old.lineTop != lineTop;
}

/// Dashed outline of the field; solid when focused (keyboard) or dragged.
class _FieldPainter extends CustomPainter {
  _FieldPainter({
    required this.color,
    required this.focused,
    required this.filled,
  });

  final Color color;
  final bool focused;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(4),
    );
    canvas.drawRRect(
      rrect,
      Paint()..color = color.withValues(alpha: filled ? 0.16 : 0.08),
    );
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = focused ? 2 : 1.4
      ..color = color;
    if (focused) {
      canvas.drawRRect(rrect, stroke);
      return;
    }
    final path = Path()..addRRect(rrect);
    for (final ui.PathMetric m in path.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 9) {
        canvas.drawPath(m.extractPath(d, d + 5), stroke);
      }
    }
  }

  @override
  bool shouldRepaint(_FieldPainter old) =>
      old.color != color || old.focused != focused || old.filled != filled;
}

/// A hand-drawn style signature, inked progressively along its length.
class _SignaturePainter extends CustomPainter {
  _SignaturePainter({required this.progress});

  final double progress;

  static Path _unitSignature() => Path()
    ..moveTo(0.05, 0.72)
    ..cubicTo(0.10, 0.22, 0.17, 0.12, 0.22, 0.62)
    ..cubicTo(0.24, 0.80, 0.12, 0.60, 0.30, 0.50)
    ..cubicTo(0.38, 0.43, 0.36, 0.72, 0.44, 0.66)
    ..cubicTo(0.50, 0.60, 0.50, 0.40, 0.56, 0.48)
    ..cubicTo(0.60, 0.56, 0.58, 0.74, 0.66, 0.64)
    ..cubicTo(0.72, 0.30, 0.74, 0.30, 0.76, 0.62)
    ..cubicTo(0.78, 0.76, 0.84, 0.58, 0.88, 0.56)
    ..cubicTo(0.94, 0.54, 0.97, 0.62, 0.98, 0.70)
    ..moveTo(0.10, 0.86)
    ..cubicTo(0.40, 0.78, 0.70, 0.92, 0.95, 0.82);

  @override
  void paint(Canvas canvas, Size size) {
    final unit = _unitSignature();
    final matrix = Matrix4.identity()
      ..translateByDouble(size.width * 0.08, size.height * 0.04, 0, 1)
      ..scaleByDouble(size.width * 0.84, size.height * 0.9, 1, 1);
    final path = unit.transform(matrix.storage);
    final metrics = path.computeMetrics().toList();
    final total = metrics.fold<double>(0, (sum, m) => sum + m.length);
    var remaining = total * progress;
    final ink = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (size.height * 0.04).clamp(1.2, 2.4)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFF173A7A);
    for (final m in metrics) {
      if (remaining <= 0) break;
      canvas.drawPath(m.extractPath(0, remaining.clamp(0.0, m.length)), ink);
      remaining -= m.length;
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter old) => old.progress != progress;
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({required this.label, this.onTap, this.primary = false});

  final String label;
  final VoidCallback? onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final enabled = onTap != null;
    return Pressable(
      semanticLabel: label,
      onTap: onTap,
      builder: (context, states) => AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary
              ? (enabled ? t.signal : t.surfaceRaised)
              : (states.contains(WidgetState.hovered)
                    ? t.surfaceRaised
                    : t.surface),
          borderRadius: BorderRadius.circular(Radii.s + 2),
          border: primary ? null : Border.all(color: t.lineStrong),
        ),
        child: Text(
          label,
          style: context.type.label.copyWith(
            fontSize: 13.5,
            color: primary ? (enabled ? t.onSignal : t.textMuted) : t.text,
          ),
        ),
      ),
    );
  }
}
