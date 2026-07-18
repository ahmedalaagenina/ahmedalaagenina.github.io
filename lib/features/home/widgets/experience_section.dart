import 'package:flutter/material.dart';

import '../../../core/responsive.dart';
import '../../../data/cv_data.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/reveal.dart';
import '../../../widgets/section_header.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MaxWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Career',
            title: 'Professional Experience',
            subtitle:
                '6+ years shipping production mobile software — from courier '
                'fleets moving 10K+ daily activities to government platforms.',
          ),
          for (var i = 0; i < CV.experience.length; i++)
            _TimelineEntry(
              record: CV.experience[i],
              isLast: i == CV.experience.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final ExperienceRecord record;
  final bool isLast;

  const _TimelineEntry({required this.record, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final isMobile = context.isMobile;

    final line = Column(
      children: [
        // Node dot.
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: record.isCurrent ? t.accentGradient : null,
            color: record.isCurrent ? null : t.surface,
            border: record.isCurrent
                ? null
                : Border.all(color: t.accentA.withValues(alpha: .5), width: 2),
            boxShadow: record.isCurrent
                ? [
                    BoxShadow(
                      color: t.accentA.withValues(alpha: .5),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    t.accentA.withValues(alpha: .4),
                    t.accentA.withValues(alpha: .08),
                  ],
                ),
              ),
            ),
          ),
      ],
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isMobile) ...[
            Padding(padding: const EdgeInsets.only(top: 30), child: line),
            const SizedBox(width: 28),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Reveal(
                child: GlassCard(
                  padding: EdgeInsets.all(isMobile ? 20 : 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            record.company,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          if (record.isCurrent) _Chip(
                            label: 'CURRENT',
                            color: t.success,
                          ),
                          if (record.isPartTime) _Chip(
                            label: 'PART-TIME',
                            color: t.accentB,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        record.role,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: t.accentB),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${record.period}  ·  ${record.location}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      for (final project in record.projects) ...[
                        const SizedBox(height: 18),
                        Text(
                          project.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: t.textPrimary),
                        ),
                        const SizedBox(height: 8),
                        for (final bullet in project.bullets)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 7),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 9),
                                  child: Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: t.accentB.withValues(alpha: .8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    bullet,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ],
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

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: .45)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: color,
        ),
      ),
    );
  }
}
