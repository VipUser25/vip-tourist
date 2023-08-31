import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vip_tourist/logic/models/categories.dart';

import 'package:vip_tourist/logic/models/review.dart';
import 'package:vip_tourist/logic/models/tour.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:translator/translator.dart';

class DetailTourProvider with ChangeNotifier {
  Tour _tour = Tour.empty;

  List<Review> _reviews = [];
  List<Review> _tranlations = [];
  bool _loaded = false;

  List<Review> get tranlations => _tranlations;
  void setTranlations(List<Review> value) {
    _tranlations = value;
    notifyListeners();
  }

  int _adults = 1;
  int _children = 0;

  int get adults => _adults;
  int get children => _children;

  void incrementAdult() {
    _adults += 1;
    notifyListeners();
  }

  void decrementAdult() {
    if (_adults > 0) {
      _adults = _adults - 1;
      notifyListeners();
    } else {
      return;
    }
  }

  void incrementChild() {
    _children += 1;
    notifyListeners();
  }

  void decrementChild() {
    if (_children > 0) {
      _children = _children - 1;
      notifyListeners();
    } else {
      return;
    }
  }

  Tour get tour => _tour;
  bool get loaded => _loaded;

  List<Review> get reviews => _reviews;

  void setLoaded(bool value) {
    _loaded = value;
    notifyListeners();
  }

  void setTour(Tour tour) {
    _tour = tour;
    notifyListeners();
  }

  void setReviews(List<Review> value) {
    _reviews = value;
    notifyListeners();
  }

  Future<void> translate(String localeCode) async {
    final translator = GoogleTranslator(client: ClientType.extensionGT);
    List<Review> temp = _reviews;
    List<Review> anotherTemp = [];

    for (var i = 0; i < temp.length; i++) {
      Translation comment =
          await translator.translate(temp[i].messageBody, to: localeCode);
      anotherTemp.add(Review(
          commentDate: temp[i].commentDate,
          reviewID: temp[i].reviewID,
          userPhoto: temp[i].userPhoto,
          userRating: temp[i].userRating,
          username: temp[i].username,
          messageBody: comment.text));
    }
    setTranlations(anotherTemp);
  }

  void reset() {
    _tranlations = reviews;
    notifyListeners();
  }

  double getTotalAmount() {
    if (tour.childPrice == null) {
      return tour.price * adults;
    } else {
      return (tour.price * adults) + (tour.childPrice! * children);
    }
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

  Future<void> getTourDetails(String id) async {
    var url = Uri.parse("$CONST_URL/tours/$id");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );

    var reviewUrl = Uri.parse("$CONST_URL/reviews?tour.id=$id");
    var reviewsResponse = await http.get(
      reviewUrl,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );

    var data = jsonDecode(response.body) as dynamic;
    var clearBody = data;

    var reviewsData = jsonDecode(reviewsResponse.body) as List<dynamic>;

    print('WORKS HERE>???');
    print(clearBody);
    List<Review> tempReview = [];

    setTour(
      Tour(
          seats: clearBody["placesCount"],
          price: getTotalWithComission((clearBody["price"] as int).toString()),
          photos: getObjects(value: clearBody["image_urls"] ?? ""),
          alwaysAvailable: clearBody["alwaysAvailable"] as bool,
          meetingPoint: getCoordinates(clearBody["location_point"] as String?),
          withTransfer: clearBody["withTransfer"] as bool,
          transferPhotoUrl: clearBody["transferPhotoUrl"] as String?,
          country:
              "Kazakhstan", /////////////////////////////////////////////////MUST BE REBUILD
          tourID: clearBody["id"],
          name: clearBody["name"],
          description: clearBody["description"],
          categories: Categories(
              guideTour: clearBody["guide"],
              privateTour: clearBody["private"],
              oneDayTrip: clearBody["one_day_trip"],
              nature: clearBody["nature"],
              ticketMustHave: clearBody["ticket_must_have"],
              onWater: clearBody["on_water"],
              packageTour: clearBody["package_tour"],
              smallGroup: clearBody["small_group"],
              invalidFriendly: clearBody["invalid_friendly"],
              history: clearBody["history"],
              worldWar: clearBody["world_war"],
              openAir: clearBody["open_air"],
              streetArt: clearBody["street_art"],
              adrenaline: clearBody["adrenaline"],
              architecture: clearBody["architecture"],
              food: clearBody["food"],
              music: clearBody["music"],
              forCouples: clearBody["for_couples_activities"],
              forKids: clearBody["for_kids_activities"],
              museum: clearBody["museum"],
              memorial: clearBody["memorial"],
              park: clearBody["park"],
              gallery: clearBody["gallery"],
              square: clearBody["square"],
              theater: clearBody["theater"],
              castle: clearBody["castle"],
              towers: clearBody["towers"],
              airports: clearBody["airports"],
              bicycle: clearBody["bicycle"],
              minivan: clearBody["minivan"],
              publicTransport: clearBody["public_transport"],
              limousine: clearBody["limousine"],
              taxi: clearBody["bicycle_taxi"],
              car: clearBody["car"],
              cruise: clearBody["cruise"],
              adventure: clearBody["adventure"],
              fewDaysTrip: clearBody["fewDaysTrip"],
              fishing: clearBody["fishing"],
              game: clearBody["game"],
              hunting: clearBody["hunting"],
              night: clearBody["night"],
              onlyTransfer: clearBody["onlyTransfer"]),
          duration: getDuration(clearBody["duration"] as String?),
          cityId: clearBody["city"]["id"] as String?,
          cityName: clearBody["city"]["name"] as String?,
          rating: clearBody["rating"] ?? 0,
          date: getDate(clearBody["date"] as String?),
          time: getTime(clearBody["startTime"] as String?),
          languages: getObjects(value: clearBody["languages"]),
          childPrice:
              getTotalWithComissionNull(clearBody["child_price"] as double?),
          top: clearBody["top"] ?? false,
          included: clearBody["included"] as String?,
          notIncluded: clearBody["not_included"] as String?,
          prerequisites: clearBody["prerequisites"] as String?,
          prohibitions: clearBody["prohibitions"] as String?,
          note: clearBody["note"],
          userID: clearBody["profile"]["id"],
          userName: clearBody["profile"]["name"],
          userPhoto: clearBody["profile"]["photo_url"],
          freeTicketNotice: clearBody["freeTicketNotice"] as String?,
          weekDays: clearBody["weekDays"] as String?),
    );
    if (reviewsData.isNotEmpty) {
      reviewsData.forEach((element) {
        tempReview.add(Review(
            reviewID: element["id"] ?? "",
            username: element["name"] ?? "",
            userRating: element["rating"] ?? 0,
            messageBody: element["text"] ?? "",
            commentDate: DateTime.parse(element["createdAt"]),
            userPhoto: element["profile"]["photo_url"] ?? ""));
      });
    }

    setReviews(tempReview);
    setLoaded(true);
    notifyListeners();
  }

  String? getTime(String? value) {
    if (value != null) {
      return value.substring(0, 5);
    }
    return null;
  }

  double? getTotalWithComissionNull(double? value) {
    if (value != null) {
      double val = value;
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
    return null;
  }

  double? getChildPrice(String? value) {
    if (value != null) {
      if (value.isNotEmpty) {
        return double.parse(value);
      }
    }
    return null;
  }

  int? getDuration(String? value) {
    if (value != null) {
      return int.parse(value);
    }
    return null;
  }

  void disposeTour() {
    _tour = Tour.empty;
    _loaded = false;

    _reviews = [];
    _adults = 1;
    _children = 0;
    notifyListeners();
  }

  DateTime? getDate(String? value) {
    if (value != null) {
      return DateTime.parse(value);
    }
    return null;
  }

  List<String> getObjects({required String value}) {
    if (value.isEmpty || value == "") {
      return [];
    } else {
      List<String> returnList = [];
      List<String?> objs = value.split('|');
      objs.forEach((element) {
        if (element != null || !element!.contains("http")) {
          returnList.add(element);
        }
      });
      return returnList;
    }
  }

  LatLng? getCoordinates(String? value) {
    if (value != null) {
      if (value.isNotEmpty) {
        List<String> objs = value.split('|');
        return LatLng(double.parse(objs[0]), double.parse(objs[1]));
      }
    }
    return null;
  }
}
