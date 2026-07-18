import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/launcher.dart';
import '../theme/app_theme.dart';

enum StoreKind { appStore, googlePlay, web, admin }

/// Small pill button linking to an app's store page or website.
class StoreBadge extends StatefulWidget {
  final StoreKind kind;
  final String url;

  const StoreBadge({super.key, required this.kind, required this.url});

  @override
  State<StoreBadge> createState() => _StoreBadgeState();
}

class _StoreBadgeState extends State<StoreBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final (icon, label) = switch (widget.kind) {
      StoreKind.appStore => (FontAwesomeIcons.apple, 'App Store'),
      StoreKind.googlePlay => (FontAwesomeIcons.googlePlay, 'Google Play'),
      StoreKind.web => (FontAwesomeIcons.globe, 'Web'),
      StoreKind.admin => (FontAwesomeIcons.userGear, 'Admin'),
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Launcher.open(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: _hovered ? t.accentA.withValues(alpha: .16) : t.glassFill,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _hovered ? t.accentA.withValues(alpha: .6) : t.glassBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                size: 12,
                color: _hovered ? t.textPrimary : t.textMuted,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _hovered ? t.textPrimary : t.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
