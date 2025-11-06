import 'package:flutter/material.dart';

class SearchItemCard extends StatelessWidget {
  final int id;
  final String imageUrl;
  final String productName;
  final double discount;
  final double price;
  final int? quantity;

  const SearchItemCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.discount,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "/productPage",arguments: {'id':id});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          // color: const Color.fromARGB(179, 198, 197, 197),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey, 
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
              SizedBox(width: 10),
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text("Rs. ${price.toStringAsFixed(2)}"),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
