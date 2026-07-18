import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/platform_keys.dart';
import '../../../core/responsive.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/theme_toggle.dart';

class NavItem {
  final String label;
  final GlobalKey targetKey;

  const NavItem({required this.label, required this.targetKey});
}

/// Glass navigation bar. Becomes opaque-ish once scrolled.
class NavBar extends StatelessWidget {
  final List<NavItem> items;
  final bool scrolled;
  final String activeSection;
  final void Function(NavItem) onTapItem;
  final VoidCallback onOpenPalette;

  const NavBar({
    super.key,
    required this.items,
    required this.scrolled,
    required this.activeSection,
    required this.onTapItem,
    required this.onOpenPalette,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final isDesktop = context.isDesktop;

    return ClipRect(
      child: BackdropFilter(
        filter: scrolled
            ? ImageFilter.blur(sigmaX: 14, sigmaY: 14)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 64,
          decoration: BoxDecoration(
            color: scrolled
                ? t.background.withValues(alpha: .72)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: scrolled ? t.glassBorder : Colors.transparent,
              ),
            ),
          ),
          child: MaxWidth(
            child: Row(
              children: [
                // Logo.
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onTapItem(items.first),
                    child: GradientText(
                      '<AA />',
                      style: const TextStyle(
                        fontFamily: AppTheme.displayFont,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (isDesktop)
                  for (final item in items) _NavLink(
                    item: item,
                    active: item.label == activeSection,
                    onTap: () => onTapItem(item),
                  ),
                if (isDesktop) const SizedBox(width: 8),
                Tooltip(
                  message: 'Command palette ($paletteShortcutLabel)',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: onOpenPalette,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: t.glassFill,
                        border: Border.all(color: t.glassBorder),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.terminal,
                          size: 13,
                          color: t.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const ThemeToggle(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final NavItem item;
  final bool active;
  final VoidCallback onTap;

  const _NavLink({
    required this.item,
    required this.active,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final highlighted = _hovered || widget.active;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.item.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      widget.active ? FontWeight.w600 : FontWeight.w500,
                  color: highlighted ? t.textPrimary : t.textMuted,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.active ? 18 : 0,
                decoration: BoxDecoration(
                  gradient: t.accentGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
