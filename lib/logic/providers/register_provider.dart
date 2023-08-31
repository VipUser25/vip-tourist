import 'package:flutter/cupertino.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';

class RegisterProvider with ChangeNotifier {
  final AuthProvider authProvider;

  RegisterProvider({required this.authProvider});

  String _emailRegisterField = '';
  String _passwordRegisterField = '';

  void changeEmailRegisterField(String value) {
    _emailRegisterField = value;
    notifyListeners();
  }

  void changePasswordRegisterField(String value) {
    _passwordRegisterField = value;
    notifyListeners();
  }

  Future<String> signUp(bool receiveTips, bool isTourist, Locale locale) async {
    String warning = await authProvider.signUp(
        email: _emailRegisterField,
        password: _passwordRegisterField,
        receiveTips: receiveTips,
        isTourist: isTourist,
        locale: locale);
    return warning;
  }
}
