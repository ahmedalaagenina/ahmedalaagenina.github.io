import 'package:flutter/foundation.dart';

/// On web, [defaultTargetPlatform] reports the visitor's real OS, so this
/// is true for people browsing from a Mac (or iPad/iPhone).
bool get isApplePlatform =>
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// What the command-palette shortcut is called on the visitor's OS:
/// "⌘K" on Apple devices, "Ctrl + K" everywhere else.
String get paletteShortcutLabel => isApplePlatform ? '⌘K' : 'Ctrl + K';
