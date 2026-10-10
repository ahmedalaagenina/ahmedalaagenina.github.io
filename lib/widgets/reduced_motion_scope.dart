import 'package:flutter/widgets.dart';

import '../core/web/browser.dart';

/// Folds the browser's `prefers-reduced-motion` into
/// `MediaQuery.disableAnimations`, so every widget can check one flag
/// (`context.reduceMotion`) whatever the source of the preference.
class ReducedMotionScope extends StatefulWidget {
  const ReducedMotionScope({super.key, required this.child});

  final Widget child;

  @override
  State<ReducedMotionScope> createState() => _ReducedMotionScopeState();
}

class _ReducedMotionScopeState extends State<ReducedMotionScope> {
  bool _reduce = prefersReducedMotion();

  @override
  void initState() {
    super.initState();
    onReducedMotionChange((reduce) {
      if (mounted) setState(() => _reduce = reduce);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    if (!_reduce || data.disableAnimations) return widget.child;
    return MediaQuery(
      data: data.copyWith(disableAnimations: true),
      child: widget.child,
    );
  }
}
