import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:vip_tourist/logic/models/add_tour.dart';
import 'package:vip_tourist/logic/models/categories.dart';

import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/tour_addition_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:http/http.dart' as http;

class OfferEditProvider with ChangeNotifier {
  final AuthProvider authData;
  OfferEditProvider({required this.authData});

  List<String> _urls = [];

  List<String> get urls => _urls;

  void setUrls(List<String> value) {
    _urls = value;
    notifyListeners();
  }

  Categories? _categories;
  AddTour _tour = AddTour.empty;
  // AddOffer _offer = AddOffer.empty;

  // AddOffer get offer => _offer;
  AddTour get tour => _tour;
  Categories? get categories => _categories;
  void setCategories(Categories value) {
    _categories = value;
    notifyListeners();
  }

  Future<void> getTourDetails(String tourID) async {
    String? id = authData.user.id;
    if (id != null) {
      var url = Uri.parse("$CONST_URL/tours/$tourID");
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      );
      var clearBody = jsonDecode(response.body) as dynamic;

      setTour(
        AddTour(
            seats: clearBody["placesCount"].toString(),
            description: clearBody["description"],
            name: clearBody["name"],
            withTransfer: clearBody["withTransfer"],
            duration: clearBody["duration"],
            dateTime: clearBody["date"],
            adultPrice: clearBody["price"].toString(),
            meetingPoint: clearBody["location_point"],
            alwaysAvailable: clearBody["alwaysAvailable"],
            transfer: clearBody["withTransfer"] ?? false,
            childPrice: clearBody["child_price"].toString(),
            included: clearBody["included"],
            languages: clearBody["languages"],
            notIncluded: clearBody["not_included"],
            note: clearBody["note"],
            prerequisites: clearBody["prerequisites"],
            prohibitions: clearBody["prohibitions"],
            urls: clearBody["image_urls"],
            mainPhotoUrl: clearBody["mainPhotoUrl"],
            transferPhotoUrl: clearBody["transferPhotoUrl"] as String?,
            freeTicketNote: clearBody["freeTicketNotice"] as String?,
            days: clearBody["weekDays"] as String?,
            time: clearBody["startTime"] as String?),
      );
      setCategories(
        Categories(
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
          onlyTransfer: clearBody["onlyTransfer"],
        ),
      );
      setUrls(getObjects(value: clearBody["image_urls"].toString()));
    }
  }

  Future<String?> uploadCarPhoto(
      bool withTransfer, File? fail, String? path) async {
    if (withTransfer) {
      if (fail != null &&
          !path!.contains("http://res.cloudinary.com/space-developers")) {
        String? dd = await addCarPhoto(fail.path);
        return dd;
      } else if (path != null &&
          path.contains("http://res.cloudinary.com/space-developers")) {
        return path;
      } else {
        throw NoCarPhotoSelectedException();
      }
    }
    return null;
  }

  Future<String?> addCarPhoto(String pth) async {
    String? url;
    print("works here?");
    final data =
        Cloudinary(CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET, CLOUD_NAME);

    CloudinaryResponse response = await data.uploadFile(
      filePath: pth,
      resourceType: CloudinaryResourceType.image,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202 ||
        response.statusCode == 203) {
      url = response.url;
    }
    return url;
  }

  Future<void> updateTour({
    required AddTour addTour,
    required String tourID,
    required Map<String, String> categories,
  }) async {
    print("TOUR UPDATE CHECK YO~!");
    print(tourID);
    var url = Uri.parse("$CONST_URL/tours/$tourID");
    Map<String, dynamic> temp = {
      "name": addTour.name,
      "description": addTour.description,
      "languages": addTour.languages,
      "alwaysAvailable": addTour.alwaysAvailable,
      "withTransfer": addTour.transfer,
      "price": addTour.adultPrice.toString(),
      "duration": addTour.duration,
      "date": addTour.dateTime,
      "prohibitions": addTour.prohibitions ?? "",
      "prerequisites": addTour.prerequisites ?? "",
      "included": addTour.included ?? "",
      "not_included": addTour.notIncluded ?? "",
      "meeting_point": addTour.meetingPoint,
      "note": addTour.note,
      "image_urls": addTour.urls ?? "",
      "placesCount": addTour.seats,
      "mainPhotoUrl": addTour.mainPhotoUrl,
      "approved": false,
      "tourUpdated": true
    };
    var request = http.Request("PUT", url);
    request.headers.addAll(
        {"Accept": "application/json", "content-type": "application/json"});
    temp.addAll(categories);
    if (addTour.transferPhotoUrl != null) {
      temp.addAll({"transferPhotoUrl": addTour.transferPhotoUrl});
    }
    if (addTour.time != null) {
      temp.addAll({"startTime": addTour.time!});
    }
    if (addTour.days != null) {
      temp.addAll({"weekDays": addTour.days!});
    }
    if (addTour.freeTicketNote != null) {
      temp.addAll({"freeTicketNotice": addTour.freeTicketNote!});
    }

    try {
      var ghj = double.parse(addTour.childPrice!);
      temp.addAll({"child_price": addTour.childPrice});
      print("CHILD PRICE ADDED SUCCESSFULLY!!!");
    } catch (e) {
      print("CHILD PRICE IS NOT ADDED, ERROR CATCHED!");
    }

    request.body = jsonEncode(temp);
    var response = await request.send();
    var vvv = await response.stream.bytesToString();
    print("OFFER EDIT RESULT");
    print(vvv);
  }

  Future<List<CustomOffer>> getToursList(
      String localeCode, String postfix) async {
    String? id = authData.user.id;
    String locale;
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
    List<CustomOffer> temp = [];
    if (id != null) {
      var url =
          Uri.parse("$CONST_URL/tours?profile=$id&_locale=$locale$postfix");
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      );

      if (response.statusCode != 200) {
        return [];
      }
      var data = jsonDecode(response.body) as List<dynamic>;
      print("MY TOYR FOR EDIT LIST");
      print("$CONST_URL/tours?profile=$id&_locale=$locale$postfix");
      data.forEach(
        (element) {
          if (element["remark"] == null) {
            temp.add(
              CustomOffer(
                tourName: element["name"],
                approved: element["approved"],
                price: getSubtitle(
                    price: getTotalWithComission(element["price"].toString())),
                description: element["description"],
                tourID: element["id"],
                photo: element["mainPhotoUrl"],
              ),
            );
          } else {
            temp.add(
              CustomOffer(
                tourName: element["name"],
                approved: element["approved"],
                price: getSubtitle(
                    price: getTotalWithComission(element["price"].toString())),
                remarkTitle: element["remark"]["title"],
                remarkBody: element["remark"]["remark"],
                tourID: element["id"],
                description: element["description"],
                photo: element["mainPhotoUrl"],
              ),
            );
          }
          print("WORKING HERE BLYAT>>???");
          print(temp);
        },
      );
    }
    return temp;
  }

  String getTotalWithComission(String value) {
    double val;

    try {
      val = double.parse(value);
    } catch (e) {
      return "0.0";
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

    return val.toString();
  }
  // void setOffer(AddOffer value) {
  //   _offer = value;
  //   notifyListeners();
  // }

  // void disposeOffer() {
  //   _offer = AddOffer.empty;

  //   notifyListeners();
  // }
  void setTour(AddTour value) {
    _tour = value;
    notifyListeners();
  }

  void disposeTour() {
    _tour = AddTour.empty;
    _categories = null;
    notifyListeners();
  }

  List<String> getObjects({required String value}) {
    if (value.isEmpty) {
      return [];
    } else {
      List<String> objs = value.split('|');
      return objs;
    }
  }

  String getOnePhoto(String value) {
    List<String> t = value.split("|");
    return t[0];
  }

  String getSubtitle({required String price}) {
    return "\$ " + price;
  }

  String fromListToString(String value) {
    List<String> f = value.split("|");
    String s = f.join(', ');
    return s;
  }

  Future<void> getCityRequests() async {}
}

class CustomOffer {
  final String? photo;
  final String tourName;
  final String description;
  final String price;
  final String tourID;
  final String? remarkTitle;
  final String? remarkBody;
  final bool approved;

  CustomOffer(
      {this.photo,
      required this.tourName,
      required this.description,
      required this.price,
      required this.tourID,
      required this.approved,
      this.remarkTitle,
      this.remarkBody});
}
