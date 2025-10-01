import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    _loadTheme();
  }

  void _loadTheme() async {
    final box = await Hive.openBox("settings");
    if (box.containsKey("themeMode")) {
      _isDark = box.get("themeMode") == "dark";
    } else {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDark = brightness == Brightness.dark;
    }
    notifyListeners();
  }

  void toggleTheme() async {
    _isDark = !_isDark;
    final box = await Hive.openBox("settings");
    await box.put("themeMode", _isDark ? "dark" : "light");
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _isDark = brightness == Brightness.dark;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ThemeMode get currentTheme => _isDark ? ThemeMode.dark : ThemeMode.light;
}
