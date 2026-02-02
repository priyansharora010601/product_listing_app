import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _useSystemKey = 'use_system_theme';

  ThemeMode _themeMode = ThemeMode.system;
  bool _useSystemTheme = true; // Default: follow system

  ThemeMode get themeMode => _useSystemTheme ? ThemeMode.system : _themeMode;
  bool get useSystemTheme => _useSystemTheme;

  // Check if currently in dark mode (considering system preference)
  bool get isDarkMode {
    if (_useSystemTheme) {
      // Get system brightness
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  bool get isLightMode => !isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  // Load theme preferences from storage
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if user has set a preference to not use system theme
      _useSystemTheme = prefs.getBool(_useSystemKey) ?? true;

      if (!_useSystemTheme) {
        // Load user's manual theme choice
        final isDark = prefs.getBool(_themeKey) ?? false;
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  // Toggle between light and dark (disables system theme)
  Future<void> toggleTheme() async {
    if (_useSystemTheme) {
      // If currently using system theme, switch to manual mode
      // Set to opposite of current system theme
      _useSystemTheme = false;
      _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    } else {
      // Toggle between light and dark
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    }

    await _saveTheme();
    notifyListeners();
  }

  // Set to use system theme
  Future<void> useSystemSettings() async {
    _useSystemTheme = true;
    await _saveTheme();
    notifyListeners();
  }

  // Set specific theme (disables system theme)
  Future<void> setTheme(ThemeMode mode) async {
    _useSystemTheme = false;
    _themeMode = mode;
    await _saveTheme();
    notifyListeners();
  }

  // Set dark mode manually
  Future<void> setDarkMode(bool isDark) async {
    _useSystemTheme = false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _saveTheme();
    notifyListeners();
  }

  // Save theme preferences to storage
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_useSystemKey, _useSystemTheme);
      await prefs.setBool(_themeKey, _themeMode == ThemeMode.dark);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  // Reset to system default
  Future<void> resetToSystem() async {
    _useSystemTheme = true;
    await _saveTheme();
    notifyListeners();
  }
}