import 'package:flutter/material.dart';

class QuanntityState extends ChangeNotifier {
  int _quantity = 1;

  void increaseQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 1) _quantity--;
    notifyListeners();
  }

  int get getQuantity => _quantity;
  
}
