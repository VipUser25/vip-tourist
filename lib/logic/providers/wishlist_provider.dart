import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:http/http.dart' as http;

class WishlistProvider with ChangeNotifier {
  List<String> _favoriteTours = [];
  bool _isFirstTime = false;

  void setFirstTime(bool value) {
    _isFirstTime = value;
    notifyListeners();
  }

  bool get getIsFirstTime => _isFirstTime;

  WishlistProvider() {
    loadWishlist();
  }

  List<String> get favoriteTours => _favoriteTours;

  void setFavoriteTours(List<String> value) {
    _favoriteTours = value;
    notifyListeners();
  }

  Future<void> loadWishlist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? tempList = pref.getStringList("favoriteTours");

    if (tempList == null) {
    } else if (tempList.isEmpty) {
    } else {
      setFavoriteTours(tempList);
    }
  }

  Future<void> addToFavorites(String tourVID) async {
    _favoriteTours.add(tourVID);
    SharedPreferences pref = await SharedPreferences.getInstance();
    notifyListeners();
    pref.setStringList("favoriteTours", _favoriteTours.toList());
    loadWishlist();
  }

  Future<void> removeFromFavorites(String tourVID) async {
    _favoriteTours.remove(tourVID);
    SharedPreferences pref = await SharedPreferences.getInstance();
    notifyListeners();
    pref.setStringList("favoriteTours", _favoriteTours.toList());
    loadWishlist();
  }

  bool isFavorite(String tourVID) {
    return _favoriteTours.contains(tourVID);
  }

  Future<List<WishlistTour>> getFavoriteTours(String localeCode) async {
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
    List<WishlistTour> temp = [];
    String urlRef = urlString();

    var url =
        Uri.parse("$CONST_URL/tours$urlRef&_approved=true&_locale=$locale");
    print("URL CHECK");
    print(url);
    var response = await http.get(url);
    try {
      final body = jsonDecode(response.body) as List<dynamic>;
      body.forEach((element) {
        temp.add(
          WishlistTour(
            reviews: element["reviews_count"] as int,
            duration: int.parse(element["duration"] as String),
            image: element["mainPhotoUrl"] ??
                "https://icons8.com/wp-content/uploads/2020/02/digital-illustration-brian-edward-miller.jpg|sdf",
            tourID: element["id"],
            tourName: element["name"],
            rating: element["rating"] == null
                ? 0
                : double.parse(element["rating"].toString()),
            price: getTotalWithComission(element["price"].toString()),
          ),
        );
      });
    } catch (e) {}

    return temp;
  }

  double getTotalWithComission(String value) {
    double val;

    try {
      val = double.parse(value);
    } catch (e) {
      return 0.0;
    }

    if (val < 10 && val >= 0) {
      val = val + 2;
    } else if (val >= 10 && val < 31) {
      double perc = (val * 20) / 100;
      val = val + perc;
    } else if (val >= 31 && val < 40) {
      val = val + 7;
    } else if (val >= 40 && val < 131) {
      double perc = (val * 18) / 100;
      val = val + perc;
    } else if (val >= 131 && val < 231) {
      val = val + 30;
    } else if (val >= 231 && val < 501) {
      double perc = (val * 13) / 100;
      val = val + perc;
    } else if (val >= 501) {
      double perc = (val * 10) / 100;
      val = val + perc;
    }

    return val;
  }

  String urlString() {
    String firstPrefix = "?id=";
    String commonPrefix = "&id=";
    if (_favoriteTours.length == 1) {
      return "?id=" + _favoriteTours[0];
    } else if (_favoriteTours.length > 1) {
      String temp = firstPrefix + _favoriteTours[0];
      for (int i = 1; i < _favoriteTours.length; i++) {
        temp = temp + commonPrefix + _favoriteTours[i];
      }
      return temp;
    } else {
      return firstPrefix + "dff6666666666";
    }
  }

  String getOnePhoto(String? imageUrls) {
    if (imageUrls != null) {
      List<String> temp = [];
      temp = imageUrls.split("|");
      return temp[0];
    } else {
      return "https://icons8.com/wp-content/uploads/2020/02/digital-illustration-brian-edward-miller.jpg";
    }
  }
}

class WishlistTour {
  final String tourID;
  final String tourName;
  final double rating;
  final String image;
  final double price;
  final int duration;
  final int reviews;
  const WishlistTour(
      {required this.image,
      required this.tourID,
      required this.tourName,
      required this.rating,
      required this.price,
      required this.duration,
      required this.reviews});
}
