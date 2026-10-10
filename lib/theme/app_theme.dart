import 'package:flutter/material.dart';

import '../core/responsive.dart';

/// Design tokens for the "Field Mode" identity, resolved per brightness.
///
/// Rule of thumb: [signal] is the only accent and is used sparingly.
/// [offline] is not decoration: it only marks "offline" and "part-time".
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.line,
    required this.lineStrong,
    required this.text,
    required this.textMuted,
    required this.signal,
    required this.signalDeep,
    required this.signalText,
    required this.onSignal,
    required this.offline,
    required this.success,
    required this.phoneBody,
  });

  /// Page background ("Night" in dark mode).
  final Color background;

  /// Panels and cards.
  final Color surface;

  /// Hover and pressed surfaces, inputs.
  final Color surfaceRaised;

  /// Hairline borders.
  final Color line;
  final Color lineStrong;
  final Color text;
  final Color textMuted;

  /// Accent fill (buttons, active states). Paired with [onSignal].
  final Color signal;

  /// Darker end of the accent gradient.
  final Color signalDeep;

  /// Accent for small text and links: checked for 4.5:1 contrast on
  /// [background].
  final Color signalText;
  final Color onSignal;
  final Color offline;
  final Color success;

  /// The phone mockup stays dark in both themes, like real hardware.
  final Color phoneBody;

  LinearGradient get signalGradient => LinearGradient(
    colors: [signalDeep, signal],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const dark = AppTokens(
    background: Color(0xFF070A12),
    surface: Color(0xFF0D121E),
    surfaceRaised: Color(0xFF151C2B),
    line: Color(0xFF1C2433),
    lineStrong: Color(0xFF2C364A),
    text: Color(0xFFE8EDF6),
    textMuted: Color(0xFF8A94A8),
    signal: Color(0xFF13B9FD),
    signalDeep: Color(0xFF0175C2),
    signalText: Color(0xFF4CC8FF),
    onSignal: Color(0xFF04121F),
    offline: Color(0xFFFFB547),
    success: Color(0xFF3DDC97),
    phoneBody: Color(0xFF1A1F2B),
  );

  static const light = AppTokens(
    background: Color(0xFFF4F6FA),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFEAEEF4),
    line: Color(0xFFDDE3EC),
    lineStrong: Color(0xFFC3CCDA),
    text: Color(0xFF0B1220),
    textMuted: Color(0xFF525D70),
    signal: Color(0xFF0175C2),
    signalDeep: Color(0xFF02569B),
    signalText: Color(0xFF0062A3),
    onSignal: Color(0xFFFFFFFF),
    offline: Color(0xFF995A00),
    success: Color(0xFF0F7A59),
    phoneBody: Color(0xFF1A1F2B),
  );

  @override
  AppTokens copyWith() => this;

  @override
  AppTokens lerp(AppTokens? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppTokens(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceRaised: l(surfaceRaised, other.surfaceRaised),
      line: l(line, other.line),
      lineStrong: l(lineStrong, other.lineStrong),
      text: l(text, other.text),
      textMuted: l(textMuted, other.textMuted),
      signal: l(signal, other.signal),
      signalDeep: l(signalDeep, other.signalDeep),
      signalText: l(signalText, other.signalText),
      onSignal: l(onSignal, other.onSignal),
      offline: l(offline, other.offline),
      success: l(success, other.success),
      phoneBody: l(phoneBody, other.phoneBody),
    );
  }
}

/// Font families. Bricolage is only used at 28px and up, where its optical
/// details read as character. Everything smaller is Geist.
abstract final class Fonts {
  static const display = 'BricolageGrotesque';
  static const body = 'Geist';
  static const mono = 'GeistMono';
}

/// Corner radii by hierarchy: bigger containers get rounder corners.
abstract final class Radii {
  static const double s = 8;
  static const double m = 14;
  static const double l = 22;
}

/// Responsive type scale. Sizes step with the breakpoint, so headings stay
/// confident on desktop without overflowing a 360px phone.
class AppType {
  AppType._(this._t, this._size);

  factory AppType.of(BuildContext context) =>
      AppType._(context.tokens, context.formFactor);

  final AppTokens _t;
  final FormFactor _size;

  double _pick(double mobile, double tablet, double desktop) => switch (_size) {
    FormFactor.mobile => mobile,
    FormFactor.tablet => tablet,
    FormFactor.desktop => desktop,
  };

  TextStyle _display(double size, FontWeight weight, double height) =>
      TextStyle(
        fontFamily: Fonts.display,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: -size * 0.02,
        color: _t.text,
      );

  TextStyle _body(double size, FontWeight weight, double height, Color c) =>
      TextStyle(
        fontFamily: Fonts.body,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: c,
      );

  /// The name in the hero.
  TextStyle get hero => _display(_pick(54, 88, 120), FontWeight.w800, 0.95);

  /// Section titles.
  TextStyle get display => _display(_pick(36, 48, 64), FontWeight.w700, 1.0);

  /// Closing statement in the contact section.
  TextStyle get statement => _display(_pick(34, 52, 76), FontWeight.w800, 1.02);

  /// Card titles (role titles, product names in the showcase).
  TextStyle get headline =>
      _body(_pick(20, 22, 24), FontWeight.w600, 1.3, _t.text);

  TextStyle get title => _body(17, FontWeight.w600, 1.35, _t.text);

  /// Intro paragraphs and the hero one-liner.
  TextStyle get lead =>
      _body(_pick(18, 19, 21), FontWeight.w400, 1.5, _t.textMuted);

  TextStyle get body => _body(16, FontWeight.w400, 1.6, _t.textMuted);
  TextStyle get bodyStrong => _body(16, FontWeight.w500, 1.6, _t.text);
  TextStyle get small => _body(14, FontWeight.w400, 1.5, _t.textMuted);
  TextStyle get label => _body(14, FontWeight.w500, 1.3, _t.text);

  TextStyle get mono => TextStyle(
    fontFamily: Fonts.mono,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: _t.textMuted,
  );
}

abstract final class AppTheme {
  static ThemeData dark() => _build(AppTokens.dark, Brightness.dark);
  static ThemeData light() => _build(AppTokens.light, Brightness.light);

  static ThemeData _build(AppTokens t, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: t.signal,
      onPrimary: t.onSignal,
      secondary: t.signalText,
      onSecondary: t.onSignal,
      error: const Color(0xFFE5484D),
      onError: Colors.white,
      surface: t.surface,
      onSurface: t.text,
      onSurfaceVariant: t.textMuted,
      outline: t.lineStrong,
      outlineVariant: t.line,
      surfaceContainerHighest: t.surfaceRaised,
    );

    final base = TextStyle(fontFamily: Fonts.body, color: t.text);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: t.background,
      fontFamily: Fonts.body,
      textTheme: TextTheme(
        bodyLarge: base.copyWith(fontSize: 16),
        bodyMedium: base.copyWith(fontSize: 15),
        bodySmall: base.copyWith(fontSize: 13, color: t.textMuted),
        titleMedium: base.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        labelLarge: base.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      // Ink ripples are a Material idiom; this site uses spring press
      // feedback instead, so ripples are switched off globally.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: t.signal.withValues(alpha: .18),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: t.signal,
        selectionColor: t.signal.withValues(alpha: .28),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: t.surfaceRaised,
          borderRadius: BorderRadius.circular(Radii.s),
          border: Border.all(color: t.line),
        ),
        textStyle: base.copyWith(fontSize: 13),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: t.surfaceRaised,
        contentTextStyle: base.copyWith(fontSize: 14),
        elevation: 0,
        width: 420,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.m),
          side: BorderSide(color: t.lineStrong),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: t.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.l),
          side: BorderSide(color: t.line),
        ),
      ),
      extensions: [t],
    );
  }
}

extension AppThemeX on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
  AppType get type => AppType.of(this);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
