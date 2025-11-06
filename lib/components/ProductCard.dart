import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final double price;
  final String? title;
  final String? image;
  final double discount;
  final int id;

  const ProductCard({
    super.key,
    this.image,
    this.title,
    required this.price,
    required this.discount,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    double finalPrice = price;
    if (discount != 0) {
      finalPrice = price - (price * discount / 100);
    }

    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, "/productPage",arguments: {
          'id': id
        });
      },
      style: ElevatedButton.styleFrom(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.25),
        padding: EdgeInsets.zero,
        // backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Card(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    "${image ?? "https://via.placeholder.com/200x300"}",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 130,
                  ),
                ),
                // product title
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title ?? "No Title",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (discount > 0)
                        Text(
                          "\$${price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        "\$${finalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            if (discount > 0)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "${discount.toInt()}% OFF",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
