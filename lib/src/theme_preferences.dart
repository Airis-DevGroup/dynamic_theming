import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Key identifiers for variables saved in SharedPreferences.
String _accentKey = "accent_color";
String _systemThemeKey = "use_system_theme";
String _darkThemeKey = "use_dark_theme";
String _blackThemeKey = "use_black_theme";

class ThemePreferences {
  SharedPreferences prefs;

  Future<ThemePreferences> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> isSystemThemeAvailable() async {
    String version;
    if(Platform.isAndroid){
      AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
      version = deviceInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo deviceInfo = await DeviceInfoPlugin().iosInfo;
      version = deviceInfo.systemVersion;
    }
    if (double.parse(version) >= 9 || double.parse(version) >= 13)
      return true;
    else return false;
  }

  Color get accentColor => Color(prefs.getInt(_accentKey) ?? Colors.blueAccent.value);
  set accentColor(Color color) => prefs.setInt(_accentKey, color.value);

  bool get systemThemeEnabled => prefs.getBool(_systemThemeKey) ?? true;
  set systemThemeEnabled(bool value) => prefs.setBool(_systemThemeKey, value);
  
  bool get darkThemeEnabled => prefs.getBool(_darkThemeKey) ?? false;
  set darkThemeEnabled(bool value) => prefs.setBool(_darkThemeKey, value);

  bool get blackThemeEnabled => prefs.getBool(_blackThemeKey) ?? false;
  set blackThemeEnabled(bool value) => prefs.setBool(_blackThemeKey, value);
}
