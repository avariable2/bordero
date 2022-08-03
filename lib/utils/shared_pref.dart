
import 'dart:convert';

import 'package:app_psy/model/utilisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  static final SharedPref _sharedPref = SharedPref._internal();

  factory SharedPref() {
    return _sharedPref;
  }

  readIsSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(aSetCesInfos) ?? false;
  }

  saveIsSetOrNot(bool isSet) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(aSetCesInfos, isSet);
  }

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key) ?? "");
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  SharedPref._internal();
}