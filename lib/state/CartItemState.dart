import 'package:flutter/material.dart';
import 'package:mcommerce/state/CartState.dart';
import 'package:provider/provider.dart';

class Cartitemstate extends ChangeNotifier {
  late int _quantity;
  int _maxQuantity = 0;

  bool delete = false;

  void init(int maxQty,int selectedQty){
    _maxQuantity = maxQty;
    _quantity = selectedQty;
  }

  int get getQty=> _quantity; 

  void increament(BuildContext context,int id) {
      delete = false;
      if (_maxQuantity >= _quantity + 1) {
        _quantity++;
        Provider.of<Cartstate>(context,listen: false).updateCart(id,_quantity);
      }
      notifyListeners();
  }

  void decrement(BuildContext context,int id) {
    if (_quantity > 1) {
      if (_quantity - 1 == 1) {
        delete = true;
      }
      _quantity--;
      Provider.of<Cartstate>(context, listen: false)
          .updateCart(id, _quantity);
          notifyListeners();
    }
  }
  
}
