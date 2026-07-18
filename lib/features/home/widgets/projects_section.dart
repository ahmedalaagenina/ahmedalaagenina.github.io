import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/responsive.dart';
import '../../../data/cv_data.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/reveal.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/store_badge.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final visible = _showAll
        ? CV.projects
        : CV.projects.where((p) => p.featured).toList();

    final columns = context.pick(desktop: 3, tablet: 2, mobile: 1);

    return MaxWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Portfolio',
            title: 'Apps I\'ve Shipped',
            subtitle:
                '17+ production applications live on the App Store and '
                'Google Play — tap the badges to see them.',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 20.0;
              final cardWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (var i = 0; i < visible.length; i++)
                    SizedBox(
                      width: cardWidth,
                      child: Reveal(
                        delay: Duration(milliseconds: (i % columns) * 90),
                        child: _ProjectCard(project: visible[i]),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          Center(
            child: _ShowAllButton(
              expanded: _showAll,
              hiddenCount: CV.projects.length -
                  CV.projects.where((p) => p.featured).length,
              onTap: () => setState(() => _showAll = !_showAll),
            ),
          ),
          if (_showAll)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  'Some early-career apps may have been rotated off the '
                  'stores by their owners.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: t.textMuted),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectApp project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final theme = Theme.of(context).textTheme;

    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Monogram tile.
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: t.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    project.name.characters.first.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: AppTheme.displayFont,
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name, style: theme.titleLarge),
                    if (project.company.isNotEmpty)
                      Text(project.company, style: theme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            project.description,
            style: theme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (project.iosUrl != null)
                StoreBadge(kind: StoreKind.appStore, url: project.iosUrl!),
              if (project.androidUrl != null)
                StoreBadge(
                  kind: StoreKind.googlePlay,
                  url: project.androidUrl!,
                ),
              if (project.webUrl != null)
                StoreBadge(kind: StoreKind.web, url: project.webUrl!),
              if (project.adminUrl != null)
                StoreBadge(kind: StoreKind.admin, url: project.adminUrl!),
              if (project.iosUrl == null &&
                  project.androidUrl == null &&
                  project.webUrl == null &&
                  project.adminUrl == null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: t.glassBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.hourglassHalf,
                        size: 11,
                        color: t.textMuted,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Links coming soon',
                        style: TextStyle(fontSize: 12, color: t.textMuted),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShowAllButton extends StatefulWidget {
  final bool expanded;
  final int hiddenCount;
  final VoidCallback onTap;

  const _ShowAllButton({
    required this.expanded,
    required this.hiddenCount,
    required this.onTap,
  });

  @override
  State<_ShowAllButton> createState() => _ShowAllButtonState();
}

class _ShowAllButtonState extends State<_ShowAllButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          decoration: BoxDecoration(
            color: _hovered ? t.glassFill : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _hovered ? t.accentA.withValues(alpha: .6) : t.glassBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  widget.expanded
                      ? 'Show Featured Only'
                      : 'Show All ${widget.hiddenCount} More Apps',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: t.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: widget.expanded ? .5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: t.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
