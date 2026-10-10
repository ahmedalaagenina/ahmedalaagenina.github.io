import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../data/copy.dart';
import '../../widgets/toast.dart';

/// Easter egg: a fake "debug paint" mode that outlines every render box on
/// the page, like Flutter's `debugPaintSizeEnabled` (which only exists in
/// debug builds, so this one walks the render tree itself).
///
/// Two ways in, both nods to the craft:
/// - the Konami code on a keyboard (↑ ↑ ↓ ↓ ← → ← → B A),
/// - tapping the logo 7 times, like enabling Android developer options.
class DebugPaintScope extends StatefulWidget {
  const DebugPaintScope({super.key, required this.copy, required this.child});

  final EasterEggCopy copy;
  final Widget child;

  static DebugPaintController? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_DebugPaintInherited>()?.controller;

  @override
  State<DebugPaintScope> createState() => _DebugPaintScopeState();
}

/// Public surface used by the logo.
abstract interface class DebugPaintController {
  void registerDeveloperTap(BuildContext context);
}

class _DebugPaintScopeState extends State<DebugPaintScope>
    implements DebugPaintController {
  static const _konami = [
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.keyB,
    LogicalKeyboardKey.keyA,
  ];
  static const _tapsNeeded = 7;

  final _rootKey = GlobalKey();
  bool _enabled = false;
  int _konamiIndex = 0;
  int _taps = 0;
  DateTime _lastTap = DateTime(0);

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (event.logicalKey == _konami[_konamiIndex]) {
      _konamiIndex++;
      if (_konamiIndex == _konami.length) {
        _konamiIndex = 0;
        _toggle(context);
      }
    } else {
      _konamiIndex = event.logicalKey == _konami.first ? 1 : 0;
    }
    // Never swallow keys: arrows must keep scrolling the page.
    return false;
  }

  @override
  void registerDeveloperTap(BuildContext context) {
    final now = DateTime.now();
    if (now.difference(_lastTap) > const Duration(milliseconds: 1500)) {
      _taps = 0;
    }
    _lastTap = now;
    _taps++;
    final left = _tapsNeeded - _taps;
    if (left == 0) {
      _taps = 0;
      _toggle(context);
    } else if (left <= 4 && !_enabled) {
      showToast(context, widget.copy.stepsAway.fill({'n': left}));
    }
  }

  void _toggle(BuildContext context) {
    setState(() => _enabled = !_enabled);
    showToast(
      context,
      _enabled ? widget.copy.enabled : widget.copy.disabled,
      icon: Icons.developer_mode_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DebugPaintInherited(
      controller: this,
      child: Stack(
        children: [
          KeyedSubtree(key: _rootKey, child: widget.child),
          if (_enabled)
            Positioned.fill(
              child: IgnorePointer(child: _DebugOverlay(rootKey: _rootKey)),
            ),
        ],
      ),
    );
  }
}

class _DebugPaintInherited extends InheritedWidget {
  const _DebugPaintInherited({required this.controller, required super.child});

  final DebugPaintController controller;

  @override
  bool updateShouldNotify(_DebugPaintInherited old) => false;
}

/// Repaints every frame while enabled (the page may scroll or animate
/// underneath). It only exists while the easter egg is on.
class _DebugOverlay extends StatefulWidget {
  const _DebugOverlay({required this.rootKey});

  final GlobalKey rootKey;

  @override
  State<_DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<_DebugOverlay>
    with SingleTickerProviderStateMixin {
  final _frame = ValueNotifier(0);
  late final Ticker _ticker = createTicker((_) => _frame.value++)..start();

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: CustomPaint(
      painter: _BoxesPainter(rootKey: widget.rootKey, repaint: _frame),
    ),
  );
}

class _BoxesPainter extends CustomPainter {
  _BoxesPainter({required this.rootKey, required Listenable repaint})
    : super(repaint: repaint);

  final GlobalKey rootKey;

  static const _maxBoxes = 1800;
  final _box = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = const Color(0xFF00E5FF);
  final _text = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = const Color(0xFF7CFC00);
  final _padding = Paint()..color = const Color(0x1F00E5FF);

  @override
  void paint(Canvas canvas, Size size) {
    final root = rootKey.currentContext?.findRenderObject();
    if (root == null) return;
    final screen = Offset.zero & size;
    var count = 0;

    // Walk down the tree, accumulating each child's paint transform, so
    // every box is placed in O(1) instead of re-walking up to the root.
    void visit(RenderObject node, Matrix4 toRoot) {
      if (count >= _maxBoxes) return;
      if (node is RenderBox && node.hasSize) {
        final rect = MatrixUtils.transformRect(toRoot, Offset.zero & node.size);
        if (rect.width >= 2 && rect.height >= 2 && rect.overlaps(screen)) {
          count++;
          if (node is RenderPadding) {
            final inner = node.padding
                .resolve(TextDirection.ltr)
                .deflateRect(rect);
            canvas.drawPath(
              Path()
                ..fillType = PathFillType.evenOdd
                ..addRect(rect)
                ..addRect(inner),
              _padding,
            );
          }
          canvas.drawRect(
            rect.deflate(0.5),
            node is RenderParagraph ? _text : _box,
          );
        }
      }
      node.visitChildren((child) {
        final m = toRoot.clone();
        node.applyPaintTransform(child, m);
        visit(child, m);
      });
    }

    visit(root, Matrix4.identity());
  }

  @override
  bool shouldRepaint(_BoxesPainter old) => false;
}
