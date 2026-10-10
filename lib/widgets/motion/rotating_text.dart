import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../core/motion/springs.dart';

/// Cycles through [texts], sliding each new one up into place.
///
/// Screen readers get one stable label listing every phrase instead of a
/// stream of changes. The timer only runs while [active], and reduced
/// motion shows the first phrase without cycling.
class RotatingText extends StatefulWidget {
  const RotatingText({
    super.key,
    required this.texts,
    required this.style,
    this.active = true,
    this.interval = const Duration(milliseconds: 2600),
  });

  final List<String> texts;
  final TextStyle style;
  final bool active;
  final Duration interval;

  @override
  State<RotatingText> createState() => _RotatingTextState();
}

class _RotatingTextState extends State<RotatingText> {
  final _curve = SpringCurve(Springs.gentle);
  Timer? _timer;
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(RotatingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _sync() {
    final run =
        widget.active && widget.texts.length > 1 && !context.reduceMotion;
    if (run && _timer == null) {
      _timer = Timer.periodic(widget.interval, (_) {
        setState(() => _index = (_index + 1) % widget.texts.length);
      });
    } else if (!run && _timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.texts.join(', '),
      child: ExcludeSemantics(
        child: ClipRect(
          child: AnimatedSwitcher(
            duration: _curve.duration,
            switchInCurve: _curve,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: (current, previous) => Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [...previous, ?current],
            ),
            transitionBuilder: (child, animation) {
              final incoming = child.key == ValueKey(_index);
              final slide = Tween<Offset>(
                begin: Offset(0, incoming ? 1.0 : -1.0),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: Text(
              widget.texts[_index],
              key: ValueKey(_index),
              style: widget.style,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
