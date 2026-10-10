import 'package:flutter/widgets.dart';

/// Tracks whether the mouse is over something interactive, so the cursor
/// follower can grow. Interactive widgets call [enter]/[exit]; a counter
/// (not a bool) keeps nested targets from cancelling each other out.
class CursorController extends ChangeNotifier {
  int _targets = 0;

  bool get overTarget => _targets > 0;

  void enter() {
    _targets++;
    if (_targets == 1) notifyListeners();
  }

  void exit() {
    if (_targets == 0) return;
    _targets--;
    if (_targets == 0) notifyListeners();
  }
}

/// Makes a [CursorController] available below it. It never notifies
/// dependents: widgets only *call* the controller, so hovering a button
/// doesn't rebuild anything except the follower itself.
class CursorScope extends InheritedWidget {
  const CursorScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final CursorController controller;

  static CursorController? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<CursorScope>()?.controller;

  @override
  bool updateShouldNotify(CursorScope oldWidget) =>
      controller != oldWidget.controller;
}
