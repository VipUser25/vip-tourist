import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';

import '../utility/constants.dart';

class HomeCitiesProvider with ChangeNotifier {
  final LocalizationProvider localizationProvider;
  HomeCitiesProvider({required this.localizationProvider}) {
    initialize(localeCode: localizationProvider.currentLocale.languageCode);
  }
  List<MiniCity> _popularestCities = [];
  int _start = 0;
  int _limit = 5;
  bool _firstFewLoaded = false;
  List<MiniCity> get popularestCities => _popularestCities;

  bool _additionalLoading = true;
  bool get additionalLoading => _additionalLoading;
  void setAdditionalLoading(bool value) {
    _additionalLoading = value;
    notifyListeners();
  }

  void addToPopularestCities(List<MiniCity> cc) {
    _popularestCities.addAll(cc);
    notifyListeners();
  }

  void incrementCities() {
    _start = _start + 5;
    // _limit = _limit + 2;
    notifyListeners();
  }

  bool get firstFewLoaded => _firstFewLoaded;
  void setFirstFewLoaded() {
    _firstFewLoaded = true;
    notifyListeners();
  }

  Future<void> getCities() async {
    String localeCode = localizationProvider.currentLocale.languageCode;
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
    setAdditionalLoading(true);
    List<MiniCity> cities = [];
    var url = Uri.parse(
        "$CONST_URL/cities?_start=$_start&_limit=$_limit&_sort=tours&_locale=$locale");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    print("start: $_start");
    print("limit: $_limit");
    print("REQUEST CHECK");

    print(
        "$CONST_URL/cities?_start=$_start&_limit=$_limit&_sort=tours&_locale=$locale");
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202 ||
        response.statusCode == 203) {
      final data = jsonDecode(response.body) as List<dynamic>;
      try {
        if (data.isNotEmpty && data.length > 0) {
          data.forEach(
            (element) {
              cities.add(MiniCity(
                  cityID: element["id"],
                  cityName: element["name"],
                  flag: CONST_URL + element["image"]["url"],
                  countryName: element["country"]["name"]));
            },
          );
          setAdditionalLoading(false);
          addToPopularestCities(cities);
        } else {
          addToPopularestCities([]);
          setAdditionalLoading(false);
        }
      } catch (e) {
        addToPopularestCities([]);
        setAdditionalLoading(false);
      }
    }
  }

  Future<void> initialize({required String localeCode}) async {
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

    List<MiniCity> cities = [];
    var url = Uri.parse(
        "$CONST_URL/cities?_start=$_start&_limit=$_limit&_sort=tours&_locale=$locale");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202 ||
        response.statusCode == 203) {
      final data = jsonDecode(response.body) as List<dynamic>;

      if (data.isNotEmpty && data.length > 0) {
        data.forEach(
          (element) {
            try {
              cities.add(MiniCity(
                  cityID: element["id"],
                  cityName: element["name"],
                  flag: CONST_URL + element["image"]["url"],
                  countryName: element["country"]["name"]));
            } catch (e) {}
          },
        );
      }
    }
    addToPopularestCities(cities);
    setFirstFewLoaded();
  }
}
