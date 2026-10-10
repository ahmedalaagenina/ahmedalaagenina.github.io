import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/motion/springs.dart';
import '../../../../core/responsive.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/motion/magnetic.dart';
import '../../../../widgets/motion/rotating_text.dart';
import '../../../../widgets/motion/staggered_text.dart';
import '../../../../widgets/motion/visibility_gate.dart';
import 'contour_field.dart';

/// First screen: name, rotating role, one-liner, two CTAs, over the
/// interactive contour field.
///
/// The entrance is one orchestrated sequence (a single controller, staggered
/// intervals) that starts when [start] turns true, i.e. when the intro has
/// handed over. Everything after that only moves in response to the visitor.
class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.identity,
    required this.copy,
    required this.start,
    required this.topInset,
    required this.onSeeWork,
    required this.onDownloadCv,
  });

  final Identity identity;
  final HeroCopy copy;
  final ValueListenable<bool> start;

  /// Height of the nav bar floating above the hero.
  final double topInset;
  final VoidCallback onSeeWork;
  final VoidCallback onDownloadCv;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );
  final _pointer = ValueNotifier<Offset?>(null);
  double? _frozenWidth;
  double _frozenHeight = 0;

  @override
  void initState() {
    super.initState();
    widget.start.addListener(_maybeStart);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) _entrance.value = 1;
    _maybeStart();
  }

  @override
  void dispose() {
    widget.start.removeListener(_maybeStart);
    _entrance.dispose();
    _pointer.dispose();
    super.dispose();
  }

  void _maybeStart() {
    if (widget.start.value && _entrance.isDismissed) _entrance.forward();
  }

  Animation<double> _interval(double begin, double end) => CurvedAnimation(
    parent: _entrance,
    curve: Interval(begin, end, curve: SpringCurve(Springs.gentle)),
  );

  /// Fades and lifts a block in during its slice of the entrance.
  Widget _enter(double begin, Widget child) {
    final a = _interval(begin, (begin + 0.55).clamp(0.0, 1.0));
    return AnimatedBuilder(
      animation: a,
      builder: (context, child) => Opacity(
        opacity: a.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - a.value) * 18),
          child: child,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final width = MediaQuery.sizeOf(context).width;
    // Freeze the height on first build (re-measured only when the width
    // changes) so mobile URL bars sliding in and out don't resize the hero.
    if (_frozenWidth != width) {
      _frozenWidth = width;
      _frozenHeight = MediaQuery.sizeOf(context).height;
    }
    final minHeight = _frozenHeight.clamp(620.0, 980.0);

    return VisibilityGate(
      builder: (context, visible) => Listener(
        onPointerHover: (e) => _pointer.value = e.localPosition,
        onPointerMove: (e) => _pointer.value = e.localPosition,
        onPointerDown: (e) => _pointer.value = e.localPosition,
        child: MouseRegion(
          opaque: false,
          onExit: (_) => _pointer.value = null,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ExcludeSemantics(
                    child: ContourField(pointer: _pointer, active: visible),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: widget.topInset + context.pick(48, desktop: 72),
                    bottom: context.pick(56, desktop: 88),
                  ),
                  child: MaxWidth(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            minHeight -
                            widget.topInset -
                            context.pick(104, desktop: 160),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: StaggeredText(
                              text: widget.identity.displayName,
                              style: type.hero,
                              progress: _interval(0, 0.62),
                            ),
                          ),
                          SizedBox(height: context.pick(18, desktop: 26)),
                          _enter(
                            0.28,
                            RotatingText(
                              texts: widget.copy.roles,
                              active: visible,
                              style: type.headline.copyWith(
                                fontSize: context.pick(20, desktop: 28),
                                fontWeight: FontWeight.w500,
                                color: t.signalText,
                              ),
                            ),
                          ),
                          SizedBox(height: context.pick(22, desktop: 30)),
                          _enter(
                            0.38,
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 640),
                              child: Text(
                                widget.copy.oneLiner,
                                style: type.lead.copyWith(color: t.text),
                              ),
                            ),
                          ),
                          SizedBox(height: context.pick(32, desktop: 40)),
                          _enter(
                            0.46,
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                Magnetic(
                                  child: AppButton(
                                    label: widget.copy.primaryCta,
                                    onTap: widget.onSeeWork,
                                  ),
                                ),
                                Magnetic(
                                  child: AppButton(
                                    label: widget.copy.secondaryCta,
                                    tone: ButtonTone.secondary,
                                    icon: const Icon(Icons.download_rounded),
                                    onTap: widget.onDownloadCv,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: context.pick(36, desktop: 48)),
                          _enter(
                            0.54,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  size: 16,
                                  color: t.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${widget.copy.locationPrefix} '
                                  '${widget.identity.location}',
                                  style: type.small,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
