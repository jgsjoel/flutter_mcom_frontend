import 'package:flutter/material.dart';
import 'package:mcommerce/components/SearchItemCard.dart';
import 'package:mcommerce/services/ApiService.dart';

class CategorysearchState with ChangeNotifier {
  int _id = 0;
  late String _name;
  bool _isLoading = false;
  int currentPage = 0;
  int _count = 0;
  List<SearchItemCard> _productList = [];

  int get count=>_count;
  int get id => _id;
  String get name => _name;
  bool get isLoading => _isLoading;
  List<SearchItemCard> get productList => _productList;

  Future<void> fetchItems(int categoryId, int page) async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
      await Apiservice.getRequest(
        "/product?categoryId=${categoryId}&pageNumber=${page}",
        (response) {
          var products = response.data["products"];
          products.forEach((product) {
            _productList.add(SearchItemCard(
              id: product["id"],
              productName: product['name'],
              imageUrl: product['imageName'],
              discount: product["discount"],
              price: product["price"],
            ));
          });
          _count = response.data["count"];
          _isLoading = false;
          currentPage = page;
          notifyListeners();
        },
      );
    }
  }

  void setCategory(int id, String name) {
    _id = id;
    _name = name;
    notifyListeners();
  }
}