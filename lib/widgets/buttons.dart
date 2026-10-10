import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pressable.dart';

enum ButtonTone { primary, secondary }

/// Text button with an optional leading icon. Minimum height is 48 so it is
/// a comfortable touch target (WCAG 2.5.8 asks for 24, platforms for 44+).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.url,
    this.icon,
    this.tone = ButtonTone.primary,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onTap;
  final String? url;
  final Widget? icon;
  final ButtonTone tone;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final primary = tone == ButtonTone.primary;
    final foreground = primary ? t.onSignal : t.text;

    return Pressable(
      semanticLabel: semanticLabel ?? label,
      onTap: onTap,
      url: url,
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final background = primary
            ? (hovered ? Color.lerp(t.signal, Colors.white, 0.14)! : t.signal)
            : (hovered ? t.surfaceRaised : Colors.transparent);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(Radii.m),
            border: primary
                ? null
                : Border.all(color: hovered ? t.textMuted : t.lineStrong),
          ),
          child: IconTheme.merge(
            data: IconThemeData(color: foreground, size: 18),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 10)],
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: Fonts.body,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: foreground,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Square icon-only button (44×44) with a tooltip that doubles as its label.
class IconAction extends StatelessWidget {
  const IconAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.url,
    this.size = 44,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Pressable(
      semanticLabel: label,
      tooltip: label,
      onTap: onTap,
      url: url,
      focusRadius: Radii.m - 2,
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: hovered ? t.surfaceRaised : Colors.transparent,
            borderRadius: BorderRadius.circular(Radii.m - 2),
          ),
          alignment: Alignment.center,
          child: IconTheme.merge(
            data: IconThemeData(
              color: hovered ? t.text : t.textMuted,
              size: 20,
            ),
            child: icon,
          ),
        );
      },
    );
  }
}
