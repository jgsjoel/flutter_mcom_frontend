import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mcommerce/services/ApiService.dart';
import 'package:mcommerce/services/SecureStoreService.dart';

class Globalstate extends ChangeNotifier {
  int _itemCount = 0;
  late String _userEmail;

  Globalstate(){
    getCount();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    String? token = await Securestoreservice.getItem("accessToken");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    _userEmail = decodedToken['sub'] ?? '';
  }

  void increaseCount() {
    _itemCount++;
    notifyListeners();
  }

  void decreaseCount() {
    _itemCount--;
    notifyListeners();
  }

  String get getEmail => _userEmail; 

  Future<void> getCount() async {
    await Apiservice.getRequest("/cart/count", (response) {
      _itemCount = response.data;
    });
    notifyListeners();
  }

  int get getItemCount => _itemCount;
}
