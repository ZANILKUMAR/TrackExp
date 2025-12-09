import 'package:hive_flutter/hive_flutter.dart';

class ThemeService {
  static const String _boxName = 'settings';
  static const String _themeKey = 'isDarkMode';
  
  static Box? _box;

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  static bool getThemeMode() {
    return _box?.get(_themeKey, defaultValue: false) ?? false;
  }

  static Future<void> setThemeMode(bool isDarkMode) async {
    await _box?.put(_themeKey, isDarkMode);
  }
}
