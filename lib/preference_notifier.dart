import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesNotifier extends ChangeNotifier {
  SharedPreferencesAsync _prefs;

  PreferencesNotifier(this._prefs);

  Future<String?> getValue(String key) {
    var r = _prefs.getString(key);
    print(r);
    return r;
  }

  Future<void> setValue(String key, String value) async {
    await _prefs.setString(key, value);
    notifyListeners();
  }
}