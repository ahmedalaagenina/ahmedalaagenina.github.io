import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mycv/theme/theme.dart';

import '../data/cv_data.dart';
import 'glassmorphic_card.dart';
import 'section_title.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Education', icon: Icons.school_outlined),
        const SizedBox(height: 24),

        // Education cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AnimationLimiter(
            child: Column(
              children: List.generate(CVData.education.length, (index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 40.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _EducationCard(record: CVData.education[index]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Certifications
        const SectionTitle(title: 'Certifications', icon: Icons.verified_outlined),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GlassmorphicCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: CVData.certifications.map((cert) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.military_tech,
                        size: 18,
                        color: appTheme.colors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          cert,
                          style: appTheme.typography.bodyMedium.copyWith(
                            color: appTheme.colors.onSurface.withValues(alpha: 0.85),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Languages
        const SectionTitle(title: 'Languages', icon: Icons.translate),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GlassmorphicCard(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: CVData.languages.map((lang) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: appTheme.colors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: appTheme.colors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.language, size: 18, color: appTheme.colors.primary),
                      const SizedBox(width: 8),
                      Text(
                        lang.language,
                        style: appTheme.typography.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: appTheme.colors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${lang.level})',
                        style: appTheme.typography.labelMedium.copyWith(
                          color: appTheme.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _EducationCard extends StatelessWidget {
  final EducationRecord record;

  const _EducationCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, size: 22, color: appTheme.colors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  record.degree,
                  style: appTheme.typography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: appTheme.colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            record.institution,
            style: appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: appTheme.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              record.period,
              style: appTheme.typography.labelSmall.copyWith(
                color: appTheme.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (record.description != null) ...[
            const SizedBox(height: 12),
            Text(
              record.description!,
              style: appTheme.typography.bodySmall.copyWith(
                color: appTheme.colors.onSurface.withValues(alpha: 0.75),
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
