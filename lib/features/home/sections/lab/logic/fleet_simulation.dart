import 'dart:math' as math;
import 'dart:ui';

enum VehicleStatus { moving, idle, stopped }

/// A road as a polyline in world space (0..1 on both axes), with its
/// cumulative lengths precomputed so a distance maps to a point quickly.
class Road {
  Road(this.points, {this.major = false}) {
    var total = 0.0;
    _lengths.add(0);
    for (var i = 1; i < points.length; i++) {
      total += (points[i] - points[i - 1]).distance;
      _lengths.add(total);
    }
  }

  final List<Offset> points;
  final bool major;
  final List<double> _lengths = [];

  double get length => _lengths.last;

  Offset pointAt(double distance) {
    final d = distance.clamp(0.0, length);
    var i = 1;
    while (i < _lengths.length - 1 && _lengths[i] < d) {
      i++;
    }
    final segment = _lengths[i] - _lengths[i - 1];
    final t = segment == 0 ? 0.0 : (d - _lengths[i - 1]) / segment;
    return Offset.lerp(points[i - 1], points[i], t)!;
  }
}

class Vehicle {
  Vehicle({
    required this.road,
    required this.distance,
    required this.speed,
    required this.status,
  }) : previous = road.pointAt(distance),
       current = road.pointAt(distance);

  final Road road;
  double distance;
  double speed;
  int direction = 1;
  final VehicleStatus status;

  /// Positions at the last two polls. Rendering interpolates between them,
  /// like a real tracking app smoothing markers between server updates.
  Offset previous;
  Offset current;

  Offset positionAt(double t) => Offset.lerp(previous, current, t)!;
}

/// A deterministic fake city: roads plus vehicles that "report" a new
/// position on every [poll].
///
/// The world is 1 unit wide and [worldHeight] units tall, so a tall phone
/// screen can be filled without stretching the map.
class FleetSimulation {
  FleetSimulation({int vehicles = 200, int seed = 7, this.worldHeight = 1})
    : _random = math.Random(seed) {
    roads = _buildRoads();
    for (var i = 0; i < vehicles; i++) {
      final road = roads[_random.nextInt(roads.length)];
      final roll = _random.nextDouble();
      final status = roll < 0.72
          ? VehicleStatus.moving
          : roll < 0.9
          ? VehicleStatus.idle
          : VehicleStatus.stopped;
      this.vehicles.add(
        Vehicle(
          road: road,
          distance: _random.nextDouble() * road.length,
          speed: status == VehicleStatus.moving
              ? 0.006 + _random.nextDouble() * 0.014
              : 0,
          status: status,
        ),
      );
    }
  }

  final double worldHeight;
  final math.Random _random;
  late final List<Road> roads;
  final List<Vehicle> vehicles = [];

  /// Advances every vehicle by [seconds] and records the new positions.
  void poll(double seconds) {
    for (final v in vehicles) {
      v.previous = v.current;
      if (v.speed == 0) continue;
      v.distance += v.speed * seconds * v.direction;
      if (v.distance <= 0 || v.distance >= v.road.length) {
        v.direction = -v.direction;
        v.distance = v.distance.clamp(0.0, v.road.length);
      }
      v.current = v.road.pointAt(v.distance);
    }
  }

  List<Road> _buildRoads() {
    final r = math.Random(11);
    final h = worldHeight;
    final roads = <Road>[];
    Offset wobble(double x, double y, double amp, double phase, bool horiz) {
      final w = math.sin((horiz ? x : y) * 9 + phase) * amp;
      return horiz ? Offset(x, y + w) : Offset(x + w, y);
    }

    final horizontal = (7 * h).round();
    for (var i = 0; i < horizontal; i++) {
      final y = (i + 0.5) / horizontal * h + (r.nextDouble() - 0.5) * 0.04;
      final phase = r.nextDouble() * 6;
      roads.add(
        Road([
          for (var k = 0; k <= 24; k++)
            wobble(-0.05 + k * 1.1 / 24, y, 0.012, phase, true),
        ], major: i == horizontal ~/ 2),
      );
    }
    for (var i = 0; i < 6; i++) {
      final x = (i + 0.5) / 6 + (r.nextDouble() - 0.5) * 0.05;
      final phase = r.nextDouble() * 6;
      final steps = (24 * h).round();
      roads.add(
        Road([
          for (var k = 0; k <= steps; k++)
            wobble(x, -0.05 + k * (h + 0.1) / steps, 0.014, phase, false),
        ], major: i == 2),
      );
    }
    // Ring road and two diagonal avenues.
    roads.add(
      Road([
        for (var k = 0; k <= 48; k++)
          Offset(
            0.52 + 0.31 * math.cos(k / 48 * math.pi * 2),
            h / 2 + 0.27 * h * math.sin(k / 48 * math.pi * 2),
          ),
      ], major: true),
    );
    roads.add(Road([Offset(-0.05, 0.08 * h), Offset(1.05, 0.92 * h)]));
    roads.add(Road([Offset(0.05, 1.05 * h), Offset(0.95, -0.05 * h)]));
    return roads;
  }
}
