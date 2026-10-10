/// Deferred entry point of the Lab demos.
///
/// `lab_section.dart` imports this file with `deferred as`, so this file and
/// everything only it uses (the fleet simulation, clustering, sync queue,
/// PDF geometry and the demo widgets) ship in a separate chunk, downloaded
/// when the Lab section approaches the viewport instead of at startup.
///
/// The boundary is deliberately one function taking plain arguments:
/// types from a deferred library can't be named by eagerly loaded code.
library;

import 'package:flutter/widgets.dart';

import '../../../../../data/copy.dart';
import 'fleet_demo.dart';
import 'offline_demo.dart';
import 'sign_demo.dart';

/// Builds demo number [index] (0 fleet, 1 offline, 2 sign). [active] is
/// false while the section is off screen, which pauses animated demos.
Widget buildDemo(int index, LabCopy copy, {required bool active}) =>
    switch (index) {
      0 => FleetDemo(copy: copy.fleet, active: active),
      1 => OfflineDemo(copy: copy.offline),
      _ => SignDemo(copy: copy.sign),
    };
