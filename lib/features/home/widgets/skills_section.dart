import 'package:flutter/material.dart';

import '../../../core/responsive.dart';
import '../../../data/cv_data.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/reveal.dart';
import '../../../widgets/section_header.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = context.pick(desktop: 2, mobile: 1);

    return MaxWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Toolbox',
            title: 'Technical Skills',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 20.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (var i = 0; i < CV.skills.length; i++)
                    SizedBox(
                      width: width,
                      child: Reveal(
                        delay: Duration(milliseconds: (i % columns) * 90),
                        child: _SkillCard(category: CV.skills[i]),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final SkillCategory category;

  const _SkillCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: t.accentGradient,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                category.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in category.skills) _SkillChip(label: skill),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatefulWidget {
  final String label;

  const _SkillChip({required this.label});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: _hovered ? t.accentA.withValues(alpha: .16) : t.glassFill,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: _hovered ? t.accentA.withValues(alpha: .55) : t.glassBorder,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _hovered ? t.textPrimary : t.textMuted,
          ),
        ),
      ),
    );
  }
}
