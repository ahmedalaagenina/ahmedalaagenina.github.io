import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycv/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/cv_data.dart';
import 'glassmorphic_card.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _showPhoneDialog(BuildContext context, {required String action}) {
    final appTheme = context.appTheme;
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF30B8F6), Color(0xFF8B5CF6)],
          ).createShader(bounds),
          child: Text(
            'Choose Number',
            style: appTheme.typography.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PhoneOption(
              flag: '🇸🇦',
              country: 'Saudi Arabia',
              number: CVData.phoneKsa,
              onTap: () {
                Navigator.pop(ctx);
                if (action == 'call') {
                  _launchUrl('tel:${CVData.phoneKsa}');
                } else {
                  _launchUrl('https://wa.me/${CVData.phoneKsa.replaceAll('+', '')}');
                }
              },
            ),
            const SizedBox(height: 10),
            _PhoneOption(
              flag: '🇪🇬',
              country: 'Egypt',
              number: CVData.phoneEg,
              onTap: () {
                Navigator.pop(ctx);
                if (action == 'call') {
                  _launchUrl('tel:${CVData.phoneEg}');
                } else {
                  _launchUrl('https://wa.me/${CVData.phoneEg.replaceAll('+', '')}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 700),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            _PulsingAvatar(appTheme: appTheme),
            const SizedBox(height: 32),
            // Gradient name text
            _GradientName(appTheme: appTheme),
            const SizedBox(height: 10),
            // Animated title with typing feel
            Text(
              CVData.title,
              textAlign: TextAlign.center,
              style: appTheme.typography.titleLarge.copyWith(
                color: appTheme.colors.primary.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 16, color: appTheme.colors.onSurfaceVariant.withValues(alpha: 0.7)),
                const SizedBox(width: 4),
                Text(
                  CVData.location,
                  style: appTheme.typography.bodyMedium.copyWith(
                    color: appTheme.colors.onSurfaceVariant.withValues(alpha: 0.7),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // ─── Contact & Social Buttons ──────────────────
            _buildContactButtons(context, appTheme),
            const SizedBox(height: 32),
            // Summary in glassmorphic card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GlassmorphicCard(
                blurAmount: 10,
                padding: const EdgeInsets.all(24),
                enableHover: false,
                child: Column(
                  children: [
                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatBadge(value: '6+', label: 'Years', appTheme: appTheme),
                        Container(width: 1, height: 30, color: appTheme.colors.outlineVariant.withValues(alpha: 0.3)),
                        _StatBadge(value: '17+', label: 'Apps', appTheme: appTheme),
                        Container(width: 1, height: 30, color: appTheme.colors.outlineVariant.withValues(alpha: 0.3)),
                        _StatBadge(value: '5+', label: 'Companies', appTheme: appTheme),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: appTheme.colors.outlineVariant.withValues(alpha: 0.2)),
                    const SizedBox(height: 16),
                    Text(
                      CVData.summary,
                      textAlign: TextAlign.center,
                      style: appTheme.typography.bodyLarge.copyWith(
                        color: appTheme.colors.onSurface.withValues(alpha: 0.8),
                        height: 1.8,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButtons(BuildContext context, AppThemeExtension appTheme) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        _HeroContactChip(
          icon: Icons.email_outlined,
          label: 'Email',
          onTap: () => _launchUrl('mailto:${CVData.email}'),
        ),
        _HeroContactChip(
          icon: Icons.phone_outlined,
          label: 'Phone',
          onTap: () => _showPhoneDialog(context, action: 'call'),
        ),
        _HeroContactChip(
          icon: FontAwesomeIcons.linkedin,
          label: 'LinkedIn',
          onTap: () => _launchUrl(CVData.linkedinUrl),
        ),
        _HeroContactChip(
          icon: FontAwesomeIcons.github,
          label: 'GitHub',
          onTap: () => _launchUrl(CVData.githubUrl),
        ),
      ],
    );
  }
}

// ─── Stat Badge ──────────────────────────────────────────────────────

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  final AppThemeExtension appTheme;

  const _StatBadge({required this.value, required this.label, required this.appTheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [appTheme.colors.primary, const Color(0xFF8B5CF6)],
          ).createShader(bounds),
          child: Text(
            value,
            style: appTheme.typography.headlineMedium.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: appTheme.typography.labelSmall.copyWith(
            color: appTheme.colors.onSurfaceVariant,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// ─── Gradient Name ───────────────────────────────────────────────────

class _GradientName extends StatelessWidget {
  final AppThemeExtension appTheme;

  const _GradientName({required this.appTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: isDark
            ? [Colors.white, const Color(0xFF30B8F6), const Color(0xFF8B5CF6)]
            : [const Color(0xFF0F172A), const Color(0xFF0553B1), const Color(0xFF6366F1)],
      ).createShader(bounds),
      child: Text(
        CVData.name,
        textAlign: TextAlign.center,
        style: appTheme.typography.displaySmall.copyWith(
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: -1.5,
          height: 1.2,
        ),
      ),
    );
  }
}

// ─── Pulsing Avatar ──────────────────────────────────────────────────

class _PulsingAvatar extends StatefulWidget {
  final AppThemeExtension appTheme;

  const _PulsingAvatar({required this.appTheme});

  @override
  State<_PulsingAvatar> createState() => _PulsingAvatarState();
}

class _PulsingAvatarState extends State<_PulsingAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulse = sin(_pulseController.value * pi) * 0.3 + 0.7;

        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.appTheme.colors.primary.withValues(alpha: 0.25 * pulse),
                blurRadius: 40 * pulse,
                spreadRadius: 8 * pulse,
              ),
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.15 * pulse),
                blurRadius: 60 * pulse,
                spreadRadius: 15 * pulse,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  widget.appTheme.colors.primary,
                  const Color(0xFF8B5CF6),
                  const Color(0xFF6366F1),
                  widget.appTheme.colors.primary,
                ],
              ),
              border: Border.all(
                color: widget.appTheme.colors.background,
                width: 4,
              ),
            ),
            padding: const EdgeInsets.all(3),
            child: ClipOval(
              child: Image.network(
                'https://media.licdn.com/dms/image/v2/C4E03AQFobd0Szz6nyQ/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1647621734912?e=1775692800&v=beta&t=sO7y2OSOOKvodPfeFH1EoIInmnLoCAK63unGAhb9pX0',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: widget.appTheme.colors.surfaceVariant,
                    alignment: Alignment.center,
                    child: Text(
                      'AA',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: widget.appTheme.colors.primary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Contact Chip ────────────────────────────────────────────────────

class _HeroContactChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeroContactChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_HeroContactChip> createState() => _HeroContactChipState();
}

class _HeroContactChipState extends State<_HeroContactChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final isDark = context.isDarkMode;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
            borderRadius: BorderRadius.circular(12),
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
                      color: appTheme.colors.primary.withValues(alpha: isDark ? 0.15 : 0.1),
                      blurRadius: 12,
                    ),
                  ]
                : isDark ? [] : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: appTheme.colors.primary),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: appTheme.typography.labelMedium.copyWith(
                  color: _isHovered ? appTheme.colors.primary : appTheme.colors.onSurface,
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

/// Premium phone number option tile for the dialog.
class _PhoneOption extends StatefulWidget {
  final String flag;
  final String country;
  final String number;
  final VoidCallback onTap;

  const _PhoneOption({
    required this.flag,
    required this.country,
    required this.number,
    required this.onTap,
  });

  @override
  State<_PhoneOption> createState() => _PhoneOptionState();
}

class _PhoneOptionState extends State<_PhoneOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final isDark = context.isDarkMode;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: _isHovered
                ? LinearGradient(
                    colors: [
                      appTheme.colors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                      const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.08 : 0.04),
                    ],
                  )
                : null,
            color: _isHovered
                ? null
                : isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : appTheme.colors.primary.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? appTheme.colors.primary.withValues(alpha: 0.5)
                  : isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : appTheme.colors.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Text(widget.flag, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.country,
                      style: appTheme.typography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: appTheme.colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.number,
                      style: appTheme.typography.bodySmall.copyWith(
                        color: appTheme.colors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: _isHovered
                    ? appTheme.colors.primary
                    : appTheme.colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
