import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/motion/springs.dart';
import '../../../../core/responsive.dart';
import '../../../../data/copy.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/motion/visibility_gate.dart';
import '../../../../widgets/phone_frame.dart';
import '../../../../widgets/pressable.dart';
import '../../../../widgets/section_heading.dart';
import 'demos/demos.dart' deferred as demos;

/// "Lab": live mini-demos that prove the skills instead of listing them.
///
/// Only the selected demo exists at any time, it pauses when the section
/// leaves the screen, and its code is loaded on demand (deferred import).
class LabSection extends StatefulWidget {
  const LabSection({super.key, required this.copy});

  final LabCopy copy;

  @override
  State<LabSection> createState() => _LabSectionState();
}

class _LabSectionState extends State<LabSection> {
  int _selected = 0;
  Future<void>? _loading;
  bool _loaded = false;

  List<DemoTabCopy> get _tabs => [
    widget.copy.fleet.tab,
    widget.copy.offline.tab,
    widget.copy.sign.tab,
  ];

  void _load() {
    _loading ??= demos.loadLibrary().then((_) {
      if (mounted) setState(() => _loaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;
    final width = MediaQuery.sizeOf(context).width;
    final phoneWidth = desktop
        ? 320.0
        : math.min(320.0, width - context.gutter * 2 - 24);

    return VisibilityGate(
      onFirstVisible: _load,
      builder: (context, visible) {
        final phone = PhoneFrame(
          width: phoneWidth,
          screen: _loaded
              ? AnimatedSwitcher(
                  duration: context.reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 260),
                  child: KeyedSubtree(
                    key: ValueKey(_selected),
                    child: demos.buildDemo(
                      _selected,
                      widget.copy,
                      active: visible,
                    ),
                  ),
                )
              : _Loading(label: widget.copy.loading),
        );

        return MaxWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(
                title: widget.copy.title,
                intro: widget.copy.intro,
              ),
              SizedBox(height: context.pick(36, desktop: 56)),
              if (desktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          for (var i = 0; i < _tabs.length; i++)
                            _TabTile(
                              tab: _tabs[i],
                              selected: i == _selected,
                              onTap: () => setState(() => _selected = i),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 72),
                    phone,
                    const SizedBox(width: 40),
                  ],
                )
              else ...[
                _Segments(
                  tabs: _tabs,
                  selected: _selected,
                  onSelect: (i) => setState(() => _selected = i),
                ),
                const SizedBox(height: 28),
                Center(child: phone),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _tabs[_selected].caption,
                    key: ValueKey(_selected),
                    style: context.type.body,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return ColoredBox(
      color: t.background,
      child: Center(
        child: Semantics(
          label: label,
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: t.signalText,
            ),
          ),
        ),
      ),
    );
  }
}

/// Desktop tab: title + caption, with an accent bar when selected.
class _TabTile extends StatelessWidget {
  const _TabTile({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final DemoTabCopy tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final curve = SpringCurve(Springs.gentle);
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Pressable(
        semanticLabel: '${tab.tab}. ${tab.caption}',
        onTap: onTap,
        pressScale: 0.99,
        builder: (context, states) {
          final hovered = states.contains(WidgetState.hovered);
          return AnimatedContainer(
            duration: curve.duration,
            curve: curve,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
            decoration: BoxDecoration(
              color: selected
                  ? t.surface
                  : hovered
                  ? t.surface.withValues(alpha: 0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(Radii.l),
              border: Border.all(
                color: selected ? t.lineStrong : Colors.transparent,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: curve.duration,
                  curve: curve,
                  width: 3,
                  height: selected ? 52 : 22,
                  margin: const EdgeInsets.only(top: 3, right: 18),
                  decoration: BoxDecoration(
                    color: selected ? t.signal : t.lineStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tab.tab,
                        style: type.headline.copyWith(
                          color: selected || hovered ? t.text : t.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(tab.caption, style: type.body),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Mobile: a segmented control.
class _Segments extends StatelessWidget {
  const _Segments({
    required this.tabs,
    required this.selected,
    required this.onSelect,
  });

  final List<DemoTabCopy> tabs;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(Radii.m),
        border: Border.all(color: t.line),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: Semantics(
                selected: i == selected,
                inMutuallyExclusiveGroup: true,
                child: Pressable(
                  semanticLabel: tabs[i].tab,
                  onTap: () => onSelect(i),
                  focusRadius: Radii.s,
                  builder: (context, states) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selected ? t.surfaceRaised : null,
                      borderRadius: BorderRadius.circular(Radii.s),
                    ),
                    child: Text(
                      tabs[i].tab,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.type.label.copyWith(
                        fontSize: 13,
                        color: i == selected ? t.text : t.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
