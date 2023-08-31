import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:http/http.dart' as http;

class LocalizationProvider with ChangeNotifier {
  late Locale _currentLocale;

  LocalizationProvider() {
    _currentLocale = Locale("en");
    loadLocale();
  }

  void changeLocale(String value) {
    this._currentLocale = new Locale(value);
    notifyListeners();
  }

  Locale get currentLocale => _currentLocale;

  Future<void> setLanguageLocaly(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("locale", value);
    changeLocale(value);
  }

  Future<void> loadLocale() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? locale = pref.getString("locale");
    if (locale == null) {
      changeLocale("en");
    } else {
      changeLocale(locale);
    }
  }

  Future<void> setLanguageStrapi(
      {String? id, required String localeCode}) async {
    String locale = "en";
    if (localeCode.contains("en")) {
      locale = "en";
    } else if (localeCode.contains("ru")) {
      locale = "ru-RU";
    } else if (localeCode.contains("ar")) {
      locale = "ar-AE";
    } else if (localeCode.contains("de")) {
      locale = "de-DE";
    } else if (localeCode.contains("es")) {
      locale = "es-ES";
    } else if (localeCode.contains("fr")) {
      locale = "fr-FR";
    } else if (localeCode.contains("it")) {
      locale = "it-IT";
    } else if (localeCode.contains("th")) {
      locale = "th-TH";
    } else if (localeCode.contains("tr")) {
      locale = "tr-TR";
    } else {
      locale = "en";
    }
    if (id != null) {
      var url = Uri.parse("$CONST_URL/profiles/$id");
      var response = await http.put(
        url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(
          {"locale": locale},
        ),
      );
    }
  }
}
