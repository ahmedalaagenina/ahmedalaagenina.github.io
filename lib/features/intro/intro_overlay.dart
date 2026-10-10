import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/motion/springs.dart';
import '../../theme/app_theme.dart';
import '../home/shell/logo_mark.dart';

/// Hands over from the HTML loader to the app.
///
/// The HTML loader draws the `<AA />` mark (same Geist Mono outlines, same
/// size, same colors) while the engine downloads. On Flutter's first frame
/// the loader fades out over *this* overlay, which shows the identical mark
/// in the identical spot, then flies it into the nav logo while the backdrop
/// fades away. Total: under a second, and any tap or key skips it.
class IntroOverlay extends StatefulWidget {
  const IntroOverlay({
    super.key,
    required this.logo,
    required this.targetKey,
    required this.onHandoff,
    required this.onFinished,
  });

  final String logo;

  /// The nav logo the mark flies into.
  final GlobalKey targetKey;

  /// Called partway through, so the hero entrance overlaps the flight.
  final VoidCallback onHandoff;
  final VoidCallback onFinished;

  /// Same size as the loader's SVG mark in web/index.html.
  static const double startFontSize = 44;
  static const double endFontSize = 18;

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  );
  late final Animation<double> _flight = CurvedAnimation(
    parent: _controller,
    curve: Interval(0.16, 0.86, curve: SpringCurve(Springs.gentle)),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.3, 1, curve: Curves.easeOut),
  );
  bool _handedOff = false;
  Size? _measured;
  TextScaler? _measuredScaler;

  /// Size of the mark at its starting font size, measured once.
  Size _markSize(TextScaler scaler) {
    if (_measured != null && _measuredScaler == scaler) return _measured!;
    final painter = TextPainter(
      text: TextSpan(
        text: widget.logo,
        style: const TextStyle(
          fontFamily: Fonts.mono,
          fontWeight: FontWeight.w500,
          fontSize: IntroOverlay.startFontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout();
    _measuredScaler = scaler;
    _measured = painter.size;
    painter.dispose();
    return _measured!;
  }

  @override
  void initState() {
    super.initState();
    _controller
      ..addListener(_onTick)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onFinished();
      });
    HardwareKeyboard.instance.addHandler(_onKey);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.reduceMotion) {
        _skip();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _controller.dispose();
    super.dispose();
  }

  void _onTick() {
    if (!_handedOff && _controller.value >= 0.5) {
      _handedOff = true;
      widget.onHandoff();
    }
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent) _skip();
    return false;
  }

  void _skip() => _controller.value = 1;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final textScaler = MediaQuery.textScalerOf(context);
    return ExcludeSemantics(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _skip(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final size = MediaQuery.sizeOf(context);
            final markSize = _markSize(textScaler);
            final start =
                size.center(Offset.zero) - markSize.center(Offset.zero);
            final targetBox =
                widget.targetKey.currentContext?.findRenderObject()
                    as RenderBox?;
            final end = targetBox != null && targetBox.hasSize
                ? targetBox.localToGlobal(Offset.zero)
                : start;
            final f = _flight.value;
            final scale =
                1 +
                (IntroOverlay.endFontSize / IntroOverlay.startFontSize - 1) * f;
            return Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    color: t.background.withValues(alpha: 1 - _fade.value),
                  ),
                ),
                Positioned(
                  left: start.dx + (end.dx - start.dx) * f,
                  top: start.dy + (end.dy - start.dy) * f,
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topLeft,
                    child: LogoMark(
                      logo: widget.logo,
                      fontSize: IntroOverlay.startFontSize,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
