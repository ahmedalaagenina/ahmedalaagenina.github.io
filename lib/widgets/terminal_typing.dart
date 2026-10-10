import 'package:flutter/material.dart';

import '../core/motion/springs.dart';
import '../theme/app_theme.dart';

/// A terminal window that types a command, then prints its output.
///
/// One controller drives the whole sequence (typing, a pause, each output
/// line), so replaying or skipping is a single `forward(from: 0)` or
/// `value = 1`. Starts when [play] first turns true; reduced motion shows
/// the final state.
class TerminalTyping extends StatefulWidget {
  const TerminalTyping({
    super.key,
    required this.command,
    required this.output,
    required this.semanticLabel,
    required this.play,
    this.replayKey = 0,
  });

  final String command;

  /// Output lines; the last one is printed as the success line.
  final List<String> output;
  final String semanticLabel;
  final bool play;

  /// Change it to replay the animation.
  final int replayKey;

  @override
  State<TerminalTyping> createState() => _TerminalTypingState();
}

class _TerminalTypingState extends State<TerminalTyping>
    with SingleTickerProviderStateMixin {
  static const _perChar = 42; // ms
  static const _pause = 380;
  static const _perLine = 300;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds:
          widget.command.length * _perChar +
          _pause +
          widget.output.length * _perLine,
    ),
  );
  bool _started = false;

  double get _typingEnd =>
      widget.command.length * _perChar / _controller.duration!.inMilliseconds;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeStart();
  }

  @override
  void didUpdateWidget(TerminalTyping oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.replayKey != widget.replayKey) {
      context.reduceMotion
          ? _controller.value = 1
          : _controller.forward(from: 0);
    }
    _maybeStart();
  }

  void _maybeStart() {
    if (_started || !widget.play) return;
    _started = true;
    if (context.reduceMotion) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    const bg = Color(0xFF0A0E17);
    final mono = TextStyle(
      fontFamily: Fonts.mono,
      fontSize: 14,
      height: 1.7,
      color: const Color(0xFFC9D1E0),
    );

    return Semantics(
      label: widget.semanticLabel,
      child: ExcludeSemantics(
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(Radii.l),
            border: Border.all(color: const Color(0xFF232B3B)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF1B2230))),
                ),
                child: Row(
                  children: [
                    for (var i = 0; i < 3; i++)
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(right: 7),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2B3446),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final v = _controller.value;
                    final typed = (v / _typingEnd).clamp(0.0, 1.0);
                    final chars = (widget.command.length * typed).round();
                    final total = _controller.duration!.inMilliseconds;
                    final elapsed = v * total;
                    final outputStart =
                        widget.command.length * _perChar + _pause;
                    final lines = elapsed < outputStart
                        ? 0
                        : ((elapsed - outputStart) / _perLine).floor() + 1;
                    final done = v >= 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: r'$ ',
                                style: TextStyle(color: t.signal),
                              ),
                              TextSpan(
                                text: widget.command.substring(0, chars),
                              ),
                              if (!done || chars < widget.command.length)
                                const TextSpan(
                                  text: '█',
                                  style: TextStyle(color: Color(0xFF6C7891)),
                                ),
                            ],
                          ),
                          style: mono,
                        ),
                        for (
                          var i = 0;
                          i < widget.output.length && i < lines;
                          i++
                        )
                          _Line(
                            text: widget.output[i],
                            style: mono.copyWith(
                              color: i == widget.output.length - 1
                                  ? t.success
                                  : const Color(0xFF8A94A8),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// An output line that slides in once.
class _Line extends StatelessWidget {
  const _Line({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final curve = SpringCurve(Springs.gentle);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: context.reduceMotion ? Duration.zero : curve.duration,
      curve: curve,
      builder: (context, v, child) => Opacity(
        opacity: v.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - v) * 6),
          child: child,
        ),
      ),
      child: Text(text, style: style),
    );
  }
}
