import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Tells its builder whether it is on screen.
///
/// This is the "pause off-screen work" switch: heavy effects (the hero
/// shader, the live demos, the terminal) only tick while visible, so the
/// page never runs more than one expensive animation at a time.
class VisibilityGate extends StatefulWidget {
  const VisibilityGate({
    super.key,
    required this.builder,
    this.threshold = 0.02,
    this.onFirstVisible,
  });

  final Widget Function(BuildContext context, bool visible) builder;

  /// Fraction of the widget that must be visible to count as visible.
  final double threshold;

  /// Called once, the first time the widget becomes visible. Useful for
  /// lazy work such as loading a deferred library or images.
  final VoidCallback? onFirstVisible;

  @override
  State<VisibilityGate> createState() => _VisibilityGateState();
}

class _VisibilityGateState extends State<VisibilityGate> {
  late final Key _key = UniqueKey();
  bool _visible = false;
  bool _seen = false;

  void _onChanged(VisibilityInfo info) {
    if (!mounted) return;
    final visible = info.visibleFraction > widget.threshold;
    if (visible && !_seen) {
      _seen = true;
      widget.onFirstVisible?.call();
    }
    if (visible != _visible) setState(() => _visible = visible);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: _onChanged,
      child: widget.builder(context, _visible),
    );
  }
}
