import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../color_schemes.g.dart';

ThemeData lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    pageTransitionsTheme: pageTransitionsTheme,
    textTheme: GoogleFonts.robotoSerifTextTheme());

ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    pageTransitionsTheme: pageTransitionsTheme,
    textTheme: GoogleFonts.robotoSerifTextTheme().apply(bodyColor: Colors.white));

class ThemeSettings with ChangeNotifier {
  bool _darktheme = true;
  SharedPreferences? _preferences;

  bool get darkTheme => _darktheme;

  ThemeSettings() {
    _loadSettingsFromPrefs();
  }

  _initializePref() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  _loadSettingsFromPrefs() async {
    await _initializePref();
    _darktheme = _preferences?.getBool("darkTheme") ?? true;
    notifyListeners();
  }

  _saveSettingsFromPrefs() async {
    await _initializePref();
    _preferences?.setBool("darkTheme", _darktheme);
  }

  void toggleTheme() {
    _darktheme = !_darktheme;
    _saveSettingsFromPrefs();
    notifyListeners();
  }
}
