import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mcommerce/components/CartItemCard.dart';
import 'package:mcommerce/main.dart';
import 'package:mcommerce/services/ApiService.dart';
import 'package:mcommerce/state/GlobalState.dart';
import 'package:provider/provider.dart';

class CartItem {
  String imageUrl;
  String productName;
  double price;
  int quantity;
  int id;
  double discount;
  int selectedQuantity;

  CartItem({
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.id,
    required this.selectedQuantity,
  });
}

class Cartstate extends ChangeNotifier {
  
  List<CartItemCard> cardItemList = [];

  bool _loading = true;

  double _total = 0;

  void total(double price, double discount, int qty) {
    _total += (price - (price * discount / 100)) * qty;
  }

  void init() async{
    _total = 0;
    cardItemList.clear();
    _loading = true;
    await loadCart();
    notifyListeners();
  }

  Future<void> loadCart() async {
    await Apiservice.getRequest("/cart", (response) {
      var respData = response.data as List;
      respData.forEach((item) {
        total(item["productPrice"], item["discount"], item["selectedQuantity"]);
        cardItemList.add(CartItemCard(
          imageUrl: item["productImage"],
          productName: item["productName"],
          price: item["productPrice"],
          quantity: item["quantity"],
          discount: item["discount"],
          id: item["productId"],
          selectedQuantity: item["selectedQuantity"],
        ));
      });
      _loading = false;
    });
  }

  Future<void> updateCart(int id, int quantity) async {
    await Apiservice.putRequest(
      "/cart",
      {
        'productId': id,
        'quantity': quantity,
      },
      Options(headers: {
        Headers.contentTypeHeader: "application/json",
      }),
      (response) {
        init();
        // CartItem item = cardItemList.firstWhere((item) => item.id == id);
        // item.selectedQuantity = quantity;

        // _total = 0;
        // cardItemList.forEach((item) {
        //   total(item.price, item.discount, item.selectedQuantity);
        // });
        // notifyListeners();
      },
    );
  }

  Future<void> deleteItem(int id) async {
    await Apiservice.deleteRequest(
      "/cart",
      {
        'productId': id,
      },
      Options(headers: {
        Headers.contentTypeHeader: "application/json",
      }),
      (response) {
        // cardItemList.removeWhere((item) => item.id == id);
        init();

        // _total = 0;
        // cardItemList.forEach((item) {
        //   print("${item.productName}: ${item.selectedQuantity}");
        //   total(item.price, item.discount, item.selectedQuantity);
        // });

        Provider.of<Globalstate>(navigatorKey.currentContext!,listen: false).decreaseCount();
        // notifyListeners();
      },
    );
  }

  bool get isLoading => _loading;

  double get getTotal => _total;
}
