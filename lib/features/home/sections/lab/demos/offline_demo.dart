import 'package:flutter/material.dart';

import '../../../../../core/motion/springs.dart';
import '../../../../../data/copy.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../../widgets/pressable.dart';
import '../logic/sync_queue.dart';

/// A courier-style screen backed by [SyncQueue]: flip the network off,
/// queue actions, flip it back on and watch them sync in order.
class OfflineDemo extends StatefulWidget {
  const OfflineDemo({super.key, required this.copy});

  final OfflineCopy copy;

  @override
  State<OfflineDemo> createState() => _OfflineDemoState();
}

class _OfflineDemoState extends State<OfflineDemo> {
  late final SyncQueue _queue = SyncQueue(send: _send);

  /// The fake server: takes a moment, and fails if the network dropped
  /// while the request was in flight (that action then stays queued).
  Future<void> _send(QueuedAction action) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!_queue.online) throw const OfflineException();
  }

  @override
  void dispose() {
    _queue.dispose();
    super.dispose();
  }

  IconData _iconFor(int index) => switch (index) {
    0 => Icons.qr_code_scanner_rounded,
    1 => Icons.inventory_2_outlined,
    _ => Icons.payments_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final copy = widget.copy;
    return ColoredBox(
      color: t.background,
      child: ListenableBuilder(
        listenable: _queue,
        builder: (context, _) {
          final online = _queue.online;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 46),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        copy.appTitle,
                        style: type.title.copyWith(fontSize: 16),
                      ),
                    ),
                    _NetworkSwitch(
                      online: online,
                      copy: copy,
                      onChanged: _queue.setOnline,
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: SpringCurve(Springs.gentle).duration,
                curve: SpringCurve(Springs.gentle),
                child: online
                    ? const SizedBox(width: double.infinity)
                    : Semantics(
                        liveRegion: true,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: t.offline.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(Radii.s + 2),
                            border: Border.all(
                              color: t.offline.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.cloud_off_rounded,
                                size: 16,
                                color: t.offline,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  copy.offlineBanner,
                                  style: type.small.copyWith(
                                    fontSize: 12.5,
                                    color: t.offline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Column(
                  children: [
                    for (var i = 0; i < copy.actions.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ActionButton(
                          icon: _iconFor(i),
                          label: copy.actions[i],
                          onTap: () => _queue.add(copy.actions[i]),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                  children: [
                    _ListHeader(
                      label: copy.queued,
                      count: _queue.pending.length,
                      color: t.offline,
                    ),
                    if (_queue.pending.isEmpty)
                      _Empty(copy.emptyQueue)
                    else
                      for (final a in _queue.pending)
                        _ActionRow(
                          key: ValueKey('p${a.id}'),
                          action: a,
                          syncing: _queue.inFlight == a,
                          syncingLabel: copy.syncing,
                        ),
                    const SizedBox(height: 12),
                    _ListHeader(
                      label: copy.synced,
                      count: _queue.synced.length,
                      color: t.success,
                    ),
                    if (_queue.synced.isEmpty)
                      _Empty(copy.emptySynced)
                    else
                      for (final a in _queue.synced.take(6))
                        _ActionRow(
                          key: ValueKey('s${a.id}'),
                          action: a,
                          synced: true,
                          syncingLabel: copy.syncing,
                        ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NetworkSwitch extends StatelessWidget {
  const _NetworkSwitch({
    required this.online,
    required this.copy,
    required this.onChanged,
  });

  final bool online;
  final OfflineCopy copy;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = online ? t.success : t.offline;
    return Semantics(
      toggled: online,
      child: Pressable(
        semanticLabel:
            '${copy.networkLabel}: ${online ? copy.online : copy.offline}',
        onTap: () => onChanged(!online),
        focusRadius: 20,
        builder: (context, states) => AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                online ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                online ? copy.online : copy.offline,
                style: context.type.label.copyWith(
                  fontSize: 12.5,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
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
      onTap: onTap,
      builder: (context, states) => AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: states.contains(WidgetState.hovered)
              ? t.surfaceRaised
              : t.surface,
          borderRadius: BorderRadius.circular(Radii.s + 2),
          border: Border.all(color: t.lineStrong),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: t.signalText),
            const SizedBox(width: 10),
            Text(label, style: context.type.label.copyWith(fontSize: 13.5)),
          ],
        ),
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  const _ListHeader({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(label, style: context.type.small.copyWith(fontSize: 12.5)),
          const SizedBox(width: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, a) =>
                ScaleTransition(scale: a, child: child),
            child: Text(
              '$count',
              key: ValueKey(count),
              style: context.type.mono.copyWith(fontSize: 12, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Text(text, style: context.type.small.copyWith(fontSize: 12.5)),
  );
}

/// One queued or synced action. Rows spring in when they appear, so the
/// move from "waiting" to "synced" is visible.
class _ActionRow extends StatelessWidget {
  const _ActionRow({
    super.key,
    required this.action,
    required this.syncingLabel,
    this.syncing = false,
    this.synced = false,
  });

  final QueuedAction action;
  final String syncingLabel;
  final bool syncing;
  final bool synced;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final curve = SpringCurve(Springs.playful);
    final row = Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(Radii.s),
        border: Border.all(color: t.line),
      ),
      child: Row(
        children: [
          if (syncing)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: t.signalText,
              ),
            )
          else
            Icon(
              synced ? Icons.check_circle_rounded : Icons.schedule_rounded,
              size: 15,
              color: synced ? t.success : t.offline,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              action.label,
              style: type.label.copyWith(fontSize: 12.5),
            ),
          ),
          Text(
            syncing ? syncingLabel : '#${action.id.toString().padLeft(3, '0')}',
            style: type.mono.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
    if (context.reduceMotion) return row;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: curve.duration,
      curve: curve,
      builder: (context, v, child) => Opacity(
        opacity: v.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - v) * 10),
          child: child,
        ),
      ),
      child: row,
    );
  }
}
