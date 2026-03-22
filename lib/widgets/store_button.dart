import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycv/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/cv_data.dart';

/// A platform chip styled exactly like SkillChip — with hover effect and tap to launch.
class PlatformChip extends StatefulWidget {
  final PlatformType platform;
  final String? iosUrl;
  final String? androidUrl;
  final String? webUrl;

  const PlatformChip({
    super.key,
    required this.platform,
    this.iosUrl,
    this.androidUrl,
    this.webUrl,
  });

  @override
  State<PlatformChip> createState() => _PlatformChipState();
}

class _PlatformChipState extends State<PlatformChip> {
  bool _isHovered = false;

  IconData get _icon {
    switch (widget.platform) {
      case PlatformType.iOS:
        return FontAwesomeIcons.apple;
      case PlatformType.Android:
        return FontAwesomeIcons.android;
      case PlatformType.Web:
        return FontAwesomeIcons.globe;
    }
  }

  String get _label {
    switch (widget.platform) {
      case PlatformType.iOS:
        return 'iOS';
      case PlatformType.Android:
        return 'Android';
      case PlatformType.Web:
        return 'Web';
    }
  }

  String? get _url {
    switch (widget.platform) {
      case PlatformType.iOS:
        return widget.iosUrl;
      case PlatformType.Android:
        return widget.androidUrl;
      case PlatformType.Web:
        return widget.webUrl;
    }
  }

  Future<void> _launch() async {
    final url = _url;
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final hasLink = _url != null && _url!.isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: hasLink ? _launch : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: _isHovered
                ? appTheme.colors.primary.withValues(alpha: 0.15)
                : appTheme.colors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered
                  ? appTheme.colors.primary.withValues(alpha: 0.5)
                  : appTheme.colors.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _icon,
                size: 13,
                color: appTheme.colors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                _label,
                style: appTheme.typography.labelSmall.copyWith(
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

/// A row of platform chips for a project (kept for backward compatibility).
class StoreButtonsRow extends StatelessWidget {
  final List<PlatformType> platforms;
  final String? iosUrl;
  final String? androidUrl;
  final String? webUrl;

  const StoreButtonsRow({
    super.key,
    required this.platforms,
    this.iosUrl,
    this.androidUrl,
    this.webUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: platforms.map((platform) {
        return PlatformChip(
          platform: platform,
          iosUrl: iosUrl,
          androidUrl: androidUrl,
          webUrl: webUrl,
        );
      }).toList(),
    );
  }
}
