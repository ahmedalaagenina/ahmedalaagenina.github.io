import 'package:flutter/services.dart';

/// Loads the app's real fonts into the test engine.
///
/// Widget tests otherwise render text in a placeholder font where every
/// glyph is a square, which is much wider than Geist. Layout and overflow
/// checks are only meaningful with the fonts users actually see.
Future<void> loadAppFonts() async {
  const families = {
    'BricolageGrotesque': [
      'assets/fonts/BricolageGrotesque-700.ttf',
      'assets/fonts/BricolageGrotesque-800.ttf',
    ],
    'Geist': [
      'assets/fonts/Geist-400.ttf',
      'assets/fonts/Geist-500.ttf',
      'assets/fonts/Geist-600.ttf',
    ],
    'GeistMono': [
      'assets/fonts/GeistMono-400.ttf',
      'assets/fonts/GeistMono-500.ttf',
    ],
  };
  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final asset in entry.value) {
      loader.addFont(rootBundle.load(asset));
    }
    await loader.load();
  }
}
