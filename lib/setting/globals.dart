// app_theme.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme extends ChangeNotifier {
  Color _currentColor = Colors.lightGreen;

  Color get currentColor => _currentColor;

  Future<void> updateColor(Color newColor) async {
    _currentColor = newColor;
    notifyListeners();
    await _saveColorToPrefs(newColor);
  }

  Future<void> _saveColorToPrefs(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('color', color.value);
  }

  Future<void> loadColorFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorValue = prefs.getInt('color') ?? Colors.lightGreen.value;
    _currentColor = Color(colorValue);
    notifyListeners();
  }
}
