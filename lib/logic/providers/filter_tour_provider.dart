import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vip_tourist/logic/models/categories.dart';
import 'package:vip_tourist/logic/utility/constants.dart';

class FilterTourProvider with ChangeNotifier {
  Future<CityTour> getSuggestions(
      {required String value, required String localeCode}) async {
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
        "$CONST_URL/tours?name_contains=$value&_locale=$locale&_approved=true");
    var url2 =
        Uri.parse("$CONST_URL/cities?name_contains=$value&_locale=$locale");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var response2 = await http.get(
      url2,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var toursData = jsonDecode(response.body) as List<dynamic>;
    var citiesData = jsonDecode(response2.body) as List<dynamic>;
    List<TempTour> tempList = [];
    List<TempCity> tempList2 = [];

    toursData.forEach((element) {
      tempList.add(TempTour(
          tourID: element["id"],
          tourName: element["name"],
          tourVID: element["vid"]));
    });
    citiesData.forEach((element) {
      tempList2.add(TempCity(
          cityID: element["id"],
          cityName: element["name"],
          cityVID: element["id"]));
    });
    print("CITIES BEELLLOW!");
    print(tempList2);
    return CityTour(tours: tempList, cities: tempList2);
  }

  Future<List<TempCatalogTour>> getToursPerCityForCatalog(
      {required String cityID,
      required String localeCode,
      String? sort,
      String? filter}) async {
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

    var url;
    if (sort == null && filter == null) {
      url = Uri.parse(
          "$CONST_URL/tours?city.id=$cityID&_locale=$locale&_approved=true");
    } else if (sort == null && filter != null) {
      url = Uri.parse(
          "$CONST_URL/tours?city.id=$cityID&_locale=$locale$filter&_approved=true");
    } else if (sort != null && filter == null) {
      url = Uri.parse(
          "$CONST_URL/tours?city.id=$cityID&_locale=$locale$sort&_approved=true");
    } else {
      url = Uri.parse(
          "$CONST_URL/tours?city.id=$cityID&_locale=$locale$sort$filter&_approved=true");
    }

    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var data = jsonDecode(response.body) as List<dynamic>;

    List<TempCatalogTour> toursList = [];
    data.forEach((element) {
      toursList.add(
        TempCatalogTour(
            duration: int.parse(element["duration"] as String),
            tourID: element["id"],
            reviews: element["reviews_count"],
            name: element["name"],
            isTopTour: element["top"],
            image: element["mainPhotoUrl"],
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
              onlyTransfer: element["onlyTransfer"],
            ),
            adventure: element["adventure"],
            fewDaysTrip: element["fewDaysTrip"],
            fishing: element["fishing"],
            game: element["game"],
            hunting: element["hunting"],
            night: element["night"],
            onlyTransfer: element["onlyTransfer"],
            seats: element["seats"]),
      );
    });

    return toursList;
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

  Future<List<TempCatalogTour>> getEmptyList() async {
    List<TempCatalogTour> list = [];
    return list;
  }

  Future<List<TempCatalogTour>> getToursByDate(
      {required String cityID,
      required String localeCode,
      required String date,
      String? sort,
      String? filter}) async {
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
        "$CONST_URL/tours?date_gte=${date}T00:01:00.000Z&_date_lte=${date}T23:59:00.000Z&_locale=$locale");

    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var data = jsonDecode(response.body) as List<dynamic>;
    print("DOING RIGHT??");
    print(data);

    List<TempCatalogTour> toursList = [];
    data.forEach((element) {
      toursList.add(
        TempCatalogTour(
            duration: int.parse(element["duration"] as String),
            tourID: element["id"],
            reviews: element["reviews_count"],
            name: element["name"],
            isTopTour: element["top"],
            image: element["mainPhotoUrl"],
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
              onlyTransfer: element["onlyTransfer"],
            ),
            adventure: element["adventure"],
            fewDaysTrip: element["fewDaysTrip"],
            fishing: element["fishing"],
            game: element["game"],
            hunting: element["hunting"],
            night: element["night"],
            onlyTransfer: element["onlyTransfer"],
            seats: element["seats"]),
      );
    });

    return toursList;
  }

  Future<List<TempCatalogTour>> getToursByValue(
      {required String value, required String localeCode}) async {
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
        "$CONST_URL/tours?name_contains=$value&_locale=$locale&_approved=true");
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
            duration: int.parse(element["duration"] as String),
            tourID: element["id"],
            reviews: element["reviews_count"],
            name: element["name"],
            isTopTour: element["top"],
            image: element["mainPhotoUrl"],
            rating: element["rating"],
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
            seats: element["seats"]),
      );
    });

    return toursList;
  }

  String getOnePhoto(String value) {
    List<String> temp = [];
    temp = value.split("|");
    return temp[0];
  }

  // Future<List<TempCatalogTour>> getToursByDate(
  //     {required String cityID,
  //     required String localeCode,
  //     required DateTime date,
  //     String? filter,
  //     String? sort}) async {
  //   String locale = "en";
  //   if (localeCode.contains("en")) {
  //     locale = "en";
  //   } else if (localeCode.contains(localeCode)) {
  //     locale = "ru-RU";
  //   }

  //   var url;
  //   if (sort == null && filter == null) {
  //     url = Uri.parse("$CONST_URL/tours?city.vid=$cityID&_locale=$locale");
  //   } else if (sort == null && filter != null) {
  //     url =
  //         Uri.parse("$CONST_URL/tours?city.vid=$cityID&_locale=$locale$filter");
  //   } else if (sort != null && filter == null) {
  //     url = Uri.parse("$CONST_URL/tours?city.vid=$cityID&_locale=$locale$sort");
  //   } else {
  //     url = Uri.parse(
  //         "$CONST_URL/tours?city.vid=$cityID&_locale=$locale$sort$filter");
  //   }
  // }
}

class TempCatalogTour {
  final String tourID;
  final String image;
  final bool isTopTour;
  final String name;
  final int rating;
  final int reviews; //quantity
  final double price;
  final Categories categories;
  final bool hunting;
  final bool adventure;
  final bool fishing;
  final bool night;
  final bool game;
  final bool onlyTransfer;
  final bool fewDaysTrip;
  final int? seats;
  final bool? withTransfer;
  final int duration;
  const TempCatalogTour(
      {required this.tourID,
      required this.image,
      required this.isTopTour,
      required this.name,
      required this.rating,
      required this.reviews,
      required this.price,
      required this.categories,
      required this.hunting,
      required this.adventure,
      required this.fishing,
      required this.night,
      required this.game,
      required this.onlyTransfer,
      required this.fewDaysTrip,
      required this.seats,
      this.withTransfer,
      required this.duration});
}

class TempTour {
  final String tourID;
  final String tourVID;
  final String tourName;

  TempTour(
      {required this.tourID, required this.tourName, required this.tourVID});
}

class TempCity {
  final String cityID;
  final String cityVID;
  final String cityName;

  TempCity(
      {required this.cityID, required this.cityName, required this.cityVID});
}

class CityTour {
  final List<TempTour> tours;
  final List<TempCity> cities;

  CityTour({required this.tours, required this.cities});
}
