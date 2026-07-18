import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/responsive.dart';
import '../../../data/cv_data.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/reveal.dart';
import '../../../widgets/section_header.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final theme = Theme.of(context).textTheme;
    final isDesktop = context.isDesktop;

    final educationCard = Reveal(
      child: GlassCard(
        hoverable: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.graduationCap,
                    size: 16, color: t.accentB),
                const SizedBox(width: 10),
                Text('Education', style: theme.titleLarge),
              ],
            ),
            const SizedBox(height: 18),
            for (final edu in CV.education)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(edu.degree, style: theme.titleSmall),
                    const SizedBox(height: 2),
                    Text(edu.institution, style: theme.bodyMedium),
                    Text(edu.period, style: theme.bodySmall),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.language, size: 16, color: t.accentB),
                const SizedBox(width: 10),
                Text('Languages', style: theme.titleLarge),
              ],
            ),
            const SizedBox(height: 14),
            for (final lang in CV.languages)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Text(lang.language, style: theme.titleSmall),
                    const SizedBox(width: 8),
                    Text('· ${lang.level}', style: theme.bodyMedium),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    final certsCard = Reveal(
      delay: const Duration(milliseconds: 120),
      child: GlassCard(
        hoverable: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.certificate,
                    size: 16, color: t.accentB),
                const SizedBox(width: 10),
                Text('Certifications', style: theme.titleLarge),
              ],
            ),
            const SizedBox(height: 18),
            for (final cert in CV.certifications)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
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
                    Expanded(child: Text(cert, style: theme.bodyMedium)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    return MaxWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Background',
            title: 'Education & Certifications',
          ),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: educationCard),
                const SizedBox(width: 20),
                Expanded(child: certsCard),
              ],
            )
          else ...[
            educationCard,
            const SizedBox(height: 20),
            certsCard,
          ],
        ],
      ),
    );
  }
}
