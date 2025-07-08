import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';

/// Theme controller for managing app theme and dark mode
/// Provides reactive theme switching with persistent storage
class ThemeController extends GetxController {
  // Private variables
  ThemeMode _themeMode = ThemeMode.system;
  late SharedPreferences _prefs;

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Get current theme mode as string
  String get currentThemeString {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppStrings.lightTheme;
      case ThemeMode.dark:
        return AppStrings.darkTheme;
      case ThemeMode.system:
        return AppStrings.systemTheme;
    }
  }

  /// Check if current theme is dark (considering system theme)
  bool get isCurrentThemeDark {
    if (_themeMode == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode == ThemeMode.dark;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeTheme();
  }

  /// Initialize theme from saved preferences
  Future<void> _initializeTheme() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final savedTheme = _prefs.getString(AppStrings.themeKey);
      
      if (savedTheme != null) {
        _themeMode = _getThemeModeFromString(savedTheme);
      } else {
        // Default to system theme
        _themeMode = ThemeMode.system;
        await _saveTheme();
      }
      
      update();
    } catch (e) {
      // Handle error gracefully, use system theme as fallback
      _themeMode = ThemeMode.system;
      update();
    }
  }

  /// Convert string to ThemeMode
  ThemeMode _getThemeModeFromString(String themeString) {
    switch (themeString) {
      case AppStrings.lightTheme:
        return ThemeMode.light;
      case AppStrings.darkTheme:
        return ThemeMode.dark;
      case AppStrings.systemTheme:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  /// Save theme preference to storage
  Future<void> _saveTheme() async {
    try {
      await _prefs.setString(AppStrings.themeKey, currentThemeString);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Change theme mode
  Future<void> changeThemeMode(ThemeMode themeMode) async {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      await _saveTheme();
      update();
      
      // Update GetX theme
      Get.changeThemeMode(themeMode);
    }
  }

  /// Change to light theme
  Future<void> changeToLightTheme() async {
    await changeThemeMode(ThemeMode.light);
  }

  /// Change to dark theme
  Future<void> changeToDarkTheme() async {
    await changeThemeMode(ThemeMode.dark);
  }

  /// Change to system theme
  Future<void> changeToSystemTheme() async {
    await changeThemeMode(ThemeMode.system);
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.system) {
      // If system mode, switch to opposite of current system theme
      if (Get.isPlatformDarkMode) {
        await changeToLightTheme();
      } else {
        await changeToDarkTheme();
      }
    } else if (_themeMode == ThemeMode.light) {
      await changeToDarkTheme();
    } else {
      await changeToLightTheme();
    }
  }

  /// Get available theme options
  List<Map<String, dynamic>> getThemeOptions() {
    return [
      {
        'title': 'Light',
        'subtitle': 'Always use light theme',
        'value': ThemeMode.light,
        'icon': Icons.light_mode,
        'isSelected': _themeMode == ThemeMode.light,
      },
      {
        'title': 'Dark',
        'subtitle': 'Always use dark theme',
        'value': ThemeMode.dark,
        'icon': Icons.dark_mode,
        'isSelected': _themeMode == ThemeMode.dark,
      },
      {
        'title': 'System',
        'subtitle': 'Follow system setting',
        'value': ThemeMode.system,
        'icon': Icons.auto_mode,
        'isSelected': _themeMode == ThemeMode.system,
      },
    ];
  }

  /// Get theme mode display name
  String getThemeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get theme mode icon
  IconData getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }

  /// Reset theme to default (system)
  Future<void> resetTheme() async {
    await changeToSystemTheme();
  }

  /// Check if theme has been changed from default
  bool get isThemeCustomized {
    return _themeMode != ThemeMode.system;
  }

  /// Get brightness for current theme
  Brightness get currentBrightness {
    if (_themeMode == ThemeMode.system) {
      return Get.isPlatformDarkMode ? Brightness.dark : Brightness.light;
    }
    return _themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
  }

  /// Update status bar style based on current theme
  void updateStatusBarStyle() {
    // This will be implemented when we add the status bar styling
  }
}
