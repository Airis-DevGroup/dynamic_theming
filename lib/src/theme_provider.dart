import 'package:flutter/material.dart';

// Data Manager
import 'package:dynamic_theming/src/theme_preferences.dart';

// Themes
import 'package:dynamic_theming/src/themes.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemePreferences preferences;

  ThemeProvider() {
    initProvider();
  }

  void initProvider() async {
    preferences = await ThemePreferences().init();
    await loadSavedData();
  }

  Color _desaturateColor(Color value) {
    HSLColor color = HSLColor.fromColor(value);
    return HSLColor.fromAHSL(
      (color.alpha),
      (color.hue - 0.449197861),
      (color.saturation - 0.1129032258),
      (color.lightness + 0.1235294118),
    ).toColor();
  }

  void setSystemBarsColor(Brightness platformBrightness, Color statusBarColor) {
    Brightness _statusBrightness = platformBrightness == Brightness.light ?
          Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarBrightness: _statusBrightness,
      statusBarIconBrightness: _statusBrightness,
      systemNavigationBarIconBrightness: platformBrightness,
      systemNavigationBarColor: platformBrightness == Brightness.light ?
          appTheme.scaffoldBackgroundColor :
          darkTheme.scaffoldBackgroundColor,
    ));
  }

  Color _accentColor = Colors.blueAccent;
  Color _darkAccent = Colors.lightBlueAccent;
  bool _systemThemeAvailable = false;
  bool _systemThemeEnabled = false;
  bool _darkThemeEnabled = false;
  bool _blackThemeEnabled = false;

  Color get accentColor => _accentColor;
  Color get darkAccent => _darkAccent;

  bool get systemThemeAvailable => _systemThemeAvailable;
  bool get systemThemeEnabled => _systemThemeEnabled;
  bool get darkThemeEnabled => _darkThemeEnabled;
  bool get blackThemeEnabled => _blackThemeEnabled;

  ThemeData get appTheme {
    if (!darkThemeEnabled || systemThemeEnabled)
      return AppTheme.white(accentColor);
    else
      return darkTheme;
  }

  ThemeData get darkTheme {
    if (blackThemeEnabled)
      return AppTheme.black(darkAccent);
    else
      return AppTheme.dark(darkAccent);
  }

  set systemThemeAvailable(bool value){
    _systemThemeAvailable = value;
    if (value)
      _systemThemeEnabled = preferences.systemThemeEnabled;
    else 
      _systemThemeEnabled = false;
    notifyListeners();
  }

  set accentColor(Color value) {
    _accentColor = value;
    _darkAccent = _desaturateColor(_accentColor);
    preferences.accentColor = _accentColor;
    notifyListeners();
  }

  set systemThemeEnabled(bool value) {
    _systemThemeEnabled = value;
    preferences.systemThemeEnabled = _systemThemeEnabled;
    notifyListeners();
  }

  set darkThemeEnabled(bool value) {
    _darkThemeEnabled = value;
    preferences.darkThemeEnabled = value;
    notifyListeners();
  }

  set blackThemeEnabled(bool value) {
    _blackThemeEnabled = value;
    preferences.blackThemeEnabled = value;
    notifyListeners();
  }

  Future<void> loadSavedData() async {
    systemThemeAvailable = await preferences.isSystemThemeAvailable();
    accentColor = preferences.accentColor;
    darkThemeEnabled = preferences.darkThemeEnabled;
    blackThemeEnabled = preferences.blackThemeEnabled;
  }
}
