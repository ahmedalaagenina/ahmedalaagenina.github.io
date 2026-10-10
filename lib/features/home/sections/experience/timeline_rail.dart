import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Where a role sits on the route map.
enum Lane { main, parallel }

/// Paints one role's slice of the timeline: the solid main line, the dashed
/// parallel lane (part-time roles), branch/merge curves where the parallel
/// lane starts and ends, and the role's stop.
///
/// [progress] (0..1) is how far the reading line has travelled through this
/// row; the drawn part of every line lights up up to that point.
class TimelineRailPainter extends CustomPainter {
  TimelineRailPainter({
    required this.progress,
    required this.lane,
    required this.branchIn,
    required this.mergeOut,
    required this.current,
    required this.mainX,
    required this.parallelX,
    required this.nodeY,
    required this.base,
    required this.mainColor,
    required this.parallelColor,
    required this.background,
  }) : super(repaint: progress);

  final ValueListenable<double> progress;
  final Lane lane;

  /// First part-time row: the parallel lane branches off the main line.
  final bool branchIn;

  /// Last part-time row: the parallel lane merges back.
  final bool mergeOut;
  final bool current;
  final double mainX;
  final double parallelX;
  final double nodeY;
  final Color base;
  final Color mainColor;
  final Color parallelColor;
  final Color background;

  static const double _branchLength = 36;

  // The dashed lane only depends on the size, not on progress, so it is
  // built once and reused for every scroll frame.
  Size? _cachedSize;
  Path? _cachedParallel;

  Path _parallelPath(Size size) {
    final path = Path();
    if (branchIn) {
      path
        ..moveTo(mainX, 0)
        ..cubicTo(
          mainX,
          _branchLength * 0.6,
          parallelX,
          _branchLength * 0.4,
          parallelX,
          _branchLength,
        );
    } else {
      path.moveTo(parallelX, 0);
    }
    final endY = mergeOut ? size.height - _branchLength : size.height;
    path.lineTo(parallelX, endY);
    if (mergeOut) {
      path.cubicTo(
        parallelX,
        endY + _branchLength * 0.6,
        mainX,
        endY + _branchLength * 0.4,
        mainX,
        size.height,
      );
    }
    return path;
  }

  /// Dashes any path (straight or curved) by walking its metrics.
  Path _dashed(Path source, {double dash = 6, double gap = 6}) {
    final out = Path();
    for (final ui.PathMetric metric in source.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        out.addPath(metric.extractPath(d, d + dash), Offset.zero);
        d += dash + gap;
      }
    }
    return out;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress.value.clamp(0.0, 1.0);
    final litY = size.height * p;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Main line: faint base, then the lit part on top.
    final main = Path()
      ..moveTo(mainX, 0)
      ..lineTo(mainX, size.height);
    canvas.drawPath(main, stroke..color = base);

    Path? parallel;
    if (lane == Lane.parallel) {
      if (_cachedSize != size) {
        _cachedSize = size;
        _cachedParallel = _dashed(_parallelPath(size));
      }
      parallel = _cachedParallel!;
      canvas.drawPath(parallel, stroke..color = base);
    }

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, litY));
    canvas.drawPath(main, stroke..color = mainColor);
    if (parallel != null) {
      canvas.drawPath(parallel, stroke..color = parallelColor);
    }
    canvas.restore();

    // The stop for this role.
    final x = lane == Lane.parallel ? parallelX : mainX;
    final reached = litY >= nodeY;
    final color = lane == Lane.parallel ? parallelColor : mainColor;
    final center = Offset(x, nodeY);
    if (current) {
      canvas.drawCircle(
        center,
        11,
        Paint()..color = (reached ? color : base).withValues(alpha: 0.22),
      );
    }
    canvas.drawCircle(center, 6.5, Paint()..color = background);
    canvas.drawCircle(
      center,
      6,
      reached
          ? (Paint()..color = color)
          : (Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = base),
    );
  }

  @override
  bool shouldRepaint(TimelineRailPainter old) =>
      old.lane != lane ||
      old.branchIn != branchIn ||
      old.mergeOut != mergeOut ||
      old.current != current ||
      old.base != base ||
      old.mainColor != mainColor ||
      old.parallelColor != parallelColor ||
      old.background != background ||
      old.mainX != mainX ||
      old.parallelX != parallelX;
}
