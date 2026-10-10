import 'dart:async';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mycv/features/home/sections/lab/logic/fleet_simulation.dart';
import 'package:mycv/features/home/sections/lab/logic/grid_clusterer.dart';
import 'package:mycv/features/home/sections/lab/logic/page_geometry.dart';
import 'package:mycv/features/home/sections/lab/logic/sync_queue.dart';

void main() {
  group('GridClusterer', () {
    const clusterer = GridClusterer(cellSize: 50);

    test('groups points that share a cell', () {
      final clusters = clusterer.cluster(const [
        Offset(10, 10),
        Offset(20, 30),
        Offset(120, 10),
      ]);
      expect(clusters, hasLength(2));
      final big = clusters.firstWhere((c) => c.size == 2);
      expect(big.members, containsAll([0, 1]));
      expect(big.center, const Offset(15, 20));
    });

    test('zooming in (spreading points) splits clusters', () {
      const points = [Offset(10, 10), Offset(30, 30)];
      expect(clusterer.cluster(points), hasLength(1));
      final zoomed = [for (final p in points) p * 3];
      expect(clusterer.cluster(zoomed), hasLength(2));
    });

    test('handles negative coordinates (panned off screen)', () {
      final clusters = clusterer.cluster(const [
        Offset(-10, -10),
        Offset(10, 10),
      ]);
      expect(clusters, hasLength(2));
    });
  });

  group('FleetSimulation', () {
    test('is deterministic for a seed', () {
      final a = FleetSimulation(vehicles: 20, seed: 1)..poll(1);
      final b = FleetSimulation(vehicles: 20, seed: 1)..poll(1);
      for (var i = 0; i < 20; i++) {
        expect(a.vehicles[i].current, b.vehicles[i].current);
      }
    });

    test('poll keeps the previous position for interpolation', () {
      final sim = FleetSimulation(vehicles: 50);
      final moving = sim.vehicles.firstWhere(
        (v) => v.status == VehicleStatus.moving,
      );
      final before = moving.current;
      sim.poll(1);
      expect(moving.previous, before);
      expect(moving.positionAt(0), before);
      expect(moving.positionAt(1), moving.current);
    });

    test('stopped vehicles never move', () {
      final sim = FleetSimulation(vehicles: 200);
      final stopped = sim.vehicles.where(
        (v) => v.status == VehicleStatus.stopped,
      );
      final before = [for (final v in stopped) v.current];
      sim.poll(5);
      expect([for (final v in stopped) v.current], before);
    });
  });

  group('SyncQueue', () {
    test('syncs immediately while online, in order', () async {
      final sent = <String>[];
      final queue = SyncQueue(
        send: (a) async {
          sent.add(a.label);
        },
      );
      queue
        ..add('scan')
        ..add('deliver');
      await pumpEventQueue();
      expect(sent, ['scan', 'deliver']);
      expect(queue.pending, isEmpty);
      expect(queue.synced.map((a) => a.label), ['deliver', 'scan']);
    });

    test('keeps actions while offline and drains them on reconnect', () async {
      final sent = <String>[];
      final queue = SyncQueue(
        send: (a) async {
          sent.add(a.label);
        },
      )..setOnline(false);
      queue
        ..add('scan')
        ..add('deliver')
        ..add('pay');
      await pumpEventQueue();
      expect(sent, isEmpty);
      expect(queue.pending, hasLength(3));

      queue.setOnline(true);
      await pumpEventQueue();
      expect(sent, ['scan', 'deliver', 'pay']);
      expect(queue.pending, isEmpty);
    });

    test('an action that fails mid-flight stays queued and is retried', () {
      late SyncQueue queue;
      final gate = Completer<void>();
      var attempts = 0;
      queue = SyncQueue(
        send: (a) async {
          attempts++;
          if (attempts == 1) {
            await gate.future;
            if (!queue.online) throw const OfflineException();
          }
        },
      );
      return Future(() async {
        queue.add('scan');
        await pumpEventQueue();
        expect(queue.inFlight?.label, 'scan');

        queue.setOnline(false); // network drops while the request is out
        gate.complete();
        await pumpEventQueue();
        expect(queue.pending.single.label, 'scan');
        expect(queue.synced, isEmpty);

        queue.setOnline(true);
        await pumpEventQueue();
        expect(attempts, 2);
        expect(queue.pending, isEmpty);
        expect(queue.synced.single.label, 'scan');
      });
    });

    test('never runs two drain loops at once', () async {
      var concurrent = 0;
      var maxConcurrent = 0;
      final queue = SyncQueue(
        send: (a) async {
          concurrent++;
          if (concurrent > maxConcurrent) maxConcurrent = concurrent;
          await Future<void>.delayed(Duration.zero);
          concurrent--;
        },
      );
      // Flapping network + rapid taps: classic duplicate-loop trigger.
      for (var i = 0; i < 5; i++) {
        queue
          ..add('tap $i')
          ..setOnline(false)
          ..setOnline(true);
      }
      await pumpEventQueue(times: 50);
      expect(maxConcurrent, 1);
      expect(queue.synced, hasLength(5));
    });
  });

  group('PageGeometry', () {
    const geometry = PageGeometry(page: Size(612, 792), view: Size(306, 396));
    const field = Size(160, 50);

    test('flips the y axis between PDF and view space', () {
      // A field at the PDF bottom-left corner sits at the view's bottom.
      final rect = geometry.toView(Offset.zero, field);
      expect(rect.left, 0);
      expect(rect.bottom, 396);
      expect(rect.size, const Size(80, 25));
    });

    test('moving down on screen lowers the PDF y', () {
      final moved = geometry.moveBy(
        const Offset(100, 400),
        field,
        const Offset(10, 20),
      );
      expect(moved, const Offset(120, 360));
    });

    test('keeps the field on the page', () {
      final moved = geometry.moveBy(
        const Offset(500, 10),
        field,
        const Offset(500, 500),
      );
      expect(moved, Offset(612 - field.width, 0));
    });
  });
}
