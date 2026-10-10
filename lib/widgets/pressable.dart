import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../core/launcher.dart';
import '../core/motion/springs.dart';
import '../theme/app_theme.dart';
import 'cursor/cursor_scope.dart';

/// The one interactive primitive of the site.
///
/// Every button, link and tappable card is built on it, so they all share:
/// - keyboard support (Tab to focus, Enter/Space to activate),
/// - a visible focus ring for keyboard users only,
/// - hover state (and the custom cursor growing over it),
/// - spring press feedback,
/// - correct semantics: a *link* (with its URL) when [url] is set,
///   otherwise a *button*.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.builder,
    required this.semanticLabel,
    this.onTap,
    this.url,
    this.tooltip,
    this.pressScale = 0.96,
    this.focusRadius = Radii.m,
  });

  /// Builds the visuals for the current interaction states
  /// ([WidgetState.hovered], [WidgetState.pressed], [WidgetState.focused]).
  final Widget Function(BuildContext context, Set<WidgetState> states) builder;

  /// What a screen reader announces. The visual child is excluded from
  /// semantics so labels are never read twice.
  final String semanticLabel;
  final VoidCallback? onTap;

  /// When set, activation opens this URL in a new tab.
  final String? url;
  final String? tooltip;
  final double pressScale;
  final double focusRadius;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scale = AnimationController.unbounded(
    vsync: this,
    value: 1,
  );
  bool _hovered = false;
  bool _pressed = false;
  bool _focusVisible = false;
  CursorController? _cursor;

  bool get _enabled => widget.onTap != null || widget.url != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cursor = CursorScope.maybeOf(context);
  }

  @override
  void dispose() {
    if (_hovered) _cursor?.exit();
    _scale.dispose();
    super.dispose();
  }

  void _activate() {
    final url = widget.url;
    if (url != null) Launcher.open(url);
    widget.onTap?.call();
  }

  void _springTo(double target) {
    if (context.reduceMotion) {
      _scale.value = 1;
      return;
    }
    _scale.animateWith(
      SpringSimulation(Springs.snappy, _scale.value, target, _scale.velocity),
    );
  }

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
    _springTo(pressed ? widget.pressScale : 1);
  }

  void _setHovered(bool hovered) {
    if (_hovered == hovered) return;
    setState(() => _hovered = hovered);
    hovered ? _cursor?.enter() : _cursor?.exit();
  }

  @override
  Widget build(BuildContext context) {
    final states = <WidgetState>{
      if (_hovered) WidgetState.hovered,
      if (_pressed) WidgetState.pressed,
      if (_focusVisible) WidgetState.focused,
      if (!_enabled) WidgetState.disabled,
    };
    final url = widget.url;

    Widget child = FocusableActionDetector(
      enabled: _enabled,
      mouseCursor: _enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onShowFocusHighlight: (v) => setState(() => _focusVisible = v),
      onShowHoverHighlight: _setHovered,
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _activate();
            return null;
          },
        ),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _enabled ? (_) => _setPressed(true) : null,
        onTapUp: _enabled ? (_) => _setPressed(false) : null,
        onTapCancel: _enabled ? () => _setPressed(false) : null,
        onTap: _enabled ? _activate : null,
        child: CustomPaint(
          foregroundPainter: _FocusRingPainter(
            visible: _focusVisible,
            radius: widget.focusRadius,
            color: context.tokens.signal,
          ),
          child: ScaleTransition(
            scale: _scale,
            child: widget.builder(context, states),
          ),
        ),
      ),
    );

    child = Semantics(
      button: url == null,
      link: url != null,
      linkUrl: url == null ? null : Uri.tryParse(url),
      enabled: _enabled,
      label: widget.semanticLabel,
      onTap: _enabled ? _activate : null,
      excludeSemantics: true,
      child: child,
    );

    final tooltip = widget.tooltip;
    if (tooltip != null) {
      child = Tooltip(
        message: tooltip,
        excludeFromSemantics: true,
        child: child,
      );
    }
    return child;
  }
}

/// Draws a 2px ring just outside the widget, only for keyboard focus.
class _FocusRingPainter extends CustomPainter {
  _FocusRingPainter({
    required this.visible,
    required this.radius,
    required this.color,
  });

  final bool visible;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (!visible) return;
    final rect = (Offset.zero & size).inflate(3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius + 3)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_FocusRingPainter old) =>
      old.visible != visible || old.radius != radius || old.color != color;
}
