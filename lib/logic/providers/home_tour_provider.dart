import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vip_tourist/logic/models/categories.dart';
import 'package:vip_tourist/logic/models/mini_tour.dart';

import 'package:http/http.dart' as http;
import 'package:vip_tourist/logic/providers/filter_tour_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'dart:io';
import 'package:unique_list/unique_list.dart';
import '../../presentation/screens/tours_on_map_screen.dart';

class NoInternetConnection implements Exception {}

class HomeScreenTourProvider with ChangeNotifier {
  List<MiniCity> _suggestedList = [];
  List<MiniCity> get suggestedList => _suggestedList;
  void setSuggestedList(List<MiniCity> value) {
    _suggestedList = value;
  }

  UniqueList _recentlyWatched = UniqueList<String>();
  UniqueList get recentlyWatched => _recentlyWatched;
  void setRecentlyWatched(UniqueList list) {
    _recentlyWatched = list;
    notifyListeners();
  }

  int vn = 1;
  String? _cityID;

  Map<int, MiniTour> _tours = {};

  HomeScreenTourProvider() {
    loadCityId();
  }
  Map<int, MiniTour> get tours => _tours;
  bool _toursLoaded = false;

  bool get toursLoaded => _toursLoaded;

  void setToursLoaded(bool value) {
    _toursLoaded = value;
    notifyListeners();
  }

  void setTours(Map<int, MiniTour> value) {
    _tours = value;
    notifyListeners();
  }

  void triggerUpdate() {
    vn++;
    notifyListeners();
  }

  List<MiniCity> cities = [];
  List<MiniCity> filteredCities = [];
  ////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
////////////////////////////////////////

////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////
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

  Future<Map<String, MiniTour>> getTours(String localeCode) async {
    String id = cityID ?? "2021931244501";
    String locale = "en";
    print("CITY ID BELLOW");
    print(_cityID);
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
    int sn = vn + 5;
    print(sn);
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      throw NoInternetConnection();
    }

    var url = Uri.parse(
        "$CONST_URL/tours?_city.vid=$id&_locale=$locale&_approved=true");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );

    var data = jsonDecode(response.body) as List<dynamic>;

    Map<String, MiniTour> tempTours = {};

    data.forEach(
      (element) {
        print("CHECK TOUR WORKING GOOD BELLOW");
        print(element["price"].toString());
        tempTours.putIfAbsent(
          element["id"],
          () => MiniTour(
            tourID: element["id"],
            reviews: element["reviews_count"],
            duration: int.parse(element["duration"] as String),
            name: element["name"],
            localizations: (element['localizations'] as List<dynamic>?)
                ?.map((e) => MiniLocal(
                    id: e['id'] as String, code: e['locale'] as String))
                .toList(),
            photoURL: getOnePhoto(element["image_urls"]),
            price: getTotalWithComission(element["price"].toString()),
            rating: element["rating"] ?? 0,
            category: Categories(
                guideTour: element["guide"],
                privateTour: element["private"],
                oneDayTrip: element["one_day_trip"],
                nature: element["nature"],
                ticketMustHave: element["ticket_must_have"],
                onWater: element["on_water"],
                packageTour: element["package_tour"],
                smallGroup: element["small_group"],
                invalidFriendly: element["invalid_friendly"],
                history: element["history"],
                worldWar: element["world_war"],
                openAir: element["open_air"],
                streetArt: element["street_art"],
                adrenaline: element["adrenaline"],
                architecture: element["architecture"],
                food: element["food"],
                music: element["music"],
                forCouples: element["for_couples_activities"],
                forKids: element["for_kids_activities"],
                museum: element["museum"],
                memorial: element["memorial"],
                park: element["park"],
                gallery: element["gallery"],
                square: element["square"],
                theater: element["theater"],
                castle: element["castle"],
                towers: element["towers"],
                airports: element["airports"],
                bicycle: element["bicycle"],
                minivan: element["minivan"],
                publicTransport: element["public_transport"],
                limousine: element["limousine"],
                taxi: element["bicycle_taxi"],
                car: element["car"],
                cruise: element["cruise"],
                adventure: element["adventure"],
                fewDaysTrip: element["fewDaysTrip"],
                fishing: element["fishing"],
                game: element["game"],
                hunting: element["hunting"],
                night: element["night"],
                onlyTransfer: element["onlyTransfer"]),
          ),
        );
      },
    );

    return tempTours;
  }

  Future<List<TempCatalogTour>> getTopTour({required String localeCode}) async {
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

    var url =
        Uri.parse("$CONST_URL/tours?top=true&_locale=$locale&_approved=true");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var data = jsonDecode(response.body) as List<dynamic>;
    print("TOP TOURS URL CHECK");
    print("$CONST_URL/tours?top=true&_locale=$locale");
    print("TOP TOURS DATA CHECK");
    print(data);
    List<TempCatalogTour> toursList = [];
    data.forEach((element) {
      toursList.add(
        TempCatalogTour(
            tourID: element["id"],
            reviews: element["reviews_count"],
            name: element["name"],
            isTopTour: element["top"],
            withTransfer: element["withTransfer"] as bool,
            image: element["mainPhotoUrl"] ??
                "https://icons8.com/wp-content/uploads/2020/02/digital-illustration-brian-edward-miller.jpg|sdf",
            rating: element["rating"] ?? 0,
            price: getTotalWithComission(element["price"].toString()),
            categories: Categories(
                guideTour: element["guide"],
                privateTour: element["private"],
                oneDayTrip: element["one_day_trip"],
                nature: element["nature"],
                ticketMustHave: element["ticket_must_have"],
                onWater: element["on_water"],
                packageTour: element["package_tour"],
                smallGroup: element["small_group"],
                invalidFriendly: element["invalid_friendly"],
                history: element["history"],
                worldWar: element["world_war"],
                openAir: element["open_air"],
                streetArt: element["street_art"],
                adrenaline: element["adrenaline"],
                architecture: element["architecture"],
                food: element["food"],
                music: element["music"],
                forCouples: element["for_couples_activities"],
                forKids: element["for_kids_activities"],
                museum: element["museum"],
                memorial: element["memorial"],
                park: element["park"],
                gallery: element["gallery"],
                square: element["square"],
                theater: element["theater"],
                castle: element["castle"],
                towers: element["towers"],
                airports: element["airports"],
                bicycle: element["bicycle"],
                minivan: element["minivan"],
                publicTransport: element["public_transport"],
                limousine: element["limousine"],
                taxi: element["bicycle_taxi"],
                car: element["car"],
                cruise: element["cruise"],
                adventure: element["adventure"],
                fewDaysTrip: element["fewDaysTrip"],
                fishing: element["fishing"],
                game: element["game"],
                hunting: element["hunting"],
                night: element["night"],
                onlyTransfer: element["onlyTransfer"]),
            adventure: element["adventure"],
            fewDaysTrip: element["fewDaysTrip"],
            fishing: element["fishing"],
            game: element["game"],
            hunting: element["hunting"],
            night: element["night"],
            onlyTransfer: element["onlyTransfer"],
            seats: element["placesCount"] ?? null,
            duration: int.parse(element["duration"] as String)),
      );
    });

    return toursList;
  }

  Future<List<TempCatalogTour>> getRecentlyWatchedTours(
      {required String localeCode}) async {
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
    String urlRef = urlString();
    var url =
        Uri.parse("$CONST_URL/tours$urlRef&_approved=true&_locale=$locale");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var data = jsonDecode(response.body) as List<dynamic>;
    print("DATA GET BY VALUE CHECK");
    print(data);
    List<TempCatalogTour> toursList = [];
    data.forEach((element) {
      toursList.add(
        TempCatalogTour(
          tourID: element["id"],
          reviews: element["reviews_count"],
          name: element["name"],
          isTopTour: element["top"],
          withTransfer: element["withTransfer"] as bool,
          image: element["mainPhotoUrl"] ??
              "https://icons8.com/wp-content/uploads/2020/02/digital-illustration-brian-edward-miller.jpg|sdf",
          rating: element["rating"] ?? 0,
          price: getTotalWithComission(element["price"].toString()),
          categories: Categories(
              guideTour: element["guide"],
              privateTour: element["private"],
              oneDayTrip: element["one_day_trip"],
              nature: element["nature"],
              ticketMustHave: element["ticket_must_have"],
              onWater: element["on_water"],
              packageTour: element["package_tour"],
              smallGroup: element["small_group"],
              invalidFriendly: element["invalid_friendly"],
              history: element["history"],
              worldWar: element["world_war"],
              openAir: element["open_air"],
              streetArt: element["street_art"],
              adrenaline: element["adrenaline"],
              architecture: element["architecture"],
              food: element["food"],
              music: element["music"],
              forCouples: element["for_couples_activities"],
              forKids: element["for_kids_activities"],
              museum: element["museum"],
              memorial: element["memorial"],
              park: element["park"],
              gallery: element["gallery"],
              square: element["square"],
              theater: element["theater"],
              castle: element["castle"],
              towers: element["towers"],
              airports: element["airports"],
              bicycle: element["bicycle"],
              minivan: element["minivan"],
              publicTransport: element["public_transport"],
              limousine: element["limousine"],
              taxi: element["bicycle_taxi"],
              car: element["car"],
              cruise: element["cruise"],
              adventure: element["adventure"],
              fewDaysTrip: element["fewDaysTrip"],
              fishing: element["fishing"],
              game: element["game"],
              hunting: element["hunting"],
              night: element["night"],
              onlyTransfer: element["onlyTransfer"]),
          adventure: element["adventure"],
          fewDaysTrip: element["fewDaysTrip"],
          fishing: element["fishing"],
          game: element["game"],
          hunting: element["hunting"],
          night: element["night"],
          onlyTransfer: element["onlyTransfer"],
          seats: element["placesCount"] ?? null,
          duration: int.parse(element["duration"] as String),
        ),
      );
    });

    return toursList;
  }

  Future<Map<String, MiniTour>> getCustomTours(
      String localeCode, String cityIDD, String filterSuffix) async {
    String locale = "en";
    print("CITY ID BELLOW");
    print(_cityID);
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
    int sn = vn + 5;
    print(sn);
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      throw NoInternetConnection();
    }

    var url = Uri.parse(
        "$CONST_URL/tours?_city.id=$cityIDD&_locale=$locale&_approved=true$filterSuffix");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    print("TOURS GET GET BY CITY");
    print(
        "$CONST_URL/tours?_city.id=$cityIDD&_locale=$locale&_approved=true$filterSuffix");
    var data = jsonDecode(response.body) as List<dynamic>;

    Map<String, MiniTour> tempTours = {};

    data.forEach(
      (element) {
        print("CHECK TOUR WORKING GOOD BELLOW");
        print(element["price"].toString());
        tempTours.putIfAbsent(
          element["id"],
          () => MiniTour(
            tourID: element["id"],
            duration: int.parse(element["duration"] as String),
            reviews: element["reviews_count"],
            name: element["name"],
            localizations: (element['localizations'] as List<dynamic>?)
                ?.map((e) => MiniLocal(
                    id: e['id'] as String, code: e['locale'] as String))
                .toList(),
            photoURL: element["mainPhotoUrl"] ??
                "https://icons8.com/wp-content/uploads/2020/02/digital-illustration-brian-edward-miller.jpg|sdf",
            price: getTotalWithComission(element["price"].toString()),
            rating: element["rating"] ?? 0,
            category: Categories(
                guideTour: element["guide"],
                privateTour: element["private"],
                oneDayTrip: element["one_day_trip"],
                nature: element["nature"],
                ticketMustHave: element["ticket_must_have"],
                onWater: element["on_water"],
                packageTour: element["package_tour"],
                smallGroup: element["small_group"],
                invalidFriendly: element["invalid_friendly"],
                history: element["history"],
                worldWar: element["world_war"],
                openAir: element["open_air"],
                streetArt: element["street_art"],
                adrenaline: element["adrenaline"],
                architecture: element["architecture"],
                food: element["food"],
                music: element["music"],
                forCouples: element["for_couples_activities"],
                forKids: element["for_kids_activities"],
                museum: element["museum"],
                memorial: element["memorial"],
                park: element["park"],
                gallery: element["gallery"],
                square: element["square"],
                theater: element["theater"],
                castle: element["castle"],
                towers: element["towers"],
                airports: element["airports"],
                bicycle: element["bicycle"],
                minivan: element["minivan"],
                publicTransport: element["public_transport"],
                limousine: element["limousine"],
                taxi: element["bicycle_taxi"],
                car: element["car"],
                cruise: element["cruise"],
                adventure: element["adventure"],
                fewDaysTrip: element["fewDaysTrip"],
                fishing: element["fishing"],
                game: element["game"],
                hunting: element["hunting"],
                night: element["night"],
                onlyTransfer: element["onlyTransfer"]),
          ),
        );
      },
    );

    return tempTours;
  }

  void clearTours() {
    _tours = {};
    notifyListeners();
  }

  void clearCity() {
    _cityID = null;
    notifyListeners();
  }

  Future<void> getDataForCityWeather(String cityID) async {}
  Future<void> getCities(String localeCode) async {
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

    var url = Uri.parse("$CONST_URL/cities?_locale=$locale&_active=true");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      if (data.isNotEmpty && data.length > 0) {
        data.forEach((element) {
          cities.add(
            MiniCity(
                cityID: element["vid"],
                cityName: element["name"],
                flag: CONST_URL +
                    element["country"]["flag"]["formats"]["thumbnail"]["url"],
                countryName: element["country"]["name"]),
          );
        });

        filteredCities = cities;
        notifyListeners();
      }
    }
  }

  void onChanged(String value) {
    List<MiniCity> tempList = [];
    if (value.isNotEmpty) {
      for (int i = 0; i < filteredCities.length; i++) {
        if (filteredCities[i]
            .cityName
            .toLowerCase()
            .contains(value.toLowerCase())) {
          tempList.add(filteredCities[i]);
        }
      }
      filteredCities = tempList;
      notifyListeners();
    } else {
      filteredCities = cities;
      notifyListeners();
    }
  }

  void setCity(String value) {
    _cityID = value;
    notifyListeners();
  }

  Future<void> setCityIdLocaly(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("cityID", value);
    setCity(value);
  }

  String? get cityID => _cityID;

  Future<CustomCity> getCity(String localeCode) async {
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
    CustomCity customCity;

    String? city = cityID;

    if (city != null) {
      print("CITY ID BELLOW");
      print(city);
      var url = Uri.parse("$CONST_URL/cities?vid=$city&_locale=$locale");
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      );
      var data = jsonDecode(response.body) as List<dynamic>;

      customCity = CustomCity(
          name: data[0]["name"], photo: CONST_URL + data[0]["image"]["url"]);
      return customCity;
    }
    return CustomCity(name: "", photo: "");
  }

  String urlString() {
    String firstPrefix = "?id=";
    String commonPrefix = "&id=";
    if (_recentlyWatched.length == 1) {
      return "?id=" + _recentlyWatched[0];
    } else if (_recentlyWatched.length > 1) {
      String temp = firstPrefix + _recentlyWatched[0];
      for (int i = 1; i < _recentlyWatched.length; i++) {
        temp = temp + commonPrefix + _recentlyWatched[i];
      }
      return temp;
    } else {
      return firstPrefix + "dff6666666666";
    }
  }

  Future<CustomCity> getCustomCity(String cityIDD) async {
    CustomCity customCity;

    print("CHOSEN CITY BELLOW");
    print("$CONST_URL/cities/$cityIDD");

    var url = Uri.parse("$CONST_URL/cities/$cityIDD");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var data = jsonDecode(response.body) as dynamic;

    customCity =
        CustomCity(name: data["name"], photo: CONST_URL + data["image"]["url"]);
    return customCity;
  }

  Future<void> loadCityId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? temp = pref.getString("cityID");
    if (temp != null) {
      setCity(temp);
    }
    await loadRecentlyWatched();
  }

  Future<void> loadRecentlyWatched() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? rwatched = pref.getStringList("rwatched");
    if (rwatched != null) {
      UniqueList asd = UniqueList<String>();
      rwatched.forEach((element) {
        asd.add(element);
      });
      setRecentlyWatched(asd);
    }
  }

  Future<void> addToRecentlyWatched(String tourID) async {
    _recentlyWatched.add(tourID);
    notifyListeners();
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> rrr = [];
    _recentlyWatched.forEach((element) {
      rrr.add(element);
    });
    pref.setStringList("rwatched", rrr);
  }

  Future<List<MapTourItem>> getToursForMap(
      {String? cityID, required String localeCode}) async {
    if (cityID == null) {
      return [];
    }
    List<MapTourItem> temp = [];
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

    var url = Uri.parse(
        "$CONST_URL/tours?city.vid=$cityID&_locale=$locale&_approved=true");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );

    var data = jsonDecode(response.body) as List<dynamic>;
    print("MAP CHECKING YOOO");
    print(data);
    print("TOURS DATA BELLOW");
    data.forEach((element) {
      temp.add(
        MapTourItem(
            name: element["name"],
            id: element["id"],
            photo: getOnePhoto(element["image_urls"] ??
                "https://icons8.com/wp-content/uploads/2020/02/digital-illustration-brian-edward-miller.jpg|sdf"),
            latLng: getCoodinates(
              element["location_point"],
            ),
            desc: element["description"],
            price: element["price"],
            rating: element["rating"] ?? 0,
            reviews: element["reviews_count"] ?? 0),
      );
    });
    print("DISCOVER SCREEN DATA CHECK YO");
    print(temp);
    return temp;
  }

  Future<List<MapTourItem>> getToursForMap2(
      {required String localeCode}) async {
    if (cityID == null) {
      return [];
    }
    List<MapTourItem> temp = [];
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

    var url = Uri.parse("$CONST_URL/tours?locale=$locale&_approved=true");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );

    var data = jsonDecode(response.body) as List<dynamic>;
    print("MAP CHECKING YOOO");
    print(data);
    print("TOURS DATA BELLOW");
    data.forEach((element) {
      if (element["location_point"] != null ||
          (element["location_point"] as String).isNotEmpty) {
        temp.add(
          MapTourItem(
              name: element["name"],
              id: element["id"],
              photo: getOnePhoto(element["image_urls"] ??
                  "https://icons8.com/wp-content/uploads/2020/02/digital-illustration-brian-edward-miller.jpg|sdf"),
              latLng: getCoodinates(
                element["location_point"],
              ),
              desc: element["description"],
              price: element["price"].toDouble(),
              rating: element["rating"] ?? 0,
              reviews: element["reviews_count"] ?? 0),
        );
      }
    });
    print("DISCOVER SCREEN DATA CHECK YO");
    print(temp);
    return temp;
  }

  LatLng getCoodinates(String? value) {
    if (value != null) {
      List<String> s = value.split("|");
      return LatLng(double.parse(s[0]), double.parse(s[1]));
    } else {
      return LatLng(0, 0);
    }
  }

  String getOnePhoto(String? imageUrls) {
    String returnImage =
        "https://icons8.com/wp-content/uploads/2020/02/digital-illustration-brian-edward-miller.jpg";
    if (imageUrls != null) {
      List<String?> temp = [];
      temp = imageUrls.split("|");
      temp.forEach((element) {
        if (element != null) {
          returnImage = element;
        }
      });
    }
    return returnImage;
  }
}

class MiniCity with ChangeNotifier {
  final String cityID;
  final String cityName;
  final String flag;
  final String countryName;

  MiniCity(
      {required this.cityID,
      required this.cityName,
      required this.flag,
      required this.countryName});
}

class CustomCity {
  final String name;
  final String photo;

  CustomCity({required this.name, required this.photo});
}

class MiniLocal {
  final String id;
  final String code;

  MiniLocal({required this.id, required this.code});
}

class CityWeather {
  final double temperature;
  final String fallout;

  CityWeather({required this.temperature, required this.fallout});
}
