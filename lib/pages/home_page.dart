import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mycv/theme/theme.dart';

import '../widgets/animated_background.dart';
import '../widgets/education_section.dart';
import '../widgets/experience_timeline.dart';
import '../widgets/hero_section.dart';
import '../widgets/max_width_container.dart';
import '../widgets/skills_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Scaffold(
      backgroundColor: appTheme.colors.background,
      body: AnimatedBackground(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
          child: MaxWidthContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Top Actions Row ──────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _ActionChip(
                          icon: Icons.link,
                          label: 'Quick Links',
                          onTap: () => context.go('/links'),
                          appTheme: appTheme,
                        ),
                        const SizedBox(width: 8),
                        BlocBuilder<ThemeBloc, ThemeState>(
                          buildWhen: (previous, current) =>
                              previous.themeMode != current.themeMode,
                          builder: (context, state) {
                            return _ActionChip(
                              icon: state.themeMode == ThemeMode.dark
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              label: state.themeMode == ThemeMode.dark
                                  ? 'Light'
                                  : 'Dark',
                              onTap: () {
                                final newMode =
                                    state.themeMode == ThemeMode.light
                                        ? ThemeMode.dark
                                        : ThemeMode.light;
                                context.read<ThemeBloc>().add(
                                  ThemeModeChanged(newMode),
                                );
                              },
                              appTheme: appTheme,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const HeroSection(),
                  const SizedBox(height: 80),
                  const ExperienceTimeline(),
                  const SizedBox(height: 80),
                  const SkillsSection(),
                  const SizedBox(height: 80),
                  const EducationSection(),
                  const SizedBox(height: 80),
                  // Premium footer
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  appTheme.colors.primary.withValues(alpha: 0.0),
                                  appTheme.colors.primary,
                                  appTheme.colors.primary.withValues(alpha: 0.0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Built with 💙 using Flutter by Ahmed AlaaEldin © ${DateTime.now().year}',
                            textAlign: TextAlign.center,
                            style: appTheme.typography.bodySmall.copyWith(
                              color: appTheme.colors.onSurfaceVariant.withValues(alpha: 0.6),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }
}

/// Premium styled action chip for the top bar.
class _ActionChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final AppThemeExtension appTheme;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.appTheme,
  });

  @override
  State<_ActionChip> createState() => _ActionChipState();
}

class _ActionChipState extends State<_ActionChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.appTheme.colors.primary.withValues(alpha: 0.12)
                : isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : widget.appTheme.colors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered
                  ? widget.appTheme.colors.primary.withValues(alpha: 0.4)
                  : isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : widget.appTheme.colors.outlineVariant.withValues(alpha: 0.6),
            ),
            boxShadow: isDark ? [] : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: widget.appTheme.colors.primary),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: widget.appTheme.typography.labelMedium.copyWith(
                  color: widget.appTheme.colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
