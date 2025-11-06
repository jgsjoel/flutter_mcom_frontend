import 'package:flutter/material.dart';
import 'package:mcommerce/components/CategoryButton.dart';
import 'package:mcommerce/services/HomepagService.dart';
import 'package:shimmer/shimmer.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: FutureBuilder<List<Categorybutton>>(
        future: loadCat(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Categorybutton>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 8),
              itemCount: 5,
            );
          } else if (snapshot.hasData) {
            List<Categorybutton>? list = snapshot.data;
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
              itemBuilder: (BuildContext context, int index) {
                return list[index];
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 8),
              itemCount: list!.length,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

}
