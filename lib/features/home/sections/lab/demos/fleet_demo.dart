import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../../../../core/motion/springs.dart';
import '../../../../../data/copy.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../../widgets/pressable.dart';
import '../logic/fleet_simulation.dart';
import '../logic/grid_clusterer.dart';

/// Mini fleet map: 200 simulated vehicles, clustered on a grid in screen
/// space, re-clustered as you zoom.
///
/// Mirrors the real techniques from iDara Tracking at toy scale:
/// - positions arrive once per "poll"; markers interpolate between polls,
/// - clustering happens client-side, every zoom step,
/// - markers glide between their own position and their cluster's center.
class FleetDemo extends StatefulWidget {
  const FleetDemo({super.key, required this.copy, required this.active});

  final FleetCopy copy;

  /// False when the demo is off screen: the poll timer and the ticker stop.
  final bool active;

  @override
  State<FleetDemo> createState() => _FleetDemoState();
}

// Two tickers (frame loop + zoom controller), so the multi-ticker mixin.
class _FleetDemoState extends State<FleetDemo> with TickerProviderStateMixin {
  static const _pollEvery = Duration(seconds: 1);
  static const _minZoom = 1.0;
  static const _maxZoom = 6.0;

  // Matches the phone screen's aspect so the city fills it at 1× zoom.
  final _sim = FleetSimulation(worldHeight: _worldHeight);
  static const _worldHeight = 2.2;
  final _clusterer = const GridClusterer(cellSize: 66);
  late final Ticker _ticker = createTicker(_onTick);
  late final AnimationController _zoom = AnimationController.unbounded(
    vsync: this,
    value: 1,
  );
  final _frame = ValueNotifier(0);
  final _stats = ValueNotifier<(int, int)>((0, 0));

  Timer? _pollTimer;
  Duration _lastTick = Duration.zero;
  double _sincePoll = 0;
  Size _size = Size.zero;

  /// World point shown at the center of the view.
  Offset _focus = const Offset(0.5, _worldHeight / 2);

  /// While zooming around a point, the world point under the pointer and
  /// where it sits on screen. Re-applied every zoom frame, so the spot under
  /// the cursor stays put for the whole animation (like a real map).
  Offset? _anchorScreen;
  Offset? _anchorWorld;
  bool _panEnabled = false;

  /// Smoothed display position of every vehicle, in world space.
  late final List<Offset> _display = [for (final v in _sim.vehicles) v.current];

  /// Cluster index of every vehicle, recomputed per poll and zoom step.
  List<Cluster> _clusters = const [];
  List<int> _clusterOf = const [];

  @override
  void initState() {
    super.initState();
    _zoom.addListener(_onZoomChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(FleetDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _ticker.dispose();
    _zoom.dispose();
    _frame.dispose();
    _stats.dispose();
    super.dispose();
  }

  bool get _animate => widget.active && !context.reduceMotion;

  void _sync() {
    if (_animate) {
      _pollTimer ??= Timer.periodic(_pollEvery, (_) => _poll());
      if (!_ticker.isActive) {
        _lastTick = Duration.zero;
        _ticker.start();
      }
    } else {
      _pollTimer?.cancel();
      _pollTimer = null;
      if (_ticker.isActive) _ticker.stop();
    }
  }

  void _poll() {
    _sim.poll(_pollEvery.inMilliseconds / 1000);
    _sincePoll = 0;
    _recluster();
  }

  void _onZoomChanged() {
    final anchorScreen = _anchorScreen;
    final anchorWorld = _anchorWorld;
    if (anchorScreen != null && anchorWorld != null && _size != Size.zero) {
      _focus =
          anchorWorld - (anchorScreen - _size.center(Offset.zero)) / _scale;
    }
    _clampFocus();
    _recluster();
    // The pan recognizer only exists while zoomed in: rebuild when that
    // flips, since zoom changes don't otherwise rebuild this widget.
    final panEnabled = _zoom.value > 1.01;
    if (panEnabled != _panEnabled) setState(() => _panEnabled = panEnabled);
    if (!_ticker.isActive) _frame.value++;
  }

  // ── World ↔ screen ─────────────────────────────────────────────────────

  double get _scale => math.min(_size.width, _size.height) * _zoom.value;

  Offset _toScreen(Offset world) =>
      (world - _focus) * _scale + _size.center(Offset.zero);

  Offset _toWorld(Offset screen) =>
      (screen - _size.center(Offset.zero)) / _scale + _focus;

  void _clampFocus() {
    if (_size == Size.zero) return;
    final halfW = _size.width / 2 / _scale;
    final halfH = _size.height / 2 / _scale;
    double clampAxis(double v, double half, double extent) =>
        half >= extent / 2 ? extent / 2 : v.clamp(half, extent - half);
    _focus = Offset(
      clampAxis(_focus.dx, halfW, 1),
      clampAxis(_focus.dy, halfH, _worldHeight),
    );
  }

  void _recluster() {
    if (_size == Size.zero) return;
    final t = (_sincePoll / 1.0).clamp(0.0, 1.0);
    final screen = [for (final v in _sim.vehicles) _toScreen(v.positionAt(t))];
    _clusters = _clusterer.cluster(screen);
    final of = List<int>.filled(screen.length, 0);
    for (var c = 0; c < _clusters.length; c++) {
      for (final m in _clusters[c].members) {
        of[m] = c;
      }
    }
    _clusterOf = of;
    _stats.value = (
      _sim.vehicles.length,
      _clusters.where((c) => c.size > 1).length,
    );
  }

  void _onTick(Duration elapsed) {
    final dt = _lastTick == Duration.zero
        ? 1 / 60
        : (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    _sincePoll += dt;
    final t = (_sincePoll / 1.0).clamp(0.0, 1.0);
    // Ease each marker toward its target in *world* space, so panning and
    // zooming move everything in lockstep with no trailing dots.
    final k = 1 - math.exp(-dt * 10);
    for (var i = 0; i < _display.length; i++) {
      final target = _targetWorld(i, t);
      _display[i] += (target - _display[i]) * k;
    }
    _frame.value++;
  }

  Offset _targetWorld(int i, double t) {
    if (_clusterOf.isEmpty) return _sim.vehicles[i].positionAt(t);
    final cluster = _clusters[_clusterOf[i]];
    if (cluster.size == 1) return _sim.vehicles[i].positionAt(t);
    return _toWorld(cluster.center);
  }

  // ── Zoom & pan ─────────────────────────────────────────────────────────

  void _zoomTo(double target, {Offset? around}) {
    final clamped = target.clamp(_minZoom, _maxZoom);
    final anchor = around ?? _size.center(Offset.zero);
    _anchorScreen = anchor;
    _anchorWorld = _toWorld(anchor);
    if (context.reduceMotion) {
      _zoom.value = clamped;
    } else {
      _zoom.animateWith(
        SpringSimulation(Springs.gentle, _zoom.value, clamped, _zoom.velocity),
      );
    }
  }

  void _reset() {
    _anchorScreen = null;
    _anchorWorld = null;
    _focus = const Offset(0.5, _worldHeight / 2);
    _zoomTo(1);
    _anchorScreen = null;
    _anchorWorld = null;
  }

  void _onPan(DragUpdateDetails d) {
    _anchorScreen = null;
    _anchorWorld = null;
    _focus -= d.delta / _scale;
    _clampFocus();
    _recluster();
    if (!_ticker.isActive) _frame.value++;
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final keys = HardwareKeyboard.instance;
    // Only Ctrl/⌘ + wheel zooms, so a plain wheel keeps scrolling the
    // page: a map must never trap the page scroll.
    if (!keys.isControlPressed && !keys.isMetaPressed) return;
    GestureBinding.instance.pointerSignalResolver.register(event, (e) {
      final scroll = e as PointerScrollEvent;
      _zoomTo(
        _zoom.value * math.exp(-scroll.scrollDelta.dy / 300),
        around: scroll.localPosition,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final copy = widget.copy;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_size != constraints.biggest) {
          _size = constraints.biggest;
          _clampFocus();
          _recluster();
        }
        return Stack(
          children: [
            Positioned.fill(
              child: ValueListenableBuilder<(int, int)>(
                valueListenable: _stats,
                builder: (context, stats, child) => Semantics(
                  label: copy.mapLabel.fill({'n': stats.$1}),
                  child: child,
                ),
                child: Listener(
                  onPointerSignal: _onPointerSignal,
                  child: GestureDetector(
                    onDoubleTapDown: (d) =>
                        _zoomTo(_zoom.value * 2, around: d.localPosition),
                    onDoubleTap: () {},
                    // Drag only when zoomed in: at 1× there is no pan
                    // recognizer, so a finger on the map scrolls the page.
                    onPanUpdate: _panEnabled ? _onPan : null,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _MapPainter(
                          state: this,
                          repaint: _frame,
                          land: t.surface,
                          road: t.line,
                          majorRoad: t.lineStrong,
                          water: t.signalDeep.withValues(alpha: 0.16),
                          moving: t.signal,
                          idle: t.offline,
                          stopped: t.textMuted,
                          cluster: t.signalDeep,
                          clusterRing: t.signal,
                          onCluster: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 52,
              left: 12,
              right: 12,
              child: ValueListenableBuilder<(int, int)>(
                valueListenable: _stats,
                builder: (context, stats, _) => AnimatedBuilder(
                  animation: _zoom,
                  builder: (context, _) => Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _Pill(copy.vehicles.fill({'n': stats.$1})),
                      _Pill(copy.clusters.fill({'n': stats.$2})),
                      _Pill(
                        copy.zoom.fill({'n': _zoom.value.toStringAsFixed(1)}),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 64,
              child: Column(
                children: [
                  _MapButton(
                    icon: Icons.add_rounded,
                    label: copy.zoomIn,
                    onTap: () => _zoomTo(
                      _zoom.value * 1.8,
                      around: _size.center(Offset.zero),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _MapButton(
                    icon: Icons.remove_rounded,
                    label: copy.zoomOut,
                    onTap: () => _zoomTo(
                      _zoom.value / 1.8,
                      around: _size.center(Offset.zero),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _MapButton(
                    icon: Icons.filter_center_focus_rounded,
                    label: copy.resetView,
                    onTap: _reset,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 12,
              bottom: 16,
              child: ExcludeSemantics(child: _Pill(copy.hint)),
            ),
          ],
        );
      },
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.state,
    required Listenable repaint,
    required this.land,
    required this.road,
    required this.majorRoad,
    required this.water,
    required this.moving,
    required this.idle,
    required this.stopped,
    required this.cluster,
    required this.clusterRing,
    required this.onCluster,
  }) : super(repaint: repaint);

  final _FleetDemoState state;
  final Color land;
  final Color road;
  final Color majorRoad;
  final Color water;
  final Color moving;
  final Color idle;
  final Color stopped;
  final Color cluster;
  final Color clusterRing;
  final Color onCluster;

  /// Count labels, laid out once per number and reused every frame.
  static final Map<String, TextPainter> _labels = {};

  TextPainter _label(int n, Color color) {
    final key = '$n-${color.toARGB32()}';
    return _labels.putIfAbsent(
      key,
      () => TextPainter(
        text: TextSpan(
          text: '$n',
          style: TextStyle(
            fontFamily: Fonts.body,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = land);
    final scale = state._scale;
    final origin = state._toScreen(Offset.zero);

    // Roads and the river, drawn in world space with one transform. The
    // stroke width is divided by the scale so lines stay crisp at any zoom.
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.scale(scale);
    const h = _FleetDemoState._worldHeight;
    final river = Path()
      ..moveTo(-0.1, 0.62 * h)
      ..cubicTo(0.25, 0.55 * h, 0.45, 0.8 * h, 1.1, 0.7 * h);
    canvas.drawPath(
      river,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.035
        ..color = water,
    );
    for (final r in state._sim.roads) {
      final path = Path()..addPolygon(r.points, false);
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = (r.major ? 3.2 : 1.6) / scale
          ..color = r.major ? majorRoad : road,
      );
    }
    canvas.restore();

    // Vehicles not in a multi-member cluster, or still gliding into one.
    final clusters = state._clusters;
    final of = state._clusterOf;
    final vehicles = state._sim.vehicles;
    final dot = Paint();
    final halo = Paint()..color = land;
    for (var i = 0; i < vehicles.length; i++) {
      final p = state._toScreen(state._display[i]);
      if (of.isNotEmpty) {
        final c = clusters[of[i]];
        if (c.size > 1 && (p - c.center).distance < 3) continue;
      }
      dot.color = switch (vehicles[i].status) {
        VehicleStatus.moving => moving,
        VehicleStatus.idle => idle,
        VehicleStatus.stopped => stopped,
      };
      canvas.drawCircle(p, 5.2, halo);
      canvas.drawCircle(p, 3.6, dot);
    }

    // Clusters: grow in as their members arrive.
    for (final c in clusters) {
      if (c.size < 2) continue;
      var spread = 0.0;
      for (final m in c.members) {
        spread += (state._toScreen(state._display[m]) - c.center).distance;
      }
      spread /= c.size;
      final grown = (1 - spread / 30).clamp(0.0, 1.0);
      if (grown <= 0) continue;
      final radius = (9 + 3.2 * math.log(c.size) / math.ln2) * grown;
      canvas.drawCircle(
        c.center,
        radius + 4,
        Paint()..color = clusterRing.withValues(alpha: 0.18 * grown),
      );
      canvas.drawCircle(c.center, radius, Paint()..color = cluster);
      canvas.drawCircle(
        c.center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = clusterRing.withValues(alpha: 0.7),
      );
      if (grown > 0.6) {
        final label = _label(c.size, onCluster);
        label.paint(
          canvas,
          c.center - Offset(label.width / 2, label.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.land != land || old.road != road || old.cluster != cluster;
}

class _Pill extends StatelessWidget {
  const _Pill(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: t.background.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(Radii.s),
        border: Border.all(color: t.line),
      ),
      child: Text(text, style: context.type.mono.copyWith(fontSize: 11)),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Pressable(
      semanticLabel: label,
      tooltip: label,
      onTap: onTap,
      focusRadius: Radii.s + 2,
      builder: (context, states) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: states.contains(WidgetState.hovered)
              ? t.surfaceRaised
              : t.background.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(Radii.s + 2),
          border: Border.all(color: t.lineStrong),
        ),
        child: Icon(icon, size: 20, color: t.text),
      ),
    );
  }
}
