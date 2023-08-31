import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utility/constants.dart';
import 'home_tour_provider.dart';
import 'package:weather/weather.dart';

class WeatherProvider with ChangeNotifier {
  CityWeather? _cityWeather;
  CityWeather? get cityWeather => _cityWeather;

  void setCityWeather(CityWeather value) {
    _cityWeather = value;
    notifyListeners();
  }

  void nullifyWeather() {
    _cityWeather = null;
    notifyListeners();
  }

  Future<void> getWeatherData({required String cityID}) async {
    var url = Uri.parse("$CONST_URL/cities/$cityID");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    await checkDefine(response);
  }

  Future<void> checkDefine(Response response) async {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202 ||
        response.statusCode == 203) {
      if (response.body.isNotEmpty) {
        var data = jsonDecode(response.body) as dynamic;
        if (data["locale"] as String == "en") {
          await getDataFromAPI(data["name"] as String);
        } else {
          List<dynamic> listData = data["localizations"] as List<dynamic>;
          String neededId = "abc";
          listData.forEach((element) {
            if (element["locale"] as String == "en") {
              neededId = element["id"] as String;
            }
          });
          await getEngCityName(neededId);
        }
      } else {
        nullifyWeather();
      }
    } else {
      nullifyWeather();
    }
  }

  Future<void> getEngCityName(String cityID) async {
    var url = Uri.parse("$CONST_URL/cities/$cityID");
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
      if (response.body.isNotEmpty) {
        var data = jsonDecode(response.body) as dynamic;
        await getDataFromAPI(data["name"] as String);
      } else {
        nullifyWeather();
      }
    } else {
      nullifyWeather();
    }
  }

  Future<void> getDataFromAPI(String cityName) async {
    WeatherFactory wf = new WeatherFactory("324fe96ab359abec70ad9f9e5a497b6c",
        language: Language.ENGLISH);
    print("WEATHER DATA GET API CHECK");
    print(cityName);
    Weather forecast = await wf.currentWeatherByCityName(cityName);

    setCityWeather(CityWeather(
        temperature: forecast.temperature!.celsius!.ceilToDouble(),
        fallout: forecast.weatherIcon!));
  }
}

class TourLocale {
  final String id;
  final String locale;

  TourLocale({required this.id, required this.locale});
}
