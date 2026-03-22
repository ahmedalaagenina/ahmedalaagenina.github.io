import 'package:flutter/material.dart';
import 'package:mycv/theme/colors/colors.dart';

class LightColors extends BaseColors {
  const LightColors();

  // Primary colors
  @override
  Color get primary => const Color(0xFF0553B1);

  @override
  Color get primaryDark => const Color(0xFF042B59);

  @override
  Color get primaryLight => const Color(0xFF4DB0FF);

  @override
  Color get onPrimary => Colors.white;

  // Secondary colors
  @override
  Color get secondary => const Color(0xFF0EA5E9);

  @override
  Color get secondaryDark => const Color(0xFF0369A1);

  @override
  Color get secondaryLight => const Color(0xFFE0F2FE);

  @override
  Color get onSecondary => Colors.white;

  // Background colors
  @override
  Color get background => const Color(0xFFF8FAFC); // Off-white

  @override
  Color get surface => const Color(0xFFFFFFFF);

  @override
  Color get onBackground => const Color(0xFF0F172A); // Deep navy

  @override
  Color get onSurface => const Color(0xFF0F172A); // Deep navy

  // Semantic colors
  @override
  Color get error => Colors.red.shade600;

  @override
  Color get success => Colors.green.shade600;

  @override
  Color get warning => Colors.orange.shade600;

  @override
  Color get info => Colors.blue.shade600;

  @override
  Color get onError => Colors.white;

  @override
  Color get onSuccess => Colors.white;

  @override
  Color get onWarning => Colors.white;

  @override
  Color get onInfo => Colors.white;

  // Surface variants (Material 3)
  @override
  Color get surfaceVariant => const Color(0xFFE2E8F0);

  @override
  Color get onSurfaceVariant => const Color(0xFF475569);

  // Extended colors (Material 3)
  @override
  Color get outline => const Color(0xFF94A3B8);

  @override
  Color get outlineVariant => const Color(0xFFCBD5E1);

  @override
  Color get inversePrimary => const Color(0xFFBAE6FD);

  @override
  Color get inverseSurface => const Color(0xFF1E293B);

  @override
  Color get onInverseSurface => const Color(0xFFF1F5F9);

  @override
  Color get scrim => Colors.black.withOpacity(0.3);

  @override
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: Brightness.light,
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
      tertiaryContainer: info.withOpacity(0.1),
      onTertiaryContainer: onInfo,
      error: error,
      onError: onError,
      errorContainer: error.withOpacity(0.1),
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

// Extension to provide additional color utilities
extension ColorExtension on Color {
  Color darker([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighter([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }
}
