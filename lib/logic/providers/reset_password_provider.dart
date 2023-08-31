import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ResetPasswordProvider with ChangeNotifier {
  String _emailField = '';

  void changeEmailField(String value) {
    _emailField = value;
    notifyListeners();
  }

  Future<String> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailField);
      return 'no';
    } on FirebaseAuthException catch (e) {
      print(e);
      return 'error';
    }
  }
}
