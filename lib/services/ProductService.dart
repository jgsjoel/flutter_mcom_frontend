import 'package:mcommerce/services/ApiService.dart';

class Product {
  final String name;
  final String description;
  final String imageUri;
  final double price;
  final double discount;
  final int availableQty;
  final double weight;

  const Product({
    required this.name,
    required this.description,
    required this.imageUri,
    required this.availableQty,
    required this.discount,
    required this.price,
    required this.weight,
  });
}

Future<Product?> loadProduct(int id) async {
  late Product product;
  await Apiservice.getRequest("/product/${id}", (response) {
    var data = response.data;
    product = Product(
      name: data["name"],
      availableQty: data["quantity"],
      description: data["description"],
      discount: data["discount"],
      weight: data["weight"],
      imageUri: data["imageName"],
      price: data["price"]
    );
  });

  if(product != null){
    return product;
  }else{
    return null;
  }
}
