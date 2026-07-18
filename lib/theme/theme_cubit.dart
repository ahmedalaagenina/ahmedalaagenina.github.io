import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _prefsKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.dark) {
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved == 'light') emit(ThemeMode.light);
    if (saved == 'dark') emit(ThemeMode.dark);
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, next == ThemeMode.dark ? 'dark' : 'light');
  }
}
