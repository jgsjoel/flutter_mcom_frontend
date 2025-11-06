import 'package:flutter/material.dart';
import 'package:mcommerce/pages/LoginPage.dart';

class AuthState extends ChangeNotifier {
  bool _authenticated = true;

  void changeAuthState(GlobalKey<NavigatorState> navigatorKey) {
    _authenticated = !_authenticated;
    notifyListeners();
    _action(navigatorKey);
  }

  void _action(GlobalKey<NavigatorState> navigatorKey) {
    if (_authenticated == false) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  bool get isAuthenticated => _authenticated;
}
