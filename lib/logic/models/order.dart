import 'package:flutter/cupertino.dart';

class Order with ChangeNotifier {
  final String buyerID;
  final String orderID;
  final String tourName;
  final String sellerName;
  final String sellerID;
  final double price;
  //final String qrCodeUrl;
  bool sellerConfirmed;
  final bool activated;
  bool canceled;
  final DateTime date;

  Order(
      {required this.orderID,
      required this.tourName,
      required this.sellerName,
      required this.sellerID,
      required this.activated,
      required this.canceled,
      required this.date,
      required this.price,
      required this.buyerID,
      //required this.qrCodeUrl,
      required this.sellerConfirmed});

  void confirmBooking() {
    sellerConfirmed = true;
    notifyListeners();
  }

  void cancelBooking() {
    canceled = true;
    notifyListeners();
  }
}
