import 'package:flutter/material.dart';

import '../../../../core/motion/springs.dart';
import '../../../../core/responsive.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/pressable.dart';
import '../../../../widgets/section_heading.dart';

/// Skills as a readable list that answers "where did you use this?".
///
/// Hovering, focusing or tapping a skill shows where it appears in the
/// experience section ([usage] is derived from the CV text). Plain text,
/// fully readable without interacting.
class SkillsSection extends StatelessWidget {
  const SkillsSection({
    super.key,
    required this.copy,
    required this.groups,
    required this.usage,
  });

  final SkillsCopy copy;
  final List<SkillGroup> groups;
  final Map<String, List<String>> usage;

  @override
  Widget build(BuildContext context) {
    return MaxWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(title: copy.title),
          SizedBox(height: context.pick(32, desktop: 48)),
          for (final group in groups)
            _GroupRow(group: group, usage: usage, copy: copy),
        ],
      ),
    );
  }
}

class _GroupRow extends StatefulWidget {
  const _GroupRow({
    required this.group,
    required this.usage,
    required this.copy,
  });

  final SkillGroup group;
  final Map<String, List<String>> usage;
  final SkillsCopy copy;

  @override
  State<_GroupRow> createState() => _GroupRowState();
}

class _GroupRowState extends State<_GroupRow> {
  /// The skill whose usage is shown (hover, focus or tap), if any.
  String? _shown;

  void _show(String? skill) {
    if (_shown != skill) setState(() => _shown = skill);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final curve = SpringCurve(Springs.gentle);
    final shown = _shown;
    final places = shown == null ? const <String>[] : widget.usage[shown]!;

    final tokens = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final skill in widget.group.skills)
              _SkillToken(
                skill: skill,
                places: widget.usage[skill.name]!,
                selected: shown == skill.name,
                copy: widget.copy,
                onHover: (h) => _show(h ? skill.name : null),
                onTap: () => _show(shown == skill.name ? null : skill.name),
              ),
          ],
        ),
        AnimatedSize(
          duration: context.reduceMotion ? Duration.zero : curve.duration,
          curve: curve,
          alignment: Alignment.topLeft,
          child: places.isEmpty
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: shown,
                          style: TextStyle(
                            color: t.signalText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: '   ${places.join(', ')}'),
                      ],
                    ),
                    style: type.small,
                  ),
                ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: t.line)),
      ),
      child: context.isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 24),
                    child: Text(widget.group.title, style: type.title),
                  ),
                ),
                Expanded(child: tokens),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.group.title, style: type.title),
                const SizedBox(height: 14),
                tokens,
              ],
            ),
    );
  }
}

class _SkillToken extends StatelessWidget {
  const _SkillToken({
    required this.skill,
    required this.places,
    required this.selected,
    required this.copy,
    required this.onHover,
    required this.onTap,
  });

  final Skill skill;
  final List<String> places;
  final bool selected;
  final SkillsCopy copy;
  final ValueChanged<bool> onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final used = places.isNotEmpty;
    final label = used
        ? copy.usedIn.fill({'skill': skill.name, 'places': places.join(', ')})
        : skill.name;
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: onHover,
        child: Pressable(
          semanticLabel: label,
          onTap: used ? onTap : null,
          focusRadius: Radii.s + 2,
          builder: (context, states) {
            final active = selected || states.contains(WidgetState.focused);
            final curve = SpringCurve(Springs.playful);
            return TweenAnimationBuilder<double>(
              tween: Tween(end: active ? 1 : 0),
              duration: context.reduceMotion ? Duration.zero : curve.duration,
              curve: curve,
              builder: (context, lift, child) => Transform.translate(
                offset: Offset(0, -2.5 * lift),
                child: child,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: active ? t.surfaceRaised : t.surface,
                  borderRadius: BorderRadius.circular(Radii.s + 2),
                  border: Border.all(color: active ? t.signalText : t.line),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        skill.name,
                        style: context.type.label.copyWith(
                          fontSize: 14,
                          color: t.text,
                        ),
                      ),
                    ),
                    // Marks skills that can show where they were used.
                    if (used) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: active
                              ? t.signal
                              : t.signalText.withValues(alpha: 0.55),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
