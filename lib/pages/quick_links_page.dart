import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mycv/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/cv_data.dart';
import '../widgets/max_width_container.dart';

class QuickLinksPage extends StatelessWidget {
  const QuickLinksPage({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Scaffold(
      backgroundColor: appTheme.colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: MaxWidthContainer(
            maxWidth: 600, // Mobile-optimized width constraints
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 600),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      const SizedBox(height: 48),
                      _buildAvatar(appTheme),
                      const SizedBox(height: 24),
                      Text(
                        CVData.name,
                        textAlign: TextAlign.center,
                        style: appTheme.typography.headlineMedium.copyWith(
                          fontWeight: FontWeight.w900,
                          color: appTheme.colors.onSurface,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          CVData.briefBio,
                          textAlign: TextAlign.center,
                          style: appTheme.typography.bodyLarge.copyWith(
                            color: appTheme.colors.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      _HoverLinkButton(
                        appTheme: appTheme,
                        icon: FontAwesomeIcons.linkedin,
                        label: 'Connect on LinkedIn',
                        onTap: () {
                          _launchUrl(
                            'https://www.linkedin.com/in/ahmedalaagenina',
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _HoverLinkButton(
                        appTheme: appTheme,
                        icon: FontAwesomeIcons.github,
                        label: 'Explore my Code',
                        onTap: () {
                          _launchUrl('https://github.com/AhmedAlaaGenina');
                        },
                      ),
                      const SizedBox(height: 16),
                      _HoverLinkButton(
                        appTheme: appTheme,
                        icon: FontAwesomeIcons.whatsapp,
                        label: 'Chat on WhatsApp',
                        onTap: () {
                          _launchUrl('https://wa.me/966508509042');
                        },
                      ),
                      const SizedBox(height: 16),
                      _HoverLinkButton(
                        appTheme: appTheme,
                        icon: FontAwesomeIcons.envelope,
                        label: 'Send an Email',
                        onTap: () =>
                            _launchUrl('mailto:ahmedalaagenina@gmail.com'),
                      ),
                      const SizedBox(height: 16),
                      _HoverLinkButton(
                        appTheme: appTheme,
                        icon: FontAwesomeIcons.filePdf,
                        label: 'View / Download CV',
                        onTap: () => _launchUrl(
                          'https://drive.google.com/file/d/1k2GvxDL2WYdCMx-EZevlhW_xU20EAI5v/view?usp=drive_link',
                        ),
                      ),
                      const SizedBox(height: 48),
                      Divider(color: appTheme.colors.outlineVariant),
                      const SizedBox(height: 48),
                      _HoverLinkButton(
                        appTheme: appTheme,
                        icon: Icons.web,
                        label: '🌐 View Full Portfolio',
                        onTap: () => context.go('/'),
                        isPrimary: true,
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(AppThemeExtension appTheme) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: appTheme.colors.primary, width: 4),
        boxShadow: [
          BoxShadow(
            color: appTheme.colors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
        image: const DecorationImage(
          image: NetworkImage(
            'https://media.licdn.com/dms/image/v2/C4E03AQFobd0Szz6nyQ/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1647621734912?e=1775692800&v=beta&t=sO7y2OSOOKvodPfeFH1EoIInmnLoCAK63unGAhb9pX0',
          ),
          // Fallback image handling is usually required for Network/Asset image issues
          // But since the asset is locally stored, we will use it natively.
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _HoverLinkButton extends StatefulWidget {
  final AppThemeExtension appTheme;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _HoverLinkButton({
    required this.appTheme,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  State<_HoverLinkButton> createState() => _HoverLinkButtonState();
}

class _HoverLinkButtonState extends State<_HoverLinkButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scale = isHovered ? 1.02 : 1.0;

    final bg = widget.isPrimary
        ? widget.appTheme.colors.primary
        : (isHovered
              ? widget.appTheme.colors.primary.withValues(alpha: 0.05)
              : widget.appTheme.colors.surface);

    final fg = widget.isPrimary
        ? widget.appTheme.colors.onPrimary
        : widget.appTheme.colors.onSurface;

    final iconFg = widget.isPrimary
        ? widget.appTheme.colors.onPrimary
        : widget.appTheme.colors.primary;

    final border = widget.isPrimary
        ? null
        : Border.all(
            color: isHovered
                ? widget.appTheme.colors.primary
                : widget.appTheme.colors.outlineVariant,
            width: 1,
          );

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(scale, scale, 1.0),
        transformAlignment: Alignment.center,
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(widget.isPrimary ? 30 : 16),
          elevation: isHovered
              ? (widget.isPrimary ? 8 : 4)
              : (widget.isPrimary ? 4 : 2),
          shadowColor: widget.isPrimary
              ? widget.appTheme.colors.primary.withValues(alpha: 0.4)
              : widget.appTheme.colors.scrim.withValues(alpha: 0.1),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(widget.isPrimary ? 30 : 16),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: widget.isPrimary ? 18 : 20,
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.isPrimary ? 30 : 16),
                border: border,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: iconFg,
                    size: widget.isPrimary ? 22 : 24,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.label,
                    style: widget.appTheme.typography.titleMedium.copyWith(
                      color: fg,
                      fontWeight: widget.isPrimary
                          ? FontWeight.w800
                          : FontWeight.w600,
                      letterSpacing: widget.isPrimary ? 0.5 : 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
