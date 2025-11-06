import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mcommerce/components/ProductCard.dart';
import 'package:mcommerce/services/HomepagService.dart';

class Latestitems extends StatelessWidget {
  const Latestitems({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: FutureBuilder<List<ProductCard>>(
        future: loadNewArrivals(),
        builder: (BuildContext context, AsyncSnapshot<List<ProductCard>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 8),
              itemCount: 5,
            );
          } else if (snapshot.hasData) {
            var productCards = snapshot.data!;
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 250,
                  child: productCards[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 8),
              itemCount: productCards.length,
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading categories'));
          } else {
            return const Center(child: Text('No categories available'));
          }
        },
      ),
    );
  }
}
