import 'package:flutter/widgets.dart';

import '../../core/motion/springs.dart';

/// Reveals text letter by letter, driven by a caller-owned [progress]
/// (0 → 1), so a parent can orchestrate it with other entrances.
///
/// Letters are positioned with the *kerned* glyph offsets from a real text
/// layout. When the animation completes, the widget swaps to a single plain
/// [Text]: since every letter already sat at its final kerned position, the
/// swap is pixel-identical and the steady state is just one paragraph.
class StaggeredText extends StatefulWidget {
  const StaggeredText({
    super.key,
    required this.text,
    required this.style,
    required this.progress,
    this.stagger = 0.05,
    this.letterSpan = 0.5,
    this.rise = 0.4,
  });

  final String text;
  final TextStyle style;
  final Animation<double> progress;

  /// Delay between letters, as a fraction of the whole animation.
  final double stagger;

  /// Length of one letter's own animation, as a fraction of the whole.
  final double letterSpan;

  /// How far each letter rises, as a fraction of the font size.
  final double rise;

  @override
  State<StaggeredText> createState() => _StaggeredTextState();
}

class _StaggeredTextState extends State<StaggeredText> {
  final _curve = SpringCurve(Springs.playful);

  @override
  void initState() {
    super.initState();
    widget.progress.addStatusListener(_onStatus);
  }

  @override
  void didUpdateWidget(StaggeredText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      oldWidget.progress.removeStatusListener(_onStatus);
      widget.progress.addStatusListener(_onStatus);
    }
  }

  @override
  void dispose() {
    widget.progress.removeStatusListener(_onStatus);
    super.dispose();
  }

  void _onStatus(AnimationStatus status) => setState(() {});

  @override
  Widget build(BuildContext context) {
    final finalText = Text(widget.text, style: widget.style);
    if (widget.progress.isCompleted) return finalText;

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: constraints.maxWidth);

        final letters = <Widget>[];
        final count = widget.text.length;
        // Normalize so the last letter ends exactly at progress = 1.
        final total = widget.stagger * (count - 1) + widget.letterSpan;
        for (var i = 0; i < count; i++) {
          final char = widget.text[i];
          if (char.trim().isEmpty) continue;
          final boxes = painter.getBoxesForSelection(
            TextSelection(baseOffset: i, extentOffset: i + 1),
          );
          if (boxes.isEmpty) continue;
          final start = widget.stagger * i / total;
          final end = (widget.stagger * i + widget.letterSpan) / total;
          letters.add(
            Positioned(
              left: boxes.first.left,
              top: boxes.first.top,
              child: _Letter(
                char: char,
                style: widget.style,
                rise: widget.rise * (widget.style.fontSize ?? 14),
                animation: CurvedAnimation(
                  parent: widget.progress,
                  curve: Interval(start, end.clamp(0.0, 1.0), curve: _curve),
                ),
              ),
            ),
          );
        }
        final size = painter.size;
        painter.dispose();
        return Semantics(
          label: widget.text,
          child: ExcludeSemantics(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(clipBehavior: Clip.none, children: letters),
            ),
          ),
        );
      },
    );
  }
}

class _Letter extends StatelessWidget {
  const _Letter({
    required this.char,
    required this.style,
    required this.rise,
    required this.animation,
  });

  final String char;
  final TextStyle style;
  final double rise;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    // Only opacity and transform change per frame: no text re-layout.
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * rise),
            child: child,
          ),
        );
      },
      child: Text(char, style: style),
    );
  }
}
