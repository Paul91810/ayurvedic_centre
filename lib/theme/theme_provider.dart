import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() {
    _isDark = !_isDark;
    _saveTheme(_isDark);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final box = Hive.box('app');
    _isDark = box.get('isDark', defaultValue: false);
    notifyListeners();
  }

  Future<void> _saveTheme(bool isDark) async {
    final box = Hive.box('app');
    await box.put('isDark', isDark);
  }
}
