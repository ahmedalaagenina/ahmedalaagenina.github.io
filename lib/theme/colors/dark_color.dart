import 'package:flutter/material.dart';
import 'package:mycv/theme/colors/colors.dart';

class DarkColors extends BaseColors {
  const DarkColors();

  // Primary colors (Flutter Blue)
  @override
  Color get primary => const Color(0xFF30B8F6);

  @override
  Color get primaryDark => const Color(0xFF1A8AD4);

  @override
  Color get primaryLight => const Color(0xFF7DD3FC);

  @override
  Color get onPrimary => Colors.white;

  // Secondary colors
  @override
  Color get secondary => const Color(0xFF6366F1);

  @override
  Color get secondaryDark => const Color(0xFF4F46E5);

  @override
  Color get secondaryLight => const Color(0xFFA5B4FC);

  @override
  Color get onSecondary => Colors.black;

  // Background colors (Deep premium dark)
  @override
  Color get background => const Color(0xFF0B0F19);

  @override
  Color get surface => const Color(0xFF111827);

  @override
  Color get onBackground => Colors.white;

  @override
  Color get onSurface => Colors.white;

  // Semantic colors
  @override
  Color get error => Colors.redAccent.shade400;

  @override
  Color get success => Colors.greenAccent.shade700;

  @override
  Color get warning => Colors.amberAccent.shade700;

  @override
  Color get info => Colors.blueAccent.shade400;

  @override
  Color get onError => Colors.black;

  @override
  Color get onSuccess => Colors.black;

  @override
  Color get onWarning => Colors.black;

  @override
  Color get onInfo => Colors.black;

  // Surface variants (Material 3)
  @override
  Color get surfaceVariant => const Color(0xFF1E293B);

  @override
  Color get onSurfaceVariant => const Color(0xFFCBD5E1);

  // Extended colors (Material 3)
  @override
  Color get outline => const Color(0xFF475569);

  @override
  Color get outlineVariant => const Color(0xFF334155);

  @override
  Color get inversePrimary => const Color(0xFFBAE6FD);

  @override
  Color get inverseSurface => Colors.white;

  @override
  Color get onInverseSurface => Colors.black;

  @override
  Color get scrim => Colors.black.withOpacity(0.4);

  @override
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryLight,
      onPrimaryContainer: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryLight,
      onSecondaryContainer: onSecondary,
      tertiary: info,
      onTertiary: onInfo,
      tertiaryContainer: info.withOpacity(0.2),
      onTertiaryContainer: onInfo,
      error: error,
      onError: onError,
      errorContainer: error.withOpacity(0.2),
      onErrorContainer: onError,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      inverseSurface: inverseSurface,
      onInverseSurface: onInverseSurface,
      inversePrimary: inversePrimary,
      shadow: scrim,
      scrim: scrim,
    );
  }
}
