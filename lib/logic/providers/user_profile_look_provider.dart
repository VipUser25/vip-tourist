import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:http/http.dart' as http;

class UserProfileLookProvider with ChangeNotifier {
  UserProfileModel? _user;
  bool _isLoaded = false;

  UserProfileModel get user => _user!;

  void setUser(UserProfileModel value) {
    _user = value;
    notifyListeners();
  }

  bool get isLoaded => _isLoaded;

  void setLoaded(bool value) {
    _isLoaded = value;
    notifyListeners();
  }

  Future<bool> getUser({required String id}) async {
    bool res = true;
    var url = Uri.parse("$CONST_URL/profiles?id=$id");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (response.statusCode != 200) {
      res = false;
    }
    var data = jsonDecode(response.body) as List<dynamic>;
    var clearBody = data[0];

    setUser(
      UserProfileModel(
          uid: clearBody["uid"],
          idd: clearBody["id"],
          email: clearBody["email"],
          name: clearBody["name"],
          photo: clearBody["photo_url"],
          hasTelegram: clearBody["hasTelegram"],
          hasViber: clearBody["hasViber"],
          hasWhatsapp: clearBody["hasWhatsapp"],
          isVerified: clearBody["is_verified"],
          phone: clearBody["phone_number"].toString(),
          isTourist: clearBody["is_tourist"]),
    );
    print("CHEC YO WORK OR NOOO???");
    print(_user!.name);
    setLoaded(true);

    return res;
  }

  void disposeUser() {
    _isLoaded = false;
    _user = null;
    notifyListeners();
  }
}

class UserProfileModel {
  final String uid;
  final String idd;
  final String email;
  final String name;
  final String photo;
  final bool isVerified;
  final String phone;
  final bool isTourist;
  final bool hasWhatsapp;
  final bool hasViber;
  final bool hasTelegram;

  UserProfileModel(
      {required this.uid,
      required this.idd,
      required this.email,
      required this.name,
      required this.photo,
      required this.isTourist,
      required this.isVerified,
      required this.phone,
      required this.hasTelegram,
      required this.hasViber,
      required this.hasWhatsapp});
}
