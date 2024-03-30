// theme_provider.dart

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:ous/domain/share_preferences_instance.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(),
);

class AppTheme {
  final ThemeMode mode;
  final MaterialColor primarySwatch;

  AppTheme({required this.mode, required this.primarySwatch});
}

class ThemeNotifier extends StateNotifier<AppTheme> {
  static const String keyThemeMode = 'theme_mode';
  static const String keyPrimarySwatch = 'primary_swatch';
  final _prefs = SharedPreferencesInstance().prefs;

  ThemeNotifier()
      : super(
          AppTheme(
            mode: ThemeMode.system,
            primarySwatch: Colors.blue,
          ),
        ) {
    final themeMode = _loadThemeMode() ?? ThemeMode.system;
    final primarySwatch = _loadPrimarySwatch() ?? Colors.blue;
    state = AppTheme(mode: themeMode, primarySwatch: primarySwatch);
  }

  Future<void> updateTheme(AppTheme theme) async {
    await _saveThemeMode(theme.mode);
    await _savePrimarySwatch(theme.primarySwatch);
    state = theme;
  }

  MaterialColor? _loadPrimarySwatch() {
    final loaded = _prefs.getInt(keyPrimarySwatch);
    if (loaded == null) {
      return null;
    }
    return Colors.primaries[loaded];
  }

  ThemeMode? _loadThemeMode() {
    final loaded = _prefs.getString(keyThemeMode);
    if (loaded == null) {
      return null;
    }
    return ThemeMode.values.byName(loaded);
  }

  Future<bool> _savePrimarySwatch(MaterialColor primarySwatch) =>
      _prefs.setInt(keyPrimarySwatch, Colors.primaries.indexOf(primarySwatch));

  Future<bool> _saveThemeMode(ThemeMode themeMode) =>
      _prefs.setString(keyThemeMode, themeMode.name);
}
