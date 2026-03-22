import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mycv/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/cv_data.dart';
import '../widgets/animated_background.dart';

class QuickLinksPage extends StatelessWidget {
  const QuickLinksPage({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
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
            _PhoneOptionTile(
              flag: '🇸🇦',
              country: 'Saudi Arabia',
              number: CVData.phoneKsa,
              onTap: () {
                Navigator.pop(ctx);
                if (action == 'whatsapp') {
                  _launchUrl('https://wa.me/${CVData.phoneKsa.replaceAll('+', '')}');
                } else {
                  _launchUrl('tel:${CVData.phoneKsa}');
                }
              },
            ),
            const SizedBox(height: 10),
            _PhoneOptionTile(
              flag: '🇪🇬',
              country: 'Egypt',
              number: CVData.phoneEg,
              onTap: () {
                Navigator.pop(ctx);
                if (action == 'whatsapp') {
                  _launchUrl('https://wa.me/${CVData.phoneEg.replaceAll('+', '')}');
                } else {
                  _launchUrl('tel:${CVData.phoneEg}');
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

    return Scaffold(
      backgroundColor: appTheme.colors.background,
      body: AnimatedBackground(
        child: SafeArea(
          child: Center(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: AnimationLimiter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 600),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          // ─── Theme toggle top-right ────
                          Align(
                            alignment: Alignment.topRight,
                            child: BlocBuilder<ThemeBloc, ThemeState>(
                              buildWhen: (p, c) => p.themeMode != c.themeMode,
                              builder: (context, state) {
                                return _GlassIconButton(
                                  icon: state.themeMode == ThemeMode.dark
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                  onTap: () {
                                    final newMode =
                                        state.themeMode == ThemeMode.light
                                            ? ThemeMode.dark
                                            : ThemeMode.light;
                                    context.read<ThemeBloc>().add(
                                      ThemeModeChanged(newMode),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ─── Pulsing Avatar ────────────
                          _QuickLinksAvatar(appTheme: appTheme),
                          const SizedBox(height: 24),

                          // ─── Gradient Name ─────────────
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: context.isDarkMode
                                  ? [Colors.white, const Color(0xFF30B8F6), const Color(0xFF8B5CF6)]
                                  : [const Color(0xFF0F172A), const Color(0xFF0553B1), const Color(0xFF6366F1)],
                            ).createShader(bounds),
                            child: Text(
                              CVData.name,
                              textAlign: TextAlign.center,
                              style: appTheme.typography.headlineMedium.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            CVData.title,
                            textAlign: TextAlign.center,
                            style: appTheme.typography.titleMedium.copyWith(
                              color: appTheme.colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            CVData.briefBio,
                            textAlign: TextAlign.center,
                            style: appTheme.typography.bodyMedium.copyWith(
                              color: appTheme.colors.onSurfaceVariant.withValues(alpha: 0.8),
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 40),

                          // ─── Links ─────────────────────
                          _PremiumLinkCard(
                            icon: FontAwesomeIcons.linkedin,
                            label: 'Connect on LinkedIn',
                            gradientColors: const [Color(0xFF0077B5), Color(0xFF00A0DC)],
                            onTap: () => _launchUrl(CVData.linkedinUrl),
                          ),
                          const SizedBox(height: 14),
                          _PremiumLinkCard(
                            icon: FontAwesomeIcons.github,
                            label: 'Explore my Code',
                            gradientColors: const [Color(0xFF333333), Color(0xFF6E5494)],
                            onTap: () => _launchUrl(CVData.githubUrl),
                          ),
                          const SizedBox(height: 14),
                          _PremiumLinkCard(
                            icon: FontAwesomeIcons.whatsapp,
                            label: 'Chat on WhatsApp',
                            gradientColors: const [Color(0xFF25D366), Color(0xFF128C7E)],
                            onTap: () => _showPhoneDialog(context, action: 'whatsapp'),
                          ),
                          const SizedBox(height: 14),
                          _PremiumLinkCard(
                            icon: FontAwesomeIcons.envelope,
                            label: 'Send an Email',
                            gradientColors: const [Color(0xFFEA4335), Color(0xFFFBBC04)],
                            onTap: () => _launchUrl('mailto:${CVData.email}'),
                          ),
                          const SizedBox(height: 14),
                          _PremiumLinkCard(
                            icon: FontAwesomeIcons.filePdf,
                            label: 'View / Download CV',
                            gradientColors: const [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                            onTap: () => _launchUrl(
                              'https://drive.google.com/file/d/1k2GvxDL2WYdCMx-EZevlhW_xU20EAI5v/view?usp=drive_link',
                            ),
                          ),

                          const SizedBox(height: 40),

                          // ─── Gradient divider ──────────
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  appTheme.colors.primary.withValues(alpha: 0.0),
                                  appTheme.colors.primary.withValues(alpha: 0.5),
                                  const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                                  appTheme.colors.primary.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ─── Full Portfolio Button ─────
                          _FullPortfolioButton(onTap: () => context.go('/')),

                          const SizedBox(height: 48),

                          Text(
                            'Built with 💙 using Flutter',
                            style: appTheme.typography.bodySmall.copyWith(
                              color: appTheme.colors.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Glass Icon Button ───────────────────────────────────────────────

class _GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  State<_GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<_GlassIconButton> {
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: _isHovered ? 0.12 : 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: _isHovered ? 0.2 : 0.08),
                ),
              ),
              child: Icon(
                widget.icon,
                size: 20,
                color: appTheme.colors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Quick Links Avatar ──────────────────────────────────────────────

class _QuickLinksAvatar extends StatefulWidget {
  final AppThemeExtension appTheme;

  const _QuickLinksAvatar({required this.appTheme});

  @override
  State<_QuickLinksAvatar> createState() => _QuickLinksAvatarState();
}

class _QuickLinksAvatarState extends State<_QuickLinksAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
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
        final pulse = sin(_controller.value * pi) * 0.4 + 0.6;

        return Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.appTheme.colors.primary.withValues(alpha: 0.3 * pulse),
                blurRadius: 35 * pulse,
                spreadRadius: 8 * pulse,
              ),
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.15 * pulse),
                blurRadius: 50 * pulse,
                spreadRadius: 12 * pulse,
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
              border: Border.all(color: widget.appTheme.colors.background, width: 3),
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
                        fontSize: 40,
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

// ─── Premium Link Card ───────────────────────────────────────────────

class _PremiumLinkCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _PremiumLinkCard({
    required this.icon,
    required this.label,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<_PremiumLinkCard> createState() => _PremiumLinkCardState();
}

class _PremiumLinkCardState extends State<_PremiumLinkCard> {
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
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.diagonal3Values(
            _isHovered ? 1.03 : 1.0,
            _isHovered ? 1.03 : 1.0,
            1.0,
          ),
          transformAlignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isHovered
                        ? [
                            widget.gradientColors[0].withValues(alpha: isDark ? 0.25 : 0.15),
                            widget.gradientColors[1].withValues(alpha: isDark ? 0.15 : 0.08),
                          ]
                        : [
                            (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                            (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _isHovered
                        ? widget.gradientColors[0].withValues(alpha: 0.5)
                        : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                    width: _isHovered ? 1.5 : 1,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: widget.gradientColors[0].withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    // Gradient icon container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isHovered
                              ? widget.gradientColors
                              : [
                                  widget.gradientColors[0].withValues(alpha: 0.2),
                                  widget.gradientColors[1].withValues(alpha: 0.2),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: widget.gradientColors[0].withValues(alpha: 0.3),
                                  blurRadius: 10,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        widget.icon,
                        color: _isHovered ? Colors.white : widget.gradientColors[0],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        widget.label,
                        style: appTheme.typography.titleSmall.copyWith(
                          color: _isHovered ? appTheme.colors.onSurface : appTheme.colors.onSurface.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.translationValues(
                        _isHovered ? 4 : 0,
                        0,
                        0,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: _isHovered
                            ? widget.gradientColors[0]
                            : appTheme.colors.onSurfaceVariant.withValues(alpha: 0.5),
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

// ─── Full Portfolio Button ───────────────────────────────────────────

class _FullPortfolioButton extends StatefulWidget {
  final VoidCallback onTap;

  const _FullPortfolioButton({required this.onTap});

  @override
  State<_FullPortfolioButton> createState() => _FullPortfolioButtonState();
}

class _FullPortfolioButtonState extends State<_FullPortfolioButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.diagonal3Values(
            _isHovered ? 1.05 : 1.0,
            _isHovered ? 1.05 : 1.0,
            1.0,
          ),
          transformAlignment: Alignment.center,
          child: AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + 3 * _shimmerController.value, 0),
                    end: Alignment(1 + 3 * _shimmerController.value, 0),
                    colors: const [
                      Color(0xFF30B8F6),
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                      Color(0xFF6366F1),
                      Color(0xFF30B8F6),
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF30B8F6).withValues(alpha: _isHovered ? 0.4 : 0.2),
                      blurRadius: _isHovered ? 25 : 15,
                      spreadRadius: _isHovered ? 2 : 0,
                    ),
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: _isHovered ? 0.3 : 0.1),
                      blurRadius: _isHovered ? 30 : 20,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.web, size: 22, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      'View Full Portfolio',
                      style: appTheme.typography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Premium phone option tile for the country selection dialog.
class _PhoneOptionTile extends StatefulWidget {
  final String flag;
  final String country;
  final String number;
  final VoidCallback onTap;

  const _PhoneOptionTile({
    required this.flag,
    required this.country,
    required this.number,
    required this.onTap,
  });

  @override
  State<_PhoneOptionTile> createState() => _PhoneOptionTileState();
}

class _PhoneOptionTileState extends State<_PhoneOptionTile> {
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
