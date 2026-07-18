import 'package:flutter/material.dart';

/// Extra design tokens not covered by [ColorScheme], resolved per-theme.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  final Color background;
  final Color surface;
  final Color glassFill;
  final Color glassBorder;
  final Color textPrimary;
  final Color textMuted;
  final Color accentA;
  final Color accentB;
  final Color success;

  const AppTokens({
    required this.background,
    required this.surface,
    required this.glassFill,
    required this.glassBorder,
    required this.textPrimary,
    required this.textMuted,
    required this.accentA,
    required this.accentB,
    required this.success,
  });

  LinearGradient get accentGradient => LinearGradient(
        colors: [accentA, accentB],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static const dark = AppTokens(
    background: Color(0xFF060A14),
    surface: Color(0xFF0C1224),
    glassFill: Color(0x14FFFFFF),
    glassBorder: Color(0x2BFFFFFF),
    textPrimary: Color(0xFFE9EDF8),
    textMuted: Color(0xFF8C95AC),
    accentA: Color(0xFF818CF8),
    accentB: Color(0xFF22D3EE),
    success: Color(0xFF34D399),
  );

  static const light = AppTokens(
    background: Color(0xFFF6F7FC),
    surface: Color(0xFFFFFFFF),
    glassFill: Color(0xCCFFFFFF),
    glassBorder: Color(0x1F101B3A),
    textPrimary: Color(0xFF0F1730),
    textMuted: Color(0xFF5A6478),
    accentA: Color(0xFF4F46E5),
    accentB: Color(0xFF0891B2),
    success: Color(0xFF059669),
  );

  @override
  AppTokens copyWith({
    Color? background,
    Color? surface,
    Color? glassFill,
    Color? glassBorder,
    Color? textPrimary,
    Color? textMuted,
    Color? accentA,
    Color? accentB,
    Color? success,
  }) {
    return AppTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      accentA: accentA ?? this.accentA,
      accentB: accentB ?? this.accentB,
      success: success ?? this.success,
    );
  }

  @override
  AppTokens lerp(AppTokens? other, double t) {
    if (other == null) return this;
    return AppTokens(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accentA: Color.lerp(accentA, other.accentA, t)!,
      accentB: Color.lerp(accentB, other.accentB, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

abstract final class AppTheme {
  static const String displayFont = 'SpaceGrotesk';
  static const String bodyFont = 'Inter';

  static ThemeData dark() => _build(AppTokens.dark, Brightness.dark);
  static ThemeData light() => _build(AppTokens.light, Brightness.light);

  static ThemeData _build(AppTokens t, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: t.accentA,
      brightness: brightness,
      surface: t.surface,
      primary: t.accentA,
      secondary: t.accentB,
    );

    final textTheme = _textTheme(t);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: t.background,
      fontFamily: bodyFont,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      dividerColor: t.glassBorder,
      iconTheme: IconThemeData(color: t.textMuted),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: t.glassBorder),
        ),
        textStyle: TextStyle(
          color: t.textPrimary,
          fontSize: 12,
          fontFamily: bodyFont,
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(t.textMuted.withValues(alpha: .3)),
        radius: const Radius.circular(8),
      ),
      extensions: [t],
    );
  }

  static TextTheme _textTheme(AppTokens t) {
    TextStyle display(double size, FontWeight w, {double? height}) => TextStyle(
          fontFamily: displayFont,
          fontSize: size,
          fontWeight: w,
          color: t.textPrimary,
          height: height ?? 1.15,
          letterSpacing: -0.5,
        );
    TextStyle body(double size, FontWeight w, {Color? color}) => TextStyle(
          fontFamily: bodyFont,
          fontSize: size,
          fontWeight: w,
          color: color ?? t.textPrimary,
          height: 1.6,
        );

    return TextTheme(
      displayLarge: display(64, FontWeight.w700),
      displayMedium: display(48, FontWeight.w700),
      displaySmall: display(36, FontWeight.w700),
      headlineMedium: display(28, FontWeight.w600),
      headlineSmall: display(22, FontWeight.w600),
      titleLarge: display(18, FontWeight.w600),
      titleMedium: body(16, FontWeight.w600),
      titleSmall: body(14, FontWeight.w600),
      bodyLarge: body(17, FontWeight.w400, color: t.textMuted),
      bodyMedium: body(15, FontWeight.w400, color: t.textMuted),
      bodySmall: body(13, FontWeight.w400, color: t.textMuted),
      labelLarge: body(14, FontWeight.w500),
      labelMedium: body(12, FontWeight.w500, color: t.textMuted),
    );
  }
}

extension AppTokensX on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}
