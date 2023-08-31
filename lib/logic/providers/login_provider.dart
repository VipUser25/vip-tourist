import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vip_tourist/logic/models/custom_return.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';

class LoginProvider with ChangeNotifier {
  final AuthProvider authProvider;
  String? _emailSuggestion;

  LoginProvider({required this.authProvider}) {
    loadSuggestion();
  }

  String _emailField = '';
  String _passwordField = '';

  void changeEmailField(String value) {
    _emailField = value;
    notifyListeners();
  }

  void changePasswordField(String value) {
    _passwordField = value;
    notifyListeners();
  }

  void setEmailSuggestion() {
    _emailSuggestion = _emailField;
    notifyListeners();
  }

  void setEmailSuggestion2(String value) {
    _emailSuggestion = value;
    notifyListeners();
  }

  String? get emailSuggestion => _emailSuggestion;

  Future<String> logIn() async {
    String warning = await authProvider.logInWithEmailAndPassword(
        email: _emailField, password: _passwordField);
    return warning;
  }

  Future<CustomReturn> logInViaGoogle() async {
    CustomReturn warrning = await authProvider.logInWithGoogle();
    return warrning;
  }

  Future<CustomReturn> logInViaApple() async {
    CustomReturn warrning = await authProvider.logInWithApple();
    return warrning;
  }

  Future<void> setSuggestion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("emailSuggestion", _emailField);
    setEmailSuggestion();
    print("EMAIL IS SET");
    print(_emailField);
  }

  Future<void> loadSuggestion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? temp = pref.getString("emailSuggestion");
    if (temp != null) {
      setEmailSuggestion2(temp);
      print('EMAIL IS LOADED');
      print(temp);
    }
  }
}
