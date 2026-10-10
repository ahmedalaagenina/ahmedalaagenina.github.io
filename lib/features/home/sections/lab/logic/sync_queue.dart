import 'package:flutter/foundation.dart';

class QueuedAction {
  QueuedAction(this.id, this.label);

  final int id;
  final String label;
}

/// Thrown by a sender when the request can't reach the server.
class OfflineException implements Exception {
  const OfflineException();
}

/// An offline-first action queue, the core idea of the Aramex sync engine:
///
/// 1. Every action is saved locally first ([pending]), so nothing is lost
///    when there is no connection.
/// 2. One drain loop sends actions strictly in order (FIFO), one at a time,
///    so the server sees "scan" before "delivered".
/// 3. A send that fails (the network dropped mid-flight) leaves the action
///    at the head of the queue; it is retried on the next reconnect.
/// 4. A guard flag makes sure only one drain loop ever runs, however many
///    times the network flaps or the user taps.
class SyncQueue extends ChangeNotifier {
  SyncQueue({required this.send});

  /// Delivers one action to the "server".
  final Future<void> Function(QueuedAction action) send;

  final List<QueuedAction> pending = [];
  final List<QueuedAction> synced = [];
  QueuedAction? inFlight;
  bool _online = true;
  bool _draining = false;
  bool _disposed = false;
  int _nextId = 1;

  bool get online => _online;
  bool get draining => _draining;

  void add(String label) {
    pending.add(QueuedAction(_nextId++, label));
    _notify();
    _drain();
  }

  void setOnline(bool online) {
    if (_online == online) return;
    _online = online;
    _notify();
    if (online) _drain();
  }

  Future<void> _drain() async {
    if (_draining) return; // the single-loop guard
    _draining = true;
    try {
      while (_online && pending.isNotEmpty && !_disposed) {
        final action = pending.first;
        inFlight = action;
        _notify();
        try {
          await send(action);
        } on OfflineException {
          break; // keep it at the head; retry on reconnect
        } finally {
          inFlight = null;
        }
        if (_disposed) return;
        pending.remove(action);
        synced.insert(0, action);
        _notify();
      }
    } finally {
      _draining = false;
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
