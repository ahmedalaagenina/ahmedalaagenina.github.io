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
                  duration: const Duration(milliseconds: 600),
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

        const SizedBox(height: 48),

        // Certifications
        const SectionTitle(title: 'Certifications', icon: Icons.verified_outlined),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GlassmorphicCard(
            padding: const EdgeInsets.all(24),
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(CVData.certifications.length, (index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      horizontalOffset: 30,
                      child: FadeInAnimation(
                        child: _CertificationItem(
                          cert: CVData.certifications[index],
                          index: index,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),

        const SizedBox(height: 48),

        // Languages
        const SectionTitle(title: 'Languages', icon: Icons.translate),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GlassmorphicCard(
            padding: const EdgeInsets.all(24),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: CVData.languages.map((lang) {
                return _LanguageChip(lang: lang);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Certification Item ──────────────────────────────────────────────

class _CertificationItem extends StatefulWidget {
  final String cert;
  final int index;

  const _CertificationItem({required this.cert, required this.index});

  @override
  State<_CertificationItem> createState() => _CertificationItemState();
}

class _CertificationItemState extends State<_CertificationItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: _isHovered
              ? LinearGradient(
                  colors: [
                    appTheme.colors.primary.withValues(alpha: 0.08),
                    const Color(0xFF8B5CF6).withValues(alpha: 0.04),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF30B8F6), Color(0xFF8B5CF6)],
              ).createShader(bounds),
              child: const Icon(
                Icons.military_tech,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.cert,
                style: appTheme.typography.bodyMedium.copyWith(
                  color: _isHovered
                      ? appTheme.colors.onSurface
                      : appTheme.colors.onSurface.withValues(alpha: 0.82),
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Language Chip ───────────────────────────────────────────────────

class _LanguageChip extends StatefulWidget {
  final LanguageRecord lang;

  const _LanguageChip({required this.lang});

  @override
  State<_LanguageChip> createState() => _LanguageChipState();
}

class _LanguageChipState extends State<_LanguageChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: _isHovered
              ? LinearGradient(
                  colors: [
                    appTheme.colors.primary.withValues(alpha: 0.2),
                    const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                  ],
                )
              : null,
          color: _isHovered
              ? null
              : appTheme.colors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isHovered
                ? appTheme.colors.primary.withValues(alpha: 0.5)
                : appTheme.colors.primary.withValues(alpha: 0.12),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: appTheme.colors.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF30B8F6), Color(0xFF8B5CF6)],
              ).createShader(bounds),
              child: const Icon(Icons.language, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(
              widget.lang.language,
              style: appTheme.typography.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: appTheme.colors.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF30B8F6), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.lang.level,
                style: appTheme.typography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Education Card ──────────────────────────────────────────────────

class _EducationCard extends StatelessWidget {
  final EducationRecord record;

  const _EducationCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return GlassmorphicCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF30B8F6), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 14),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.business, size: 14, color: appTheme.colors.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                record.institution,
                style: appTheme.typography.bodyMedium.copyWith(
                  color: appTheme.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  appTheme.colors.primary.withValues(alpha: 0.15),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              record.period,
              style: appTheme.typography.labelSmall.copyWith(
                color: appTheme.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
