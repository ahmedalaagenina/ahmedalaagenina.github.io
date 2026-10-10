import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// A 2D value pulled toward a target by a spring.
///
/// Used by the magnetic button, the tilt card and the cursor follower. All
/// three retarget constantly (every pointer move), which is exactly where
/// springs beat tweens: velocity carries over, so the motion stays smooth.
///
/// The ticker only runs while the value is moving, so an idle widget costs
/// zero frames.
class SpringOffset extends ChangeNotifier {
  SpringOffset({
    required TickerProvider vsync,
    required SpringDescription spring,
    Offset initial = Offset.zero,
  }) : _spring = spring,
       _value = initial,
       _target = initial {
    _ticker = vsync.createTicker(_tick);
  }

  late final Ticker _ticker;
  SpringDescription _spring;
  Offset _value;
  Offset _target;
  Offset _velocity = Offset.zero;
  Duration? _last;

  Offset get value => _value;
  Offset get target => _target;
  bool get isMoving => _ticker.isActive;

  set spring(SpringDescription spring) => _spring = spring;

  void animateTo(Offset target, {SpringDescription? spring}) {
    if (spring != null) _spring = spring;
    _target = target;
    if (!_ticker.isActive) {
      _last = null;
      _ticker.start();
    }
  }

  void jumpTo(Offset value) {
    _value = value;
    _target = value;
    _velocity = Offset.zero;
    if (_ticker.isActive) _ticker.stop();
    notifyListeners();
  }

  void _tick(Duration elapsed) {
    final last = _last ?? elapsed;
    _last = elapsed;
    // Clamp dt so a dropped frame (or a backgrounded tab) can't explode the
    // integration, then integrate in small sub-steps for stability.
    var dt = (elapsed - last).inMicroseconds / 1e6;
    if (dt <= 0) dt = 1 / 60;
    if (dt > 1 / 20) dt = 1 / 20;

    const step = 1 / 240;
    final k = _spring.stiffness;
    final c = _spring.damping;
    final m = _spring.mass;
    var remaining = dt;
    while (remaining > 0) {
      final h = remaining < step ? remaining : step;
      final accel = ((_target - _value) * k - _velocity * c) / m;
      _velocity += accel * h;
      _value += _velocity * h;
      remaining -= h;
    }

    if ((_target - _value).distance < 0.01 && _velocity.distance < 0.05) {
      _value = _target;
      _velocity = Offset.zero;
      _ticker.stop();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
