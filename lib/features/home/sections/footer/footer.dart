import 'package:flutter/material.dart';

import '../../../../core/platform_keys.dart';
import '../../../../core/responsive.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/pressable.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
    required this.identity,
    required this.copy,
    required this.onBackToTop,
    required this.onAllLinks,
  });

  final Identity identity;
  final FooterCopy copy;
  final VoidCallback onBackToTop;
  final VoidCallback onAllLinks;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final rights = copy.rights.fill({
      'year': DateTime.now().year,
      'name': identity.displayName,
    });

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: t.line)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: MaxWidth(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 12,
            children: [
              Text('$rights   ${copy.builtWith}', style: type.small),
              Wrap(
                spacing: 20,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (context.isDesktop)
                    Text(
                      copy.paletteHint.fill({
                        'shortcut': paletteShortcutLabel,
                      }),
                      style: type.mono,
                    ),
                  _FooterLink(label: copy.allLinks, onTap: onAllLinks),
                  _FooterLink(label: copy.backToTop, onTap: onBackToTop),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Pressable(
      semanticLabel: label,
      onTap: onTap,
      focusRadius: Radii.s,
      builder: (context, states) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          label,
          style: context.type.label.copyWith(
            color: states.contains(WidgetState.hovered)
                ? t.text
                : t.textMuted,
          ),
        ),
      ),
    );
  }
}
