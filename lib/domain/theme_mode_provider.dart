//テーマモードの状態を管理するProvider
// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/domain/share_preferences_instance.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

// Project imports:

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String keyThemeMode = 'theme_mode';
  final _prefs = SharedPreferencesInstance().prefs;
  ThemeModeNotifier() : super(ThemeMode.system) {
    state = _loadThemeMode() ?? ThemeMode.system;
  }

  Future<void> toggle() async {
    ThemeMode themeMode;
    switch (state) {
      case ThemeMode.light:
        themeMode = ThemeMode.dark;
      case ThemeMode.dark:
        themeMode = ThemeMode.system;
      case ThemeMode.system:
        themeMode = ThemeMode.light;
    }
    await _saveThemeMode(themeMode).then((value) {
      if (value) {
        state = themeMode;
      }
    });
  }

  ThemeMode? _loadThemeMode() {
    final loaded = _prefs.getString(keyThemeMode);
    if (loaded == null) {
      return null;
    }
    return ThemeMode.values.byName(loaded);
  }

  Future<bool> _saveThemeMode(ThemeMode themeMode) =>
      _prefs.setString(keyThemeMode, themeMode.name);
}
