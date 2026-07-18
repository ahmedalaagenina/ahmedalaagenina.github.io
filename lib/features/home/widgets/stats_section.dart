import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/responsive.dart';
import '../../../data/cv_data.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/reveal.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return MaxWidth(
      child: Reveal(
        child: GlassCard(
          hoverable: false,
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 24 : 36,
            horizontal: isMobile ? 16 : 32,
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: 28,
            children: [
              for (final stat in CV.stats)
                SizedBox(
                  width: isMobile ? 150 : 220,
                  child: _AnimatedStat(stat: stat),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedStat extends StatefulWidget {
  final StatRecord stat;

  const _AnimatedStat({required this.stat});

  @override
  State<_AnimatedStat> createState() => _AnimatedStatState();
}

class _AnimatedStatState extends State<_AnimatedStat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  late final Animation<double> _value = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutExpo,
  );
  bool _started = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isMobile = context.isMobile;

    return VisibilityDetector(
      key: ValueKey('stat-${widget.stat.label}'),
      onVisibilityChanged: (info) {
        if (!_started && info.visibleFraction > .4) {
          _started = true;
          _controller.forward();
        }
      },
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _value,
            builder: (context, _) => GradientText(
              '${(_value.value * widget.stat.value).round()}'
              '${widget.stat.suffix}',
              style: (isMobile ? theme.displaySmall : theme.displayMedium)
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.stat.label,
            style: theme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
