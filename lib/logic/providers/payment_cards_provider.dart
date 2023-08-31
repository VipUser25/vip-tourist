import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';

class PaymentCardsProvider with ChangeNotifier {
  final AuthProvider authData;

  PaymentCardsProvider({required this.authData}) {
    loadCardInfo();
  }
  String balance = "0.0";
  String? _cardID;
  String? _cardName;
  String? _cardNumber;
  //String? _iban;

  String? get cardID => _cardID;
  String? get cardName => _cardName;
  String? get cardNumber => _cardNumber;
  //String? get iban => _iban;

  void setBalance(String value) {
    balance = value;
    notifyListeners();
  }

  void setBalanceZero() {
    balance = "0.0";
    notifyListeners();
  }

  void setCardID(String value) {
    _cardID = value;
    notifyListeners();
  }

  void setCardName(String value) {
    _cardName = value;
    notifyListeners();
  }

  void setCardNumber(String value) {
    _cardNumber = value;
    notifyListeners();
  }

  // void setIban(String value) {
  //   _iban = value;
  //   notifyListeners();
  // }

  Future<bool> saveCard({
    String? cardID,
    required String cardName,
    required String cardNumber,
    //required String iban,
  }) async {
    bool res = true;
    var url1;

    if (cardID != null) {
      url1 = Uri.parse("$CONST_URL/payment-cards/$cardID");
    } else {
      url1 = Uri.parse(
          "$CONST_URL/payment-cards/KOf8484zazaazazazazazazazazazazazazzaa");
    }
    var response1 = await http.get(
      url1,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (response1.statusCode == 200) {
      var url2 = Uri.parse("$CONST_URL/payment-cards/$cardID");
      var response2 = await http.put(
        url2,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(
          {"name": cardName, "number": cardNumber},
        ),
      );
      if (response2.statusCode != 200) {
        res = false;
      } else {
        await addToLocal(
          cardID: cardID!,
          cardName: cardName,
          cardNumber: cardNumber,
        );
      }
    } else {
      var url3 = Uri.parse("$CONST_URL/payment-cards");
      var response3 = await http.post(
        url3,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(
          {"name": cardName, "number": cardNumber, "profile": authData.user.id},
        ),
      );
      if (response3.statusCode == 200) {
        dynamic bdy = jsonDecode(response3.body) as dynamic;
        await addToLocal(
          cardID: bdy["id"],
          cardName: cardName,
          cardNumber: cardNumber,
        );
      } else {
        res = false;
      }
    }
    return res;
  }

  Future<void> addToLocal({
    required String cardID,
    required String cardName,
    required String cardNumber,
    //required String iban,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString(authData.user.id! + "/cardID", cardID);
    pref.setString(authData.user.id! + "/cardName", cardName);
    pref.setString(authData.user.id! + "/cardNumber", cardNumber);
    // pref.setString(authData.user.id! + "/iban", iban);
    setCardID(cardID);
    setCardName(cardName);
    setCardNumber(cardNumber);
    //setIban(iban);
  }

  Future<void> loadCardInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? tempID = pref.getString(authData.user.id! + "/cardID");
    String? tempName = pref.getString(authData.user.id! + "/cardName");
    String? tempNumber = pref.getString(authData.user.id! + "/cardNumber");
    // String? tempIban = pref.getString(authData.user.id! + "/iban");
    // if (tempIban != null) {
    //   setIban(tempIban);
    // }
    if (tempNumber != null) {
      setCardNumber(tempNumber);
    }
    if (tempName != null) {
      setCardName(tempName);
    }
    if (tempID != null) {
      setCardID(tempID);
    }
  }

  Future<bool> makeWithdrawal() async {
    bool res = true;
    var url = Uri.parse("$CONST_URL/payments");
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
        {"profile": authData.user.idd, "sum": balance, "payment_card": cardID},
      ),
    );
    if (response.statusCode != 200) {
      res = false;
    }
    return res;
  }
}
