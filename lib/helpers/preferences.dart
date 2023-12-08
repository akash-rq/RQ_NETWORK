import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'typedefs.dart';


class Preference {
  Preference._();

  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<String> getItem(String name) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(name) ?? '';
  }

  static Future<bool> setItem(String name, String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(name, value);
  }

  static Future<Set<String>> getAll() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getKeys();
  }

  //****************************** user-access-token **************************//
  static Future<JSON?> getUserAccessToken() async {
    final SharedPreferences prefs = await _prefs;
    final String? tokenString = prefs.getString('token');
    if (tokenString == null) {
      return null;
    }
    final JSON? accessToken = json.decode(tokenString)  as JSON?;
    return accessToken;
  }

  static Future<void> setUserAccessToken({JSON? token}) async {
    final SharedPreferences prefs = await _prefs;
    if (token == null) {
      await prefs.setString('token', '');
    }

    final String tokenString = json.encode(token);
    await prefs.setString('token', tokenString);
  }
}
