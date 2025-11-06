import 'package:mcommerce/components/CategoryButton.dart';
import 'package:mcommerce/components/ProductCard.dart';
import 'package:mcommerce/services/ApiService.dart';

Future<List<String>> loadBanners() async {
  List<String> bannerList = [];
  await Apiservice.getRequest("/banner", (response) {
    var banners = response.data["banners"];
    banners.forEach((bannerUrl) {
      bannerList.add(bannerUrl["imageUrl"]);
    });
  });
  return bannerList;
}

Future<List<Categorybutton>> loadCat() async {
  List<Categorybutton> categoryList = [];
  await Apiservice.getRequest("/category", (response) {
    var categories = response.data["categories"];
    categories.forEach((category) {
      categoryList.add(Categorybutton(
        id:category["id"],
        categoryName: category['categoryName'],
        imageUrl: category['imageUrl'],
      ));
    });
  });

  return categoryList;
}

Future<List<ProductCard>> loadNewArrivals() async {
  List<ProductCard> cardList = [];
  await Apiservice.getRequest("/product", (response) {
    var discountedList = response.data["products"];
    discountedList.forEach((item) {
      cardList.add(ProductCard(
        id: item["id"],
        title: item["name"],
        image: item["imageName"],
        price: item["price"],
        discount: item["discount"],
      ));
    });
  });

  return cardList;
}

Future<List<ProductCard>> loadOffers() async {
  List<ProductCard> cardList = [];
  await Apiservice.getRequest("/product/discounts", (response) {
    var discountedList = response.data["products"];
    discountedList.forEach((item) {
      cardList.add(ProductCard(
        id: item["id"],
        title: item["name"],
        image: item["imageName"],
        price: item["price"],
        discount: item["discount"],
      ));
    });
  });

  return cardList;
}
