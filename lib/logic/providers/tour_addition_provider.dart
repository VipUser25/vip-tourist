import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vip_tourist/logic/models/add_tour.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:http/http.dart' as http;

class TourAdditionProvider with ChangeNotifier {
  AddTourLocalSave localData = AddTourLocalSave();
  TourAdditionProvider();
  Future<void> loadSaved() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? name = pref.getString("ld_name");
    String? description = pref.getString("ld_description");
    String? hours = pref.getString("ld_hours");
    String? languages = pref.getString("ld_languages");
    String? adultPrice = pref.getString("ld_adultPrice");
    String? childPrice = pref.getString("ld_childPrice");
    bool? alwaysAvailable = pref.getBool("ld_alwaysAvailable");
    String? date = pref.getString("ld_date");
    String? time = pref.getString("ld_time");
    bool? withTransfer = pref.getBool("ld_withTransfer");
    String? transferPrice = pref.getString("ld_transferPrice");
    bool? withFood = pref.getBool("ld_withFood");
    String? foods = pref.getString("ld_foods");
    String? prereq = pref.getString("ld_prereq");
    String? seats = pref.getString("ld_seats");
    String? included = pref.getString("ld_included");
    String? notIncluded = pref.getString("ld_notIncluded");
    String? freeTicket = pref.getString("ld_freeTicket");
    String? prohibs = pref.getString("ld_prohibs");
    String? info = pref.getString("ld_info");
    String? meetingPoint = pref.getString("ld_meetingPoint");
    String? cityID = pref.getString("ld_cityID");
    List<String>? filePaths = pref.getStringList("ld_filePaths");
    localData = AddTourLocalSave(
        adultPrice: adultPrice,
        alwaysAvailable: alwaysAvailable,
        childPrice: childPrice,
        date: date,
        description: description,
        foods: foods,
        hours: hours,
        cityID: cityID,
        included: included,
        info: info,
        languages: languages,
        meetingPoint: meetingPoint,
        name: name,
        notIncluded: notIncluded,
        prereq: prereq,
        prohibs: prohibs,
        transferPrice: transferPrice,
        withFood: withFood,
        withTransfer: withTransfer,
        filePaths: filePaths,
        seats: seats,
        time: time,
        freeTicket: freeTicket);
    notifyListeners();
  }

  Future<void> saveLocaly({required AddTourLocalSave data}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (data.filePaths != null) {
      pref.setStringList("ld_filePaths", data.filePaths!);
    }
    if (data.name != null) {
      pref.setString("ld_name", data.name!);
    }
    if (data.cityID != null) {
      pref.setString("ld_cityID", data.cityID!);
    }
    if (data.description != null) {
      pref.setString("ld_description", data.description!);
    }
    if (data.hours != null) {
      pref.setString("ld_hours", data.hours!);
    }
    if (data.seats != null) {
      pref.setString("ld_seats", data.seats!);
    }
    if (data.languages != null) {
      pref.setString("ld_languages", data.languages!);
    }
    if (data.adultPrice != null) {
      pref.setString("ld_adultPrice", data.adultPrice!);
    }
    if (data.childPrice != null) {
      pref.setString("ld_childPrice", data.childPrice!);
    }
    if (data.alwaysAvailable != null) {
      pref.setBool("ld_alwaysAvailable", data.alwaysAvailable!);
    }
    if (data.date != null) {
      pref.setString("ld_date", data.date!);
    }
    if (data.freeTicket != null) {
      pref.setString("ld_freeTicket", data.date!);
    }
    if (data.time != null) {
      pref.setString("ld_time", data.time!);
    }
    if (data.withTransfer != null) {
      pref.setBool("ld_withTransfer", data.withTransfer!);
    }
    if (data.transferPrice != null) {
      pref.setString("ld_transferPrice", data.transferPrice!);
    }
    if (data.withFood != null) {
      pref.setBool("ld_withFood", data.withFood!);
    }
    if (data.foods != null) {
      pref.setString("ld_foods", data.foods!);
    }
    if (data.prereq != null) {
      pref.setString("ld_prereq", data.prereq!);
    }
    if (data.included != null) {
      pref.setString("ld_included", data.included!);
    }
    if (data.notIncluded != null) {
      pref.setString("ld_notIncluded", data.notIncluded!);
    }
    if (data.prohibs != null) {
      pref.setString("ld_prohibs", data.prohibs!);
    }
    if (data.info != null) {
      pref.setString("ld_info", data.info!);
    }
    if (data.meetingPoint != null) {
      pref.setString("ld_meetingPoint", data.meetingPoint!);
    }
    localData = data;
    notifyListeners();
  }

  Future<void> clearLocaly() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString("ld_name", "");

    pref.setString("ld_description", "");

    pref.setString("ld_hours", "");

    pref.setString("ld_languages", "");

    pref.setString("ld_cityID", "");

    pref.setString("ld_adultPrice", "");

    pref.setString("ld_childPrice", "");

    pref.setString("ld_freeTicket", "");

    pref.setBool("ld_alwaysAvailable", false);

    pref.setString("ld_date", "");

    pref.setString("ld_time", "");

    pref.setBool("ld_withTransfer", false);

    pref.setString("ld_transferPrice", "");

    pref.setBool("ld_withFood", false);

    pref.setString("ld_foods", "");

    pref.setString("ld_prereq", "");

    pref.setString("ld_included", "");

    pref.setString("ld_notIncluded", "");

    pref.setString("ld_prohibs", "");

    pref.setString("ld_info", "");

    pref.setString("ld_meetingPoint", "");

    pref.setString("ld_seats", "");

    localData = AddTourLocalSave();
    notifyListeners();
  }

  Future<bool> addTour({
    required AddTour tourDetails,
    required Map<String, String> categories,
    required String cityIDD,
    required String userIDD,
    required String localeCode,
    required int seats,
    String? carPhotoUrl,
  }) async {
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
    bool res = false;
    var url = Uri.parse("$CONST_URL/tours/");
    Map<String, dynamic> temp = {
      "name": tourDetails.name,
      "description": tourDetails.description,
      "city": getCity(cityIDD),
      "languages": tourDetails.languages,
      "profile": userIDD,
      "createdLanguage": locale,
      "locale":locale,
      "alwaysAvailable": tourDetails.alwaysAvailable.toString(),
      "approved": "false",
      "placesCount": seats.toString(),
      "translationApproved": "false",
      "withTransfer": tourDetails.withTransfer,
      "price": tourDetails.adultPrice.toString(),
      "duration": tourDetails.duration,
      "prohibitions": tourDetails.prohibitions ?? "",
      "prerequisites": tourDetails.prerequisites ?? "",
      "included": tourDetails.included ?? "",
      "not_included": tourDetails.notIncluded ?? "",
      "image_urls": tourDetails.urls ?? "",
      "mainPhotoUrl": tourDetails.mainPhotoUrl
    };
    var request = http.Request("POST", url);
    request.headers.addAll(
        {"Accept": "application/json", "content-type": "application/json"});
    temp.addAll(categories);
    if (tourDetails.dateTime != null) {
      temp.addAll({"date": tourDetails.dateTime!});
    }
    if (tourDetails.meetingPoint != null) {
      temp.addAll({"location_point": tourDetails.meetingPoint!});
    }
    if (tourDetails.note != null) {
      temp.addAll({"note": tourDetails.note!});
    }
    if (carPhotoUrl != null) {
      temp.addAll({"transferPhotoUrl": carPhotoUrl});
    }
    if (tourDetails.time != null) {
      temp.addAll({"startTime": tourDetails.time!});
    }
    if (tourDetails.days != null) {
      temp.addAll({"weekDays": tourDetails.days!});
    }
    if (tourDetails.freeTicketNote != null) {
      temp.addAll({"freeTicketNotice": tourDetails.freeTicketNote!});
    }
    if (tourDetails.childPrice != null) {
      temp.addAll({"child_price": tourDetails.childPrice});
    }
    request.body = jsonEncode(temp);
    var response = await request.send();
    var vvv = await response.stream.bytesToString();

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202 ||
        response.statusCode == 203) {
      res = true;
    }
    print("IS EVERYTHIN FINE??");
    print(response.statusCode);
    print(jsonDecode(vvv));

    return res;
  }

  String getCity(String? cityID) {
    if (cityID != null) {
      if (cityID.isNotEmpty) {
        return cityID;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  Future<CustomPhotoError> addPhotos(List<String> list) async {
    if (list.isNotEmpty) {
      print("works here?");
      final data =
          Cloudinary(CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET, CLOUD_NAME);

      List<CloudinaryResponse> responses = await data.uploadFiles(
        filePaths: list,
        resourceType: CloudinaryResourceType.image,
      );
      List<String> paths = [];
      bool noError = true;
      responses.forEach((element) {
        if (element.statusCode == 200) {
          paths.add(element.url!);
        } else {
          noError = false;
        }
      });
      return CustomPhotoError(urls: paths, noError: noError);
    } else {
      return CustomPhotoError(urls: [], noError: false);
    }
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

  Future<String?> uploadCarPhoto(bool withTransfer, File? fail) async {
    if (withTransfer) {
      if (fail != null) {
        String? dd = await addCarPhoto(fail.path);
        return dd;
      } else {
        throw NoCarPhotoSelectedException();
      }
    }
    return null;
  }

  Future<void> addTEST() async {
    var url = Uri.parse("$CONST_URL/tours/");
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
        {"name": "TOUR TEST NAME", "description": "DESC"},
      ),
    );

    print('TOUR ADDITION BODY BELLOW');
    var body = jsonDecode(response.body);
    print(body["id"]);
  }

  Future<void> testPOST() async {
    Map<String, String> fff = {
      "guide": "true",
      "top": "true",
      "private": "true",
      "name": "KEK LOL WORKS"
    };
    var url = Uri.parse("$CONST_URL/tours/");

    var request = http.Request(
      "POST",
      url,
    );
    request.body = jsonEncode(fff);
    request.headers.addAll(
        {"Accept": "application/json", "content-type": "application/json"});
    var response = await request.send();
    print(response.statusCode);
  }

  Future<Map<String, List<MiniCity>>> getCities(
      {required String localeCode, String? text, required int n}) async {
    Map<String, List<MiniCity>> gen = {};
    List<MiniCity> temp = [];
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
        "$CONST_URL/cities?name_contains=$text&_locale=$locale&_active=true&_limit=$n");
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
        data.forEach(
          (element) {
            try {
              temp.add(MiniCity(
                  cityID: element["id"],
                  cityName: element["name"],
                  flag: CONST_URL +
                      element["country"]["flag"]["formats"]["thumbnail"]["url"],
                  countryName: element["country"]["name"]));
              // );
            } catch (e) {}
          },
        );
        gen = getNeededMap(temp);
        gen.forEach((key, value) {
          print(key + ": ");
          value.forEach((element) {
            print("   " + element.cityName);
          });
        });
      }
    }
    return gen;
  }

  Map<String, List<MiniCity>> getNeededMap(List<MiniCity> list) {
    Map<String, List<MiniCity>> gen = {};

    for (var i = 0; i < list.length; i++) {
      if (!gen.containsKey(list[i].cityName[0].toUpperCase())) {
        gen.putIfAbsent(list[i].cityName[0].toUpperCase(), () => [list[i]]);
      } else {
        List<MiniCity> tt = gen[list[i].cityName[0].toUpperCase()]!;
        tt.add(list[i]);
        gen.update(list[i].cityName[0].toUpperCase(), (value) => tt);
      }
    }

    return gen;
  }

  Future<Map<String, TourCityMix>> getCitiesAndTours(
      {required String localeCode, String? text}) async {
    Map<String, TourCityMix> temp = {};

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
    var cityUrl = Uri.parse(
        "$CONST_URL/cities?name_contains=$text&_locale=$locale&_active=true");
    var cityResponse = await http.get(
      cityUrl,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var tourUrl = Uri.parse(
        "$CONST_URL/tours?name_contains=$text&_locale=$locale&_approved=true");
    var tourResponse = await http.get(
      tourUrl,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (cityResponse.statusCode == 200) {
      final data = jsonDecode(cityResponse.body) as List<dynamic>;
      data.forEach(
        (element) {
          try {
            var tempList = element["tours"] as List<dynamic>;
            if (tempList.isNotEmpty || tempList.length > 1) {
              tempList.forEach(
                (element2) {
                  temp.putIfAbsent(
                      element2["id"],
                      () => TourCityMix(
                          cityID: element["id"],
                          cityName: element["name"],
                          tourName: element2["name"]));
                },
              );
            }
          } catch (e) {}
        },
      );
    }
    if (tourResponse.statusCode == 200) {
      final data = jsonDecode(tourResponse.body) as List<dynamic>;
      data.forEach(
        (element) {
          try {
            temp.putIfAbsent(
              element["id"],
              () => TourCityMix(
                  cityID: element["city"]["id"],
                  cityName: element["city"]["name"],
                  tourName: element["name"]),
            );
          } catch (e) {}
        },
      );
    }
    return temp;
  }
}

class TourCityMix {
  final String cityID;
  final String cityName;

  final String tourName;

  TourCityMix(
      {required this.cityID, required this.cityName, required this.tourName});
}

class CustomPhotoError {
  final List<String> urls;
  final bool noError;

  CustomPhotoError({required this.urls, required this.noError});
}

class CustomResponseF {
  final String tourIDD;
  final bool noError;

  CustomResponseF({required this.tourIDD, required this.noError});
}

class AddTourLocalSave {
  String? cityID;
  String? name;
  String? description;
  String? hours;
  String? languages;
  String? adultPrice;
  String? childPrice;
  bool? alwaysAvailable;
  String? date;
  String? time;
  bool? withTransfer;
  String? transferPrice;
  bool? withFood;
  String? foods;
  String? prereq;
  String? included;
  String? notIncluded;
  String? prohibs;
  String? info;
  String? meetingPoint;
  List<String>? filePaths;
  String? seats;
  String? freeTicket;

  AddTourLocalSave(
      {this.name,
      this.description,
      this.hours,
      this.languages,
      this.adultPrice,
      this.childPrice,
      this.alwaysAvailable,
      this.date,
      this.withTransfer,
      this.transferPrice,
      this.withFood,
      this.foods,
      this.prereq,
      this.included,
      this.notIncluded,
      this.prohibs,
      this.info,
      this.meetingPoint,
      this.filePaths,
      this.seats,
      this.time,
      this.freeTicket,
      this.cityID});
}

// Future<void> updatePhotoTEST() async {
//   final ImagePicker _picker = ImagePicker();
//   var file;
//   XFile? img = await _picker.pickImage(source: ImageSource.gallery);

//   if (img != null) {
//     file = File(img.path);
//     var url = "$CONST_URL/profiles/612896a08bb9c27cea5878ad";

//     String fileName = file.path.split('/').last;

//     // var request = http.MultipartRequest('PUT', Uri.parse(url));

//     // Map<String, String> headers = {"Content-type": "multipart/form-data"};
//     // request.files.add(
//     //   http.MultipartFile(
//     //     'files.name',
//     //     file.readAsBytes().asStream(),
//     //     file.lengthSync(),
//     //     filename: fileName,
//     //     contentType: MediaType('image', 'jpeg'),
//     //   ),
//     // );
//     // request.headers.addAll(headers);
//     // request.fields.addAll({"name": "ALISHER222"});

//     // print("request: " + request.toString());
//     // var res = await request.send();
//     // print("THIS IS PHOTO UPLOAD RESPONSE: " + res.toString());
//     // print(res.statusCode);

//     // var request = http.MultipartRequest(
//     //   "PUT",
//     //   Uri.parse(
//     //     url,
//     //   ),
//     // );
//     // Map<String, String> headers = {
//     //   'content-type': 'multipart/form-data',
//     // };
//     // File file333 = new File(img.path);
//     // request.headers["content-type"] = 'multipart/form-data';
//     // request.fields["name"] = "ALISHER2222";

//     // request.files.add(
//     //   http.MultipartFile.fromBytes(
//     //     "files",
//     //     file333.readAsBytesSync(),
//     //     filename: "test.${img.path.split(".").last}",
//     //     contentType: MediaType("image", "${img.path.split(".").last}"),
//     //   ),
//     // );
//     // request.send().then((onValue) {
//     //   print(onValue.statusCode);

//     //   print(onValue.headers);
//     //   print(onValue.contentLength);
//     // });

//     FormData data = FormData.fromMap({
//       "name": "Alisherrr2222222222",
//       "files": {
//         "name": await MultipartFile.fromFile(file.path,
//             filename: fileName, contentType: MediaType('image', 'jpg')),
//       }
//     });

//     Dio dio = new Dio();
//     dio.put(url, data: data).then((response) {
//       var jsonResponse = jsonDecode(response.toString());
//       var testData = jsonResponse['histogram_counts'].cast<double>();
//       var averageGrindSize = jsonResponse['average_particle_size'];
//       print("DATA UPDATE RESULTS BELLOW!!");
//       print(response.statusCode);
//     }).catchError((error) => print(error));
//   }
// }
class NoCarPhotoSelectedException implements Exception {}
