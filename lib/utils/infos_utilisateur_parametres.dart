
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String aSetCesInfos = "aSetCesInfos";

class InfosUtilisateurParametres with ChangeNotifier {
  bool _aSetParametres = false;
  SharedPreferences? _preferences;

  bool get aSetParametres => _aSetParametres;

  InfosUtilisateurParametres() {
    _loadSettingsFromPrefs();
  }

  _initializePref() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  _loadSettingsFromPrefs() async {
    await _initializePref();
    _aSetParametres = _preferences?.getBool(aSetCesInfos) ?? false;
    notifyListeners();
  }

  _saveSettingsFromPrefs() async {
    await _initializePref();
    _preferences?.setBool(aSetCesInfos, _aSetParametres);
  }

  void toggleIsSet() {
    _aSetParametres = !_aSetParametres;
    _saveSettingsFromPrefs();
    notifyListeners();
  }

}