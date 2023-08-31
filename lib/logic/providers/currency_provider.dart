import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forex_conversion/forex_conversion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider with ChangeNotifier {
  final fx = Forex();
  double? _euro;
  double? _dirham;
  double? _rouble;
  double? _baht;
  double? _lira;
  double? _gbp;

  bool? _isFirstTime;

  bool? get isFirstTime => _isFirstTime;
  void changeFirstTime(bool value) {
    _isFirstTime = value;
  }

  String? _currency;

  void setCurrency(String value) {
    _currency = value;
    notifyListeners();
  }

  String? get currency => _currency;

  CurrencyProvider() {
    _currency = "USD";
  }

  void setEuro(double value) {
    _euro = value;
    notifyListeners();
  }

  void setDirham(double value) {
    _dirham = value;
    notifyListeners();
  }

  void setRouble(double value) {
    _rouble = value;
    notifyListeners();
  }

  void setBaht(double value) {
    _baht = value;
    notifyListeners();
  }

  void setLira(double value) {
    _lira = value;
    notifyListeners();
  }

  void setGbp(double value) {
    _gbp = value;
    notifyListeners();
  }

  double? get euro => _euro;
  double? get dirham => _dirham;
  double? get rouble => _rouble;
  double? get baht => _baht;
  double? get lira => _lira;
  double? get gbp => _gbp;

  Future<void> loadCurrencies() async {
    Map<String, double> allPrices = await fx.getAllCurrenciesPrices();
    print("FOREX CLUB CURRENCY RATE");
    print(allPrices["EUR"]);
    print(allPrices["AED"]);
    print(allPrices["RUB"]);
    print(allPrices["THB"]);
    print(allPrices["TRY"]);
    print(allPrices["GBP"]);

    setEuro(allPrices["EUR"]!);

    setDirham(allPrices["AED"]!);

    setRouble(allPrices["RUB"]!);

    setBaht(allPrices["THB"]!);

    setLira(allPrices["TRY"]!);

    setGbp(allPrices["GBP"]!);
  }

  Future<void> loadCurrency() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? temp = pref.getString("currency");
    if (temp != null) {
      setCurrency(temp);
    } else {
      setCurrency("USD");
    }
  }

  Future<void> setCurrencyLocaly(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("currency", value);
    setCurrency(value);
  }

  Future<void> noIntroAnymore() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("isFirstTime", false);
    changeFirstTime(false);
  }

  Future<void> loadFirstTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? res = pref.getBool("isFirstTime");
    if (res != null) {
      changeFirstTime(res);
    } else {
      changeFirstTime(true);
    }
  }
}
