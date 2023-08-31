import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoolStepperProvider with ChangeNotifier {
  int _currentStep = 0;

  CoolStepperProvider();

  int get currentStep => _currentStep;

  void setCurrentStep(int value) {
    _currentStep = value;
    notifyListeners();
  }

  Future<void> loadDataFromLocale() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? ddt = pref.getInt("cs_step");
    if (ddt != null) {
      _currentStep = ddt;
      notifyListeners();
    }
  }

  Future<void> saveLocally() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("cs_step", _currentStep);
  }
}
