import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mycv/theme/theme.dart';

import '../data/cv_data.dart';
import 'glassmorphic_card.dart';
import 'section_title.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _SkillCategory('Mobile Development', Icons.phone_android, CVData.skillsMobile),
      _SkillCategory('Architecture & Patterns', Icons.architecture, CVData.skillsArchitecture),
      _SkillCategory('Backend & Cloud', Icons.cloud_outlined, CVData.skillsBackend),
      _SkillCategory('Engineering Practices', Icons.engineering, CVData.skillsEngineering),
      _SkillCategory('Additional Skills', Icons.extension, CVData.skillsAdditional),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Skills', icon: Icons.code),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AnimationLimiter(
            child: Column(
              children: List.generate(categories.length, (index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _SkillCategoryCard(category: categories[index]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillCategory {
  final String name;
  final IconData icon;
  final List<String> skills;

  const _SkillCategory(this.name, this.icon, this.skills);
}

class _SkillCategoryCard extends StatelessWidget {
  final _SkillCategory category;

  const _SkillCategoryCard({required this.category});

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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appTheme.colors.primary.withValues(alpha: 0.15),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(category.icon, color: appTheme.colors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                category.name,
                style: appTheme.typography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: appTheme.colors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: category.skills.map((skill) {
              return _SkillChip(skill: skill);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatefulWidget {
  final String skill;

  const _SkillChip({required this.skill});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final isDark = context.isDarkMode;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: _isHovered
              ? LinearGradient(
                  colors: [
                    appTheme.colors.primary.withValues(alpha: isDark ? 0.2 : 0.12),
                    const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.12 : 0.06),
                  ],
                )
              : null,
          color: _isHovered
              ? null
              : isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : appTheme.colors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered
                ? appTheme.colors.primary.withValues(alpha: 0.5)
                : isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : appTheme.colors.outlineVariant.withValues(alpha: 0.6),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: appTheme.colors.primary.withValues(alpha: isDark ? 0.1 : 0.08),
                    blurRadius: 8,
                  ),
                ]
              : isDark ? [] : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Text(
          widget.skill,
          style: appTheme.typography.labelMedium.copyWith(
            color: _isHovered ? appTheme.colors.primary : appTheme.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
