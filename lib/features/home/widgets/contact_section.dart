import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/launcher.dart';
import '../../../core/responsive.dart';
import '../../../data/cv_data.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/reveal.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final theme = Theme.of(context).textTheme;

    return MaxWidth(
      child: Reveal(
        child: GlassCard(
          hoverable: false,
          padding: EdgeInsets.symmetric(
            vertical: context.pick(desktop: 64.0, mobile: 40.0),
            horizontal: context.pick(desktop: 48.0, mobile: 24.0),
          ),
          child: Column(
            children: [
              GradientText(
                "Let's Build Something Great",
                textAlign: TextAlign.center,
                style: context.pick(
                  desktop: theme.displaySmall,
                  mobile: theme.headlineMedium,
                ),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  'Open to senior mobile engineering roles, technical '
                  'leadership, and interesting Flutter projects. '
                  'Reach out through any channel — I usually reply fast.',
                  style: theme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                alignment: WrapAlignment.center,
                children: [
                  _ContactButton(
                    icon: FontAwesomeIcons.envelope,
                    label: 'Email Me',
                    primary: true,
                    onTap: Launcher.email,
                  ),
                  _ContactButton(
                    icon: FontAwesomeIcons.whatsapp,
                    label: 'WhatsApp',
                    onTap: () => Launcher.whatsapp(context),
                  ),
                  _ContactButton(
                    icon: FontAwesomeIcons.phone,
                    label: 'Call',
                    onTap: () => Launcher.call(context),
                  ),
                  _ContactButton(
                    icon: FontAwesomeIcons.linkedinIn,
                    label: 'LinkedIn',
                    onTap: () => Launcher.open(CV.linkedinUrl),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                CV.email,
                style: theme.bodyMedium?.copyWith(color: t.accentB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactButton extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final bool primary;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    this.primary = false,
    required this.onTap,
  });

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          decoration: BoxDecoration(
            gradient: widget.primary ? t.accentGradient : null,
            color: widget.primary
                ? null
                : (_hovered ? t.glassFill : Colors.transparent),
            borderRadius: BorderRadius.circular(100),
            border: widget.primary
                ? null
                : Border.all(
                    color: _hovered
                        ? t.accentA.withValues(alpha: .6)
                        : t.glassBorder,
                  ),
            boxShadow: widget.primary && _hovered
                ? [
                    BoxShadow(
                      color: t.accentA.withValues(alpha: .4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon,
                size: 14,
                color: widget.primary ? Colors.white : t.textPrimary,
              ),
              const SizedBox(width: 9),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.primary ? Colors.white : t.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
