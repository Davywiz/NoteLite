import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_themes.dart';

class ThemeManager with ChangeNotifier {
  ThemeData _themeData;
  AppTheme _dataThemeApp;
  final _themePrefs = 'userTheme';

  ThemeData get themeData {
    if (_themeData == null) {
      _themeData = appThemeData[AppTheme.Light];
    }
    return _themeData;
  }

  AppTheme get dataThemeApp {
    return _dataThemeApp;
  }

  // ThemeManager() {
  //   _loadTheme();
  // }

  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_themePrefs)) {
      return false;
    }
    final extractedTheme = prefs.getInt(_themePrefs);
    _themeData = appThemeData[AppTheme.values[extractedTheme]];
    _dataThemeApp = AppTheme.values[extractedTheme];

    notifyListeners();
    return false;
  }

  Future<void> setTheme(AppTheme theme) async {
    _themeData = appThemeData[theme];
    _dataThemeApp = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themePrefs, AppTheme.values.indexOf(theme));
  }
}
