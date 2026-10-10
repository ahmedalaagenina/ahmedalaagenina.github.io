import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/platform_keys.dart';
import '../../../core/responsive.dart';
import '../../../data/portfolio_data.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/pressable.dart';
import '../../../widgets/theme_toggle.dart';
import 'logo_mark.dart';
import 'section_id.dart';

/// Top navigation. Transparent over the hero, solid once the page scrolls.
///
/// No BackdropFilter blur: on Flutter web a blur re-samples everything
/// behind it every frame, and here that would include the animated hero
/// shader. A near-opaque solid color reads the same and costs nothing.
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.logoKey,
    required this.copy,
    required this.paletteCopy,
    required this.logo,
    required this.logoVisible,
    required this.scrolled,
    required this.active,
    required this.onSelect,
    required this.onLogoTap,
    required this.onOpenPalette,
    required this.onOpenMenu,
  });

  static const double height = 68;

  /// Lets the intro find where the logo lands.
  final GlobalKey logoKey;
  final NavCopy copy;
  final PaletteCopy paletteCopy;
  final String logo;

  /// False while the intro's flying mark is still on its way.
  final ValueListenable<bool> logoVisible;
  final ValueListenable<bool> scrolled;
  final ValueListenable<SectionId> active;
  final ValueChanged<SectionId> onSelect;
  final VoidCallback onLogoTap;
  final VoidCallback onOpenPalette;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final desktop = context.isDesktop;

    return ValueListenableBuilder<bool>(
      valueListenable: scrolled,
      builder: (context, isScrolled, child) => AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: height,
        decoration: BoxDecoration(
          color: isScrolled
              ? t.background.withValues(alpha: 0.92)
              : t.background.withValues(alpha: 0),
          border: Border(
            bottom: BorderSide(
              color: isScrolled ? t.line : t.line.withValues(alpha: 0),
            ),
          ),
        ),
        child: child,
      ),
      child: MaxWidth(
        child: Row(
          children: [
            Pressable(
              semanticLabel: copy.homeLink,
              onTap: onLogoTap,
              focusRadius: Radii.s,
              builder: (context, states) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ValueListenableBuilder<bool>(
                  valueListenable: logoVisible,
                  builder: (context, visible, child) =>
                      Opacity(opacity: visible ? 1 : 0, child: child),
                  child: LogoMark(key: logoKey, logo: logo),
                ),
              ),
            ),
            const Spacer(),
            if (desktop) ...[
              for (final section in SectionId.navItems)
                _NavLink(
                  label: section.label(copy),
                  section: section,
                  active: active,
                  onTap: () => onSelect(section),
                ),
              const SizedBox(width: 12),
              IconAction(
                icon: const Icon(Icons.search_rounded),
                label: copy.openPalette.fill({
                  'shortcut': paletteShortcutLabel,
                }),
                onTap: onOpenPalette,
              ),
            ],
            ThemeToggle(copy: paletteCopy),
            if (!desktop)
              IconAction(
                icon: const Icon(Icons.menu_rounded),
                label: copy.menu,
                onTap: onOpenMenu,
              ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.section,
    required this.active,
    required this.onTap,
  });

  final String label;
  final SectionId section;
  final ValueListenable<SectionId> active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return ValueListenableBuilder<SectionId>(
      valueListenable: active,
      builder: (context, current, _) {
        final isActive = current == section;
        return Pressable(
          semanticLabel: label,
          onTap: onTap,
          focusRadius: Radii.s,
          builder: (context, states) {
            final hovered = states.contains(WidgetState.hovered);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 160),
                    style: context.type.label.copyWith(
                      color: isActive || hovered ? t.text : t.textMuted,
                    ),
                    child: Text(label),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    // No overshooting curve here: animating toward 0 with
                    // easeOutBack would dip below 0, an invalid width.
                    curve: Curves.easeOutCubic,
                    width: isActive ? 16 : 0,
                    height: 2,
                    decoration: BoxDecoration(
                      color: t.signal,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
