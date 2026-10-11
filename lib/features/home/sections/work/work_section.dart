import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/motion/springs.dart';
import '../../../../core/responsive.dart';
import '../../../../data/copy.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/bullet_list.dart';
import '../../../../widgets/motion/tilt.dart';
import '../../../../widgets/motion/visibility_gate.dart';
import '../../../../widgets/phone_frame.dart';
import '../../../../widgets/pressable.dart';
import '../../../../widgets/section_heading.dart';
import '../../../../widgets/store_links.dart';
import 'showcase_item.dart';
import 'showcase_screen.dart';

/// "Selected work": the phone is the stage.
///
/// - Desktop: project details scroll on the left while one phone stays
///   pinned on the right, switching screens as each project reaches the
///   middle of the viewport, and tilting toward the mouse.
/// - Mobile/tablet: one phone per project, tilting with scroll position.
class WorkSection extends StatefulWidget {
  const WorkSection({
    super.key,
    required this.copy,
    required this.common,
    required this.items,
    required this.scroll,
    required this.navHeight,
  });

  final WorkCopy copy;
  final CommonCopy common;
  final List<ShowcaseItem> items;
  final ScrollController scroll;
  final double navHeight;

  @override
  State<WorkSection> createState() => _WorkSectionState();
}

class _WorkSectionState extends State<WorkSection> {
  static const double _dotsHeight = 56;

  final _stackKey = GlobalKey();
  late final List<GlobalKey> _entryKeys = [
    for (final _ in widget.items) GlobalKey(),
  ];

  // Scroll-driven values. Only their listeners rebuild, so scrolling never
  // rebuilds the entries themselves.
  final _phoneTop = ValueNotifier<double>(0);
  final _active = ValueNotifier<int>(0);
  final _tilt = ValueNotifier<Offset>(Offset.zero);

  bool _load = false;
  double _viewport = 800;
  double _phoneWidth = 300;

  double get _phoneBlockHeight =>
      _phoneWidth * PhoneFrame.aspectRatio + _dotsHeight;

  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
    // Decode the screenshots in idle time after the intro, not in the
    // middle of the visitor's first scroll into this section.
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (mounted && !_load) setState(() => _load = true);
    });
  }

  @override
  void dispose() {
    widget.scroll.removeListener(_onScroll);
    _phoneTop.dispose();
    _active.dispose();
    _tilt.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final stack = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stack == null || !stack.hasSize) return;

    final available = _viewport - widget.navHeight;
    final center = widget.navHeight + available / 2;

    // Pin: keep the phone centered in the viewport while the section is on
    // screen, clamped to the section's own bounds.
    final top = stack.localToGlobal(Offset.zero).dy;
    final desired = widget.navHeight + (available - _phoneBlockHeight) / 2;
    final maxTop = math.max(0.0, stack.size.height - _phoneBlockHeight);
    _phoneTop.value = (desired - top).clamp(0.0, maxTop);

    // Active entry: the one whose center is closest to the viewport center.
    var best = _active.value;
    var bestDistance = double.infinity;
    for (var i = 0; i < _entryKeys.length; i++) {
      final box =
          _entryKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final c = box.localToGlobal(Offset.zero).dy + box.size.height / 2;
      final d = (c - center).abs();
      if (d < bestDistance) {
        best = i;
        bestDistance = d;
      }
    }
    _active.value = best;
  }

  void _scrollToEntry(int i) {
    final box = _entryKeys[i].currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final center = widget.navHeight + (_viewport - widget.navHeight) / 2;
    final target =
        widget.scroll.offset +
        box.localToGlobal(Offset.zero).dy +
        box.size.height / 2 -
        center;
    final clamped = target.clamp(0.0, widget.scroll.position.maxScrollExtent);
    if (context.reduceMotion) {
      widget.scroll.jumpTo(clamped);
    } else {
      widget.scroll.animateTo(
        clamped,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onHover(PointerHoverEvent event) {
    final stack = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stack == null || !stack.hasSize) return;
    // Pointer position relative to the phone's center, normalized to -1..1
    // over half the viewport, so the phone "looks at" the mouse.
    final phoneCenter = Offset(
      stack.size.width - (_phoneWidth + 120) / 2,
      _phoneTop.value + _phoneWidth * PhoneFrame.aspectRatio / 2,
    );
    final local = stack.globalToLocal(event.position);
    final d = local - phoneCenter;
    _tilt.value = Offset(
      (d.dx / (stack.size.width / 2)).clamp(-1.0, 1.0),
      (d.dy / (_viewport / 2)).clamp(-1.0, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    _viewport = MediaQuery.sizeOf(context).height;
    _phoneWidth =
        ((_viewport - widget.navHeight - 140) / PhoneFrame.aspectRatio).clamp(
          230.0,
          310.0,
        );
    final desktop = context.isDesktop;

    return VisibilityGate(
      onFirstVisible: () => setState(() => _load = true),
      builder: (context, visible) => MaxWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeading(title: widget.copy.title, intro: widget.copy.intro),
            SizedBox(height: context.pick(48, desktop: 24)),
            if (desktop) _desktop(visible) else _mobile(),
          ],
        ),
      ),
    );
  }

  Widget _desktop(bool visible) {
    final entryHeight = math.max(_viewport * 0.78, 560.0);
    final phoneColumn = _phoneWidth + 120;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    return MouseRegion(
      onHover: _onHover,
      onExit: (_) => _tilt.value = Offset.zero,
      child: Stack(
        key: _stackKey,
        children: [
          Padding(
            padding: EdgeInsets.only(right: phoneColumn + 48),
            child: Column(
              children: [
                for (var i = 0; i < widget.items.length; i++)
                  SizedBox(
                    key: _entryKeys[i],
                    height: entryHeight,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ValueListenableBuilder<int>(
                        valueListenable: _active,
                        builder: (context, active, child) =>
                            _ActiveMarker(active: active == i, child: child!),
                        child: _EntryDetails(
                          item: widget.items[i],
                          common: widget.common,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            width: phoneColumn,
            // Own layer: pinning moves the phone every scroll frame.
            child: RepaintBoundary(
              child: ValueListenableBuilder<double>(
                valueListenable: _phoneTop,
                builder: (context, top, child) =>
                    Transform.translate(offset: Offset(0, top), child: child),
                child: ExcludeSemantics(
                  child: ValueListenableBuilder<int>(
                    valueListenable: _active,
                    builder: (context, active, _) => Column(
                      children: [
                        Tilt(
                          input: _tilt,
                          maxAngle: 0.16,
                          overlayBuilder: (context, t) =>
                              _Glare(tilt: t, radius: _phoneWidth * 0.16),
                          child: PhoneFrame(
                            width: _phoneWidth,
                            glowColor: Color(widget.items[active].entry.tint),
                            screen: _SwitchingScreen(
                              item: widget.items[active],
                              index: active,
                              load: _load,
                              cycle: visible,
                              decodeWidth: (_phoneWidth * dpr).round(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _Dots(
                          count: widget.items.length,
                          active: active,
                          labels: [
                            for (final item in widget.items) item.product.name,
                          ],
                          onTap: _scrollToEntry,
                        ),
                      ],
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

  Widget _mobile() {
    return Column(
      children: [
        for (final item in widget.items)
          Padding(
            padding: const EdgeInsets.only(bottom: 88),
            child: _MobileEntry(
              item: item,
              common: widget.common,
              scroll: widget.scroll,
              load: _load,
            ),
          ),
      ],
    );
  }
}

/// Cross-fades between projects: the new screen rises slightly into place.
class _SwitchingScreen extends StatelessWidget {
  const _SwitchingScreen({
    required this.item,
    required this.index,
    required this.load,
    required this.cycle,
    required this.decodeWidth,
  });

  final ShowcaseItem item;
  final int index;
  final bool load;
  final bool cycle;
  final int decodeWidth;

  @override
  Widget build(BuildContext context) {
    final curve = SpringCurve(Springs.gentle);
    return AnimatedSwitcher(
      duration: context.reduceMotion ? Duration.zero : curve.duration,
      switchInCurve: curve,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: ShowcaseScreen(
        key: ValueKey(index),
        item: item,
        load: load,
        cycle: cycle,
        decodeWidth: decodeWidth,
      ),
    );
  }
}

/// A moving reflection on the glass, so the tilt reads as a real surface.
class _Glare extends StatelessWidget {
  const _Glare({required this.tilt, required this.radius});

  final Offset tilt;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1 - tilt.dx, -1 - tilt.dy),
            end: Alignment(0.6 - tilt.dx, 0.6 - tilt.dy),
            colors: [
              Colors.white.withValues(alpha: 0.10),
              Colors.white.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

/// A thin accent bar beside the project currently shown on the phone.
class _ActiveMarker extends StatelessWidget {
  const _ActiveMarker({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 420),
          curve: SpringCurve(Springs.gentle),
          width: 2,
          height: active ? 120 : 40,
          margin: const EdgeInsets.only(top: 6, right: 28),
          decoration: BoxDecoration(
            color: active ? t.signal : t.line,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        Flexible(child: child),
      ],
    );
  }
}

class _EntryDetails extends StatelessWidget {
  const _EntryDetails({required this.item, required this.common});

  final ShowcaseItem item;
  final CommonCopy common;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final product = item.product;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 540),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: ResizeImage(AssetImage(item.entry.icon), width: 132),
                  width: 44,
                  height: 44,
                  excludeFromSemantics: true,
                ),
              ),
              const SizedBox(width: 14),
              Flexible(child: Text(item.entry.company, style: type.small)),
            ],
          ),
          const SizedBox(height: 20),
          Semantics(
            header: true,
            child: Text(
              product.name,
              style: type.display.copyWith(
                fontSize: context.pick(30, tablet: 36, desktop: 44),
              ),
            ),
          ),
          if (product.category != null) ...[
            const SizedBox(height: 10),
            Text(
              product.category!,
              style: type.label.copyWith(color: t.signalText),
            ),
          ],
          const SizedBox(height: 22),
          BulletList(bullets: item.highlights),
          const SizedBox(height: 14),
          StoreLinks(
            productName: product.name,
            links: product.links,
            copy: common,
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.count,
    required this.active,
    required this.labels,
    required this.onTap,
  });

  final int count;
  final int active;
  final List<String> labels;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          Pressable(
            semanticLabel: labels[i],
            tooltip: labels[i],
            onTap: () => onTap(i),
            focusRadius: 8,
            builder: (context, states) => SizedBox(
              width: 28,
              height: 28,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 360),
                  curve: SpringCurve(Springs.gentle),
                  width: i == active ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == active
                        ? t.signal
                        : states.contains(WidgetState.hovered)
                        ? t.textMuted
                        : t.lineStrong,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Mobile: phone above details. The phone tilts as it travels through the
/// viewport, so scrolling itself becomes the interaction.
class _MobileEntry extends StatefulWidget {
  const _MobileEntry({
    required this.item,
    required this.common,
    required this.scroll,
    required this.load,
  });

  final ShowcaseItem item;
  final CommonCopy common;
  final ScrollController scroll;
  final bool load;

  @override
  State<_MobileEntry> createState() => _MobileEntryState();
}

class _MobileEntryState extends State<_MobileEntry> {
  final _tilt = ValueNotifier<Offset>(Offset.zero);
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scroll.removeListener(_onScroll);
    _tilt.dispose();
    super.dispose();
  }

  /// One measurement per scroll event drives both the tilt and the
  /// visibility flag (no separate VisibilityDetector per card).
  void _onScroll() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final viewport = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    final visible = top < viewport && top + box.size.height > 0;
    if (visible != _visible) setState(() => _visible = visible);
    if (!visible) return;
    final center = top + box.size.height * 0.3;
    final d = (center - viewport / 2) / viewport;
    _tilt.value = Offset(0, (d * 1.4).clamp(-1.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    final width = math.min(260.0, MediaQuery.sizeOf(context).width * 0.66);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ExcludeSemantics(
            child: Tilt(
              input: _tilt,
              maxAngle: 0.2,
              child: PhoneFrame(
                width: width,
                lowCost: true,
                glowColor: Color(widget.item.entry.tint),
                screen: ShowcaseScreen(
                  item: widget.item,
                  load: widget.load,
                  cycle: _visible,
                  decodeWidth: (width * dpr).round(),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 36),
        _EntryDetails(item: widget.item, common: widget.common),
      ],
    );
  }
}
