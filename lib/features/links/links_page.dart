import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/launcher.dart';
import '../../data/cv_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_text.dart';
import '../../widgets/reveal.dart';
import '../../widgets/theme_toggle.dart';

/// Linktree-style page at /links — share one URL, get every channel.
class LinksPage extends StatelessWidget {
  const LinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final theme = Theme.of(context).textTheme;

    final entries =
        <
          ({
            FaIconData icon,
            String label,
            String sub,
            VoidCallback Function(BuildContext) action,
          })
        >[
          (
            icon: FontAwesomeIcons.userAstronaut,
            label: 'Portfolio',
            sub: 'Full CV, experience & projects',
            action: (ctx) =>
                () => ctx.go('/'),
          ),
          for (final link in CV.quickLinks)
            (
              icon: switch (link.label) {
                'LinkedIn' => FontAwesomeIcons.linkedinIn,
                'GitHub' => FontAwesomeIcons.github,
                _ => FontAwesomeIcons.cube,
              },
              label: link.label,
              sub: link.subtitle,
              action: (_) =>
                  () => Launcher.open(link.url),
            ),
          (
            icon: FontAwesomeIcons.envelope,
            label: 'Email',
            sub: CV.email,
            action: (_) => Launcher.email,
          ),
          (
            icon: FontAwesomeIcons.whatsapp,
            label: 'WhatsApp',
            sub: 'Chat directly',
            action: (ctx) =>
                () => Launcher.whatsapp(ctx),
          ),
          (
            icon: FontAwesomeIcons.phone,
            label: 'Call',
            sub: 'KSA or Egypt number',
            action: (ctx) =>
                () => Launcher.call(ctx),
          ),
          (
            icon: FontAwesomeIcons.fileArrowDown,
            label: 'Download CV',
            sub: 'PDF résumé',
            action: (_) =>
                () => Launcher.open(CV.cvUrl),
          ),
        ];

    return Scaffold(
      backgroundColor: t.background,
      body: Stack(
        children: [
          Positioned(top: 16, right: 16, child: const ThemeToggle()),
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 64,
                  horizontal: 20,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Monogram avatar.
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: t.accentGradient,
                          boxShadow: [
                            BoxShadow(
                              color: t.accentA.withValues(alpha: .4),
                              blurRadius: 32,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            CV.initials,
                            style: const TextStyle(
                              fontFamily: AppTheme.displayFont,
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GradientText(CV.shortName, style: theme.headlineMedium),
                      const SizedBox(height: 6),
                      Text(
                        '${CV.title} · ${CV.subtitle}',
                        style: theme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 36),
                      for (var i = 0; i < entries.length; i++)
                        Reveal(
                          delay: Duration(milliseconds: i * 60),
                          child: _LinkTile(
                            icon: entries[i].icon,
                            label: entries[i].label,
                            subtitle: entries[i].sub,
                            onTap: entries[i].action(context),
                          ),
                        ),
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

class _LinkTile extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _LinkTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_LinkTile> createState() => _LinkTileState();
}

class _LinkTileState extends State<_LinkTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
            decoration: BoxDecoration(
              color: _hovered ? t.accentA.withValues(alpha: .12) : t.glassFill,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _hovered
                    ? t.accentA.withValues(alpha: .55)
                    : t.glassBorder,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: t.accentA.withValues(alpha: .12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : const [],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: t.surface,
                    border: Border.all(color: t.glassBorder),
                  ),
                  child: Center(
                    child: FaIcon(
                      widget.icon,
                      size: 16,
                      color: _hovered ? t.accentB : t.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        widget.subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: t.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
