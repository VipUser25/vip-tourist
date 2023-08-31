import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import 'package:vip_tourist/logic/models/order.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:http_auth/http_auth.dart';

class PurchaseOrderProvider with ChangeNotifier {
  String domain = "https://api.sandbox.paypal.com";
  String clientId =
      "AXLRZ8uUJwFe7H9BG6HsFB-bt6v5dwri_gLoovc8_7McH9J0e2COa0Pv9xRqCIkBr8G8SYiEy2kGbbz8";
  String secretKey =
      "EEWHgDqPpEtf7eRCReFOU4KtfYYmaJemjKxqDzUZVA_2PP2AozztcrdBgLlJKjk8VsGRiBcqik-UGH0q";
  int qwe = 5;
  var tempGenerator = Uuid();
  void trigger() {
    qwe = qwe + 1;
    notifyListeners();
  }

  Future<void> createOrder(
      {required String tourName,
      required String adultPrice,
      required String childPRice,
      required String sellerID,
      required int adults,
      required int children,
      required String ownerID,
      required DateTime dateTime}) async {
    var url = Uri.parse("$CONST_URL/orders");
    print("DATA BELLOW");
    print(tourName);
    print(adultPrice);
    print(childPRice);
    double comission = 0;
    if (adults > 0) {
      for (int i = 0; i < adults; i++) {
        comission = getComission(adultPrice);
        var response = await http.post(
          url,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: jsonEncode(
            {
              "price": adultPrice,
              "tour_name": tourName,
              "seller": sellerID,
              "commission": comission,
              "seller_confirmed": false,
              "activated": false,
              "date": dateTime.toIso8601String(),
              "profile": ownerID,
            },
          ),
        );
        print(response.statusCode);
      }
    }
    if (children > 0) {
      for (int i = 0; i < children; i++) {
        comission = getComission(childPRice);
        var response = await http.post(
          url,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: jsonEncode(
            {
              "price": childPRice,
              "seller": sellerID,
              "tour_name": tourName,
              "seller_confirmed": false,
              "activated": false,
              "date": dateTime.toIso8601String(),
              "profile": ownerID,
            },
          ),
        );
        print(response.statusCode);
      }
    }
  }

  Future<List<BookingTicket>> getTickets(
      {required String id, required int ss, String? sort}) async {
    int v = ss + qwe;

    List<BookingTicket> temp = [];
    var url;
    if (sort == null) {
      url = Uri.parse("$CONST_URL/orders?profile.id=$id");
    } else {
      url = Uri.parse("$CONST_URL/orders?profile.id=$id$sort");
    }
    print("URL LINK CHECK");
    print(url);
    var response = await http.get(url);
    var data = jsonDecode(response.body) as List<dynamic>;

    data.forEach(
      (element) {
        temp.add(
          BookingTicket(
              bookingID: element["id"] as String,
              tourName: element["tour_name"] as String,
              sellerID: element["seller"]["id"] as String,
              date: DateTime.parse(element["date"]),
              price: double.parse(element["price"].toString()),
              sellerName: element["seller"]["name"],
              activated: element["activated"],
              sellerConfirmed: element["seller_confirmed"],
              ownerID: element["profile"]["id"],
              ownerName: element["profile"]["name"],
              isChild: element["is_shild"],
              sellerPhoto: element["seller"]["photo_url"] ??
                  "https://www.terrainhopperusa.com/wp-content/uploads/2019/01/avatar-man.png"),
        );
      },
    );
    return temp;
  }

  Future<BookingTicket> getTicketDetails({String? id}) async {
    BookingTicket temp;

    var url = Uri.parse("$CONST_URL/orders?id=$id");
    var response = await http.get(url);
    var data = jsonDecode(response.body) as List<dynamic>;
    temp = BookingTicket(
      sellerPhoto: data[0]["profile"]["photo_url"] ??
          "https://www.terrainhopperusa.com/wp-content/uploads/2019/01/avatar-man.png",
      bookingID: data[0]["id"],
      isChild: data[0]["is_shild"],
      tourName: data[0]["tour_name"],
      sellerID: data[0]["seller"]["id"],
      date: DateTime.parse(data[0]["date"]),
      price: double.parse(data[0]["price"].toString()),
      sellerName: data[0]["seller"]["name"],
      activated: data[0]["activated"],
      sellerConfirmed: data[0]["seller_confirmed"],
      ownerID: data[0]["profile"]["id"],
      ownerName: data[0]["profile"]["name"],
    );
    return temp;
  }

  Future<List<Order>> getOrdersList({String? sellerID, String? filter}) async {
    print("ORDER WORKING CHECKING HEEEEEEECK!!");
    print(sellerID);
    List<Order> temp = [];
    if (sellerID != null) {
      var url;
      if (filter != null) {
        url = Uri.parse("$CONST_URL/orders?seller.id=$sellerID$filter");
      } else {
        url = Uri.parse("$CONST_URL/orders?seller.id=$sellerID");
      }

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

      print(data);
      data.forEach((element) {
        temp.add(
          Order(
            buyerID: element["profile"]["id"],
            orderID: element["id"],
            tourName: element["tour_name"],
            sellerName: element["seller"]["name"],
            sellerID: sellerID,
            activated: element["activated"],
            canceled: element["canceled"],
            date: DateTime.parse(element["date"]), //
            price: double.parse(
              element["price"].toString(),
            ),
            sellerConfirmed: element["seller_confirmed"],
          ),
        );
      });
    }

    return temp;
  }

  Future<bool> confirmBooking({required String offerID}) async {
    bool res = true;
    var url = Uri.parse("$CONST_URL/orders/$offerID");
    var response = await http.put(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode({"seller_confirmed": true}));
    if (response.statusCode != 200) {
      res = false;
    }
    return res;
  }

  Future<bool> cancelBooking({required String offerID}) async {
    bool res = true;
    var url = Uri.parse("$CONST_URL/orders/$offerID");
    var response = await http.put(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode({"canceled": true}));
    if (response.statusCode != 200) {
      res = false;
    }
    return res;
  }

  Future<bool> checkOrder(
      {required String orderID, required String sellerID}) async {
    bool res = true;
    var url = Uri.parse("$CONST_URL/orders/$orderID");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );

    dynamic body = jsonDecode(response.body) as dynamic;
    print("TESTING BODY OF QR CODE CHECK ORDEEEEEEEEEER");
    print(body["seller"]["id"]);
    if (response.statusCode != 200 ||
        body["seller"]["id"].toString() != sellerID ||
        body["canceled"] ||
        !body["seller_confirmed"]) {
      res = false;
    }
    return res;
  }

  double getComission(String value) {
    double val;

    try {
      val = double.parse(value);
    } catch (e) {
      return 1;
    }

    if (val < 10 && val >= 0) {
      return 2;
    } else if (val >= 10 && val < 31) {
      double perc = (val * 20) / 100;
      return perc;
    } else if (val >= 31 && val < 40) {
      return 7;
    } else if (val >= 40 && val < 131) {
      double perc = (val * 18) / 100;
      return perc;
    } else if (val >= 131 && val < 231) {
      return 30;
    } else if (val >= 231 && val < 501) {
      double perc = (val * 13) / 100;
      return perc;
    } else if (val >= 501) {
      double perc = (val * 10) / 100;
      return perc;
    }

    return 1;
  }

  Future<bool> activateOrder({required String orderID}) async {
    bool res = true;
    var url = Uri.parse("$CONST_URL/orders/$orderID");
    var response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
        {"activated": true},
      ),
    );
    if (response.statusCode != 200) {
      res = false;
    }
    return res;
  }

  Future<bool> rateGuide(
      {required String comment,
      required double rating,
      required String ownerID,
      required String tourID}) async {
    bool res = true;
    var url = Uri.parse("$CONST_URL/reviews");
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
        {
          "text": comment,
          "profile": ownerID,
          "tour": tourID,
          "rating": rating.toString(),
        },
      ),
    );
    if (response.statusCode != 200) {
      res = false;
    }
    return res;
  }

  String getFirstPhoto(String? photo) {
    if (photo != null) {
      List<String> v = photo.split("|");
      return v[0];
    } else {
      return "https://images.fineartamerica.com/images/artworkimages/mediumlarge/2/abstract-nature-shaukat-mulla.jpg";
    }
  }

  Future<bool> haveComment({required String userID}) async {
    bool haveComent = true;
    var url = Uri.parse("$CONST_URL/reviews?profile.id=$userID");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var data = jsonDecode(response.body) as List<dynamic>;
    if (data.isEmpty) {
      haveComent = false;
    }
    return haveComent;
  }

  Future<String> getAccessToken() async {
    var client = BasicAuthClient(clientId, secretKey);
    var response = await client.post(
        Uri.parse("$domain/v1/oauth2/token?grant_type=client_credentials"));
    final body = jsonDecode(response.body);

    return body["access_token"];
  }

  Future<Map<String, String>?> createPayment(String accessToken) async {
    print("IS ACCESS TOKEN OK?");
    print(accessToken);
    var url = Uri.parse("$domain/v1/payments/payment");
    var response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        'Authorization': 'Bearer ' + accessToken
      },
      body: jsonEncode({
        "intent": "sale",
        "payer": {"payment_method": "credit_card"},
        "redirect_urls": {
          "return_url": "https://example.com/return",
          "cancel_url": "https://example.com/cancel"
        },
        "transactions": [
          {
            "amount": {
              "total": "30.11",
              "currency": "USD",
              "details": {
                "subtotal": "30.00",
                "tax": "0.07",
                "shipping": "0.03",
                "handling_fee": "1.00",
                "shipping_discount": "-1.00",
                "insurance": "0.01"
              }
            },
            "description": "The payment transaction description.",
            "payment_options": {"allowed_payment_method": "UNRESTRICTED"},
            "soft_descriptor": "ECHI5786786",
            "item_list": {
              "items": [
                {
                  "name": "hat",
                  "description": "Brown hat.",
                  "quantity": "5",
                  "price": "3",
                  "tax": "0.01",
                  "sku": "1",
                  "currency": "USD"
                },
                {
                  "name": "handbag",
                  "description": "Black handbag.",
                  "quantity": "1",
                  "price": "15",
                  "tax": "0.02",
                  "sku": "product34",
                  "currency": "USD"
                }
              ],
              "shipping_address": {
                "recipient_name": "Brian Robinson",
                "line1": "4th Floor",
                "line2": "Unit #34",
                "city": "San Jose",
                "country_code": "US",
                "postal_code": "95131",
                "phone": "011862212345678",
                "state": "CA"
              }
            }
          }
        ],
      }),
    );
    print(response.body);
    var body = jsonDecode(response.body) as dynamic;
    if (response.statusCode == 201) {
      if (body["links"] != null && body["links"].length > 0) {
        List links = body["links"];

        String executeUrl = "";
        String approvalUrl = "";
        final item = links.firstWhere((o) => o["rel"] == "approval_url",
            orElse: () => null);
        if (item != null) {
          approvalUrl = item["href"];
        }
        final item1 =
            links.firstWhere((o) => o["rel"] == "execute", orElse: () => null);
        if (item1 != null) {
          executeUrl = item1["href"];
        }
        return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
      }
    } else {
      throw Exception(body["message"]);
    }
    return null;
  }
}

class BookingTicket {
  final bool activated;
  final bool sellerConfirmed;
  final String bookingID;
  final String tourName;
  final String sellerName;
  final double price;

  final String sellerID;
  final String sellerPhoto;
  final DateTime date;
  final String ownerName;
  final String ownerID;
  final bool isChild;

  BookingTicket({
    required this.bookingID,
    required this.tourName,
    required this.sellerID,
    required this.date,
    required this.price,
    required this.sellerPhoto,
    required this.sellerName,
    required this.activated,
    required this.sellerConfirmed,
    required this.ownerID,
    required this.ownerName,
    required this.isChild,
  });
}
