import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/launcher.dart';
import '../../../core/platform_keys.dart';
import '../../../core/responsive.dart';
import '../../../data/cv_data.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/particle_field.dart';
import '../../../widgets/typewriter_text.dart';

class HeroSection extends StatelessWidget {
  final bool particlesActive;
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  const HeroSection({
    super.key,
    required this.particlesActive,
    required this.onViewWork,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final theme = Theme.of(context).textTheme;
    final isMobile = context.isMobile;

    return SizedBox(
      height: context.screenHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient gradient glow blobs.
          Positioned(
            top: -120,
            right: -80,
            child: _GlowBlob(color: t.accentA, size: 420),
          ),
          Positioned(
            bottom: -140,
            left: -100,
            child: _GlowBlob(color: t.accentB, size: 380),
          ),
          ParticleField(active: particlesActive),
          MaxWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status pill.
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: t.glassFill,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: t.glassBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PulsingDot(color: t.success),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Senior Software Engineer @ IDaraNet',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.labelMedium
                              ?.copyWith(color: t.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  "Hi, I'm",
                  style: theme.headlineSmall?.copyWith(color: t.textMuted),
                ),
                const SizedBox(height: 6),
                GradientText(
                  CV.shortName,
                  style: context.pick(
                    desktop: theme.displayLarge?.copyWith(fontSize: 84),
                    tablet: theme.displayLarge,
                    mobile: theme.displayMedium,
                  ),
                ),
                const SizedBox(height: 10),
                TypewriterText(
                  phrases: CV.heroRoles,
                  style: context
                      .pick(desktop: theme.displaySmall,
                          mobile: theme.headlineSmall)
                      ?.copyWith(color: t.textPrimary),
                ),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Text(
                    'I build offline-first systems, secure payment flows, and '
                    'scalable multi-role platforms — 17+ production apps '
                    'across fintech, logistics, healthcare, education, and '
                    'government.',
                    style: theme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 36),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    _PrimaryButton(
                      label: 'View My Work',
                      onTap: onViewWork,
                    ),
                    _GhostButton(
                      label: 'Get In Touch',
                      onTap: onContact,
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                Row(
                  children: [
                    _SocialIcon(
                      icon: FontAwesomeIcons.github,
                      tooltip: 'GitHub',
                      onTap: () => Launcher.open(CV.githubUrl),
                    ),
                    _SocialIcon(
                      icon: FontAwesomeIcons.linkedinIn,
                      tooltip: 'LinkedIn',
                      onTap: () => Launcher.open(CV.linkedinUrl),
                    ),
                    _SocialIcon(
                      icon: FontAwesomeIcons.envelope,
                      tooltip: 'Email',
                      onTap: Launcher.email,
                    ),
                    _SocialIcon(
                      icon: FontAwesomeIcons.whatsapp,
                      tooltip: 'WhatsApp',
                      onTap: () => Launcher.whatsapp(context),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(width: 16),
                      Container(
                        width: 1,
                        height: 20,
                        color: t.glassBorder,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Press $paletteShortcutLabel to navigate',
                        style: theme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Scroll hint.
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(
              child: _ScrollHint(onTap: onViewWork),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: .16), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;

  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: .45, end: 1.0).animate(_controller),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: .6),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          decoration: BoxDecoration(
            gradient: t.accentGradient,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: t.accentA.withValues(alpha: _hovered ? .5 : .25),
                blurRadius: _hovered ? 28 : 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          transform:
              Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _GhostButton({required this.label, required this.onTap});

  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          decoration: BoxDecoration(
            color: _hovered ? t.glassFill : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _hovered ? t.accentA.withValues(alpha: .6) : t.glassBorder,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: t.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final FaIconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Tooltip(
        message: widget.tooltip,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 40,
              height: 40,
              transform:
                  Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovered
                    ? t.accentA.withValues(alpha: .18)
                    : t.glassFill,
                border: Border.all(
                  color: _hovered
                      ? t.accentA.withValues(alpha: .6)
                      : t.glassBorder,
                ),
              ),
              child: Center(
                child: FaIcon(
                  widget.icon,
                  size: 15,
                  color: _hovered ? t.textPrimary : t.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrollHint extends StatefulWidget {
  final VoidCallback onTap;

  const _ScrollHint({required this.onTap});

  @override
  State<_ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<_ScrollHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _controller.value * 6),
            child: child,
          ),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: t.textMuted,
            size: 28,
          ),
        ),
      ),
    );
  }
}
