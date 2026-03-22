import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mycv/theme/theme.dart';

import '../data/cv_data.dart';
import 'glassmorphic_card.dart';
import 'section_title.dart';
import 'store_button.dart';

class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Experience', icon: Icons.work_outline),
        const SizedBox(height: 24),
        AnimationLimiter(
          child: Column(
            children: List.generate(CVData.experience.length, (index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 700),
                child: SlideAnimation(
                  verticalOffset: 60.0,
                  child: FadeInAnimation(
                    child: _ExperienceCard(
                      record: CVData.experience[index],
                      isLast: index == CVData.experience.length - 1,
                      index: index,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final ExperienceRecord record;
  final bool isLast;
  final int index;

  const _ExperienceCard({
    required this.record,
    required this.isLast,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          // Gradient timeline line
          if (!isLast)
            Positioned(
              top: 24,
              bottom: 0,
              left: 8,
              width: 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      appTheme.colors.primary,
                      const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                      appTheme.colors.primary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pulsing timeline dot
              _PulsingDot(appTheme: appTheme),
              const SizedBox(width: 20),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 36.0),
                  child: GlassmorphicCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderRow(appTheme),
                        const SizedBox(height: 8),
                        // Role with gradient accent
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              appTheme.colors.primary,
                              const Color(0xFF8B5CF6),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            record.role,
                            style: appTheme.typography.titleSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Descriptions
                        ...record.descriptions.map(
                          (desc) => Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 7),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        appTheme.colors.primary,
                                        const Color(0xFF8B5CF6),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    desc,
                                    style: appTheme.typography.bodyMedium.copyWith(
                                      color: appTheme.colors.onSurface.withValues(alpha: 0.82),
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Projects section
                        if (record.projects.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  appTheme.colors.primary.withValues(alpha: 0.0),
                                  appTheme.colors.primary.withValues(alpha: 0.3),
                                  const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                                  appTheme.colors.primary.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      appTheme.colors.primary.withValues(alpha: 0.15),
                                      const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(Icons.apps, size: 14, color: appTheme.colors.primary),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Projects',
                                style: appTheme.typography.labelLarge.copyWith(
                                  color: appTheme.colors.primary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: record.projects
                                .map((project) => _ProjectSubCard(project: project))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(AppThemeExtension appTheme) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        Text(
          record.company,
          style: appTheme.typography.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: appTheme.colors.onSurface,
          ),
        ),
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_outlined, size: 14, color: appTheme.colors.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              record.location,
              style: appTheme.typography.labelSmall.copyWith(
                color: appTheme.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Pulsing Timeline Dot ────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  final AppThemeExtension appTheme;

  const _PulsingDot({required this.appTheme});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulse = sin(_controller.value * pi) * 0.5 + 0.5;

        return Container(
          margin: const EdgeInsets.only(top: 8),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                widget.appTheme.colors.primary,
                const Color(0xFF8B5CF6),
              ],
            ),
            border: Border.all(
              color: widget.appTheme.colors.background,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.appTheme.colors.primary.withValues(alpha: 0.4 * pulse),
                blurRadius: 12 * pulse,
                spreadRadius: 2 * pulse,
              ),
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.2 * pulse),
                blurRadius: 20 * pulse,
                spreadRadius: 4 * pulse,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Project Sub Card with 3D Tilt ───────────────────────────────────

class _ProjectSubCard extends StatefulWidget {
  final ProjectApp project;

  const _ProjectSubCard({required this.project});

  @override
  State<_ProjectSubCard> createState() => _ProjectSubCardState();
}

class _ProjectSubCardState extends State<_ProjectSubCard> {
  bool _isHovered = false;
  double _rotateX = 0;
  double _rotateY = 0;

  void _onHover(PointerEvent event, BoxConstraints constraints) {
    final dx = (event.localPosition.dx / constraints.maxWidth - 0.5) * 2;
    final dy = (event.localPosition.dy / constraints.maxHeight - 0.5) * 2;
    setState(() {
      _rotateY = dx * 0.03;
      _rotateX = -dy * 0.03;
    });
  }

  Matrix4 _buildTransform() {
    final s = _isHovered ? 1.03 : 1.0;
    final m = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(_rotateX)
      ..rotateY(_rotateY);
    return m..multiply(Matrix4.diagonal3Values(s, s, s));
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final isDark = context.isDarkMode;

    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() {
            _isHovered = false;
            _rotateX = 0;
            _rotateY = 0;
          }),
          onHover: (e) => _onHover(e, constraints),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: _buildTransform(),
            transformAlignment: Alignment.center,
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: _isHovered
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        appTheme.colors.primary.withValues(alpha: 0.08),
                        const Color(0xFF8B5CF6).withValues(alpha: 0.04),
                      ],
                    )
                  : null,
              color: _isHovered
                  ? null
                  : isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : appTheme.colors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered
                    ? appTheme.colors.primary.withValues(alpha: 0.5)
                    : isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : appTheme.colors.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: appTheme.colors.primary.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                        blurRadius: 30,
                        offset: const Offset(5, 5),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [appTheme.colors.primary, const Color(0xFF8B5CF6)],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.project.name,
                        style: appTheme.typography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: appTheme.colors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.project.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.project.description!,
                    style: appTheme.typography.bodySmall.copyWith(
                      color: appTheme.colors.onSurface.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.project.platforms.map((platform) {
                    return PlatformChip(
                      platform: platform,
                      iosUrl: widget.project.iosUrl,
                      androidUrl: widget.project.androidUrl,
                      webUrl: widget.project.webUrl,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
