import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:vip_tourist/logic/models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:vip_tourist/logic/utility/constants.dart';

class NotificationProvider with ChangeNotifier {
  int value = 0;
  void trigger() {
    value++;
    notifyListeners();
  }

  Future<List<MyNotification>> getNotifications(
      {required String uid, String? filter}) async {
    print("NOTIF WORKING CHECKING YOO");
    print("$CONST_URL_NOTIF/notifications");
    List<MyNotification> temp = [];
    bool haveSecond = false;
    bool isPersonal = true;
    var url;
    var url2;
    var response;
    var response2;
    int z = value + 2;
    print(z);
    if (filter != null) {
      switch (filter) {
        case "general":
          url = Uri.parse(
              "$CONST_URL_NOTIF/notifications?forAllUsers=true&_sort=createdAt:DESC");
          isPersonal = false;
          break;
        case "personal":
          url = Uri.parse(
              "$CONST_URL_NOTIF/notifications?profile.uid=$uid&_sort=createdAt:DESC");
          isPersonal = true;
          break;
        case "all":
          url = Uri.parse(
              "$CONST_URL_NOTIF/notifications?forAllUsers=true&_sort=createdAt:DESC");
          url2 = Uri.parse(
              "$CONST_URL_NOTIF/notifications?profile.uid=$uid&_sort=createdAt:DESC");
          haveSecond = true;
          break;
      }
    } else {
      url = Uri.parse(
          "$CONST_URL_NOTIF/notifications?forAllUsers=true&_sort=createdAt:DESC");
      url2 = Uri.parse(
          "$CONST_URL_NOTIF/notifications?profile.uid=$uid&_sort=createdAt:DESC");
      haveSecond = true;
    }

    response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (haveSecond) {
      response2 = await http.get(
        url2,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      );
    }
    if (haveSecond) {
      if (response.statusCode != 200 && response2.statusCode != 200) {
        return [];
      }
      var data = jsonDecode(response.body) as List<dynamic>;
      if (data.isNotEmpty) {
        data.forEach(
          (element) {
            temp.add(
              MyNotification(
                  isPersonal: false,
                  title: element["title"],
                  body: element["body"],
                  notificationID: element["id"],
                  dateTime: DateTime.parse(element["createdAt"] as String),
                  uid: uid),
            );
          },
        );
      }
      var data2 = jsonDecode(response2.body) as List<dynamic>;
      if (data2.isNotEmpty) {
        data2.forEach(
          (element) {
            temp.add(
              MyNotification(
                isPersonal: true,
                title: element["title"],
                body: element["body"],
                notificationID: element["id"],
                uid: uid,
                dateTime: DateTime.parse(element["createdAt"] as String),
              ),
            );
          },
        );
      }
    } else {
      var data = jsonDecode(response.body) as List<dynamic>;
      if (data.isNotEmpty) {
        data.forEach(
          (element) {
            temp.add(
              MyNotification(
                  dateTime: DateTime.parse(element["createdAt"] as String),
                  isPersonal: isPersonal,
                  title: element["title"],
                  body: element["body"],
                  notificationID: element["id"],
                  uid: uid),
            );
          },
        );
      }
    }

    return temp;
  }

  Future<void> deleteNotification({required String notifID}) async {
    var url = Uri.parse("$CONST_URL_NOTIF/notifications/$notifID");
    var response = await http.delete(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    print("NOTIF DELETE RESULT");
    print(response.statusCode);
  }
}
