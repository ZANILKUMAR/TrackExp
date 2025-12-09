import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/theme_service.dart';

class ThemeModeNotifier extends StateNotifier<bool> {
  ThemeModeNotifier() : super(ThemeService.getThemeMode());

  Future<void> toggleTheme(bool isDarkMode) async {
    state = isDarkMode;
    await ThemeService.setThemeMode(isDarkMode);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>((ref) {
  return ThemeModeNotifier();
});
