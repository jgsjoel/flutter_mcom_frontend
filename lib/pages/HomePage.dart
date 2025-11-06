import 'package:flutter/material.dart';
import 'package:mcommerce/components/Carousel.dart';
import 'package:mcommerce/components/CartButton.dart';
import 'package:mcommerce/components/CategoryList.dart';
import 'package:mcommerce/components/LatestItems.dart';
import 'package:mcommerce/components/OffersList.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hello, Welcome!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              CartButton()
            ],
          ),
          
          SizedBox(
            height: 10,
          ),
          // carousel
          Carousel(),
          SizedBox( 
            height: 8,
          ),
          Text(
            "Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // categories
          CategoryList(),
          Text(
            "New Arrivals",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Latestitems(),
          SizedBox(
            height: 8,
          ),
          Text(
            "Offers",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          OffersList(),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
