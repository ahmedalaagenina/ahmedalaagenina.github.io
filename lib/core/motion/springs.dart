import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// Motion tokens. Everything on the site moves with one of these springs,
/// so motion feels like one physical system instead of a set of tweens.
///
/// A spring is described by stiffness (how hard it pulls toward the target)
/// and a damping ratio (1.0 = no overshoot, below 1.0 = a little bounce).
/// Unlike a duration-based tween, a spring keeps its current velocity when
/// the target changes mid-flight, so interrupted animations never "jump".
abstract final class Springs {
  /// Entrances and layout changes: calm, no visible overshoot.
  static final gentle = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 140,
    ratio: 0.92,
  );

  /// Hover and press feedback: fast and tight.
  static final snappy = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 520,
    ratio: 0.82,
  );

  /// Releases (a magnetic button letting go): a small, playful wobble.
  static final playful = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 260,
    ratio: 0.5,
  );

  /// Pointer followers: critically damped so they never overshoot.
  static final follow = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 700,
    ratio: 1,
  );
}

/// Adapts a spring to Flutter's [Curve] API, for places that need a curve
/// over a fixed duration (staggered intervals, implicit animations).
///
/// The duration is the spring's settle time, available as [duration].
class SpringCurve extends Curve {
  SpringCurve(SpringDescription spring)
    : _simulation = SpringSimulation(spring, 0, 1, 0),
      _settleSeconds = _settleTime(spring);

  final SpringSimulation _simulation;
  final double _settleSeconds;

  Duration get duration =>
      Duration(microseconds: (_settleSeconds * 1e6).round());

  static double _settleTime(SpringDescription spring) {
    final sim = SpringSimulation(
      spring,
      0,
      1,
      0,
      tolerance: const Tolerance(distance: 0.001, velocity: 0.01),
    );
    var t = 0.0;
    while (!sim.isDone(t) && t < 4) {
      t += 1 / 120;
    }
    return t;
  }

  @override
  double transformInternal(double t) => _simulation.x(t * _settleSeconds);
}

extension MotionX on BuildContext {
  /// True when the visitor asked for less motion (OS setting or the
  /// prefers-reduced-motion media query, see `ReducedMotionScope`).
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}
