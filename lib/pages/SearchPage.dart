import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mcommerce/components/SearchItemCard.dart';
import 'package:mcommerce/loaders/search_item_shimmer.dart';
import 'package:mcommerce/services/ApiService.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({
    super.key,
  });

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  var isLoading = false;
  int currentPage = 0;
  int count = 0;
  String item = "";
  List<SearchItemCard> productList = [];
  final ScrollController controller = ScrollController();

  Timer? _debounceTimer;

  void searchItemsByName({required String name, int? page = 0}) async {
    await Apiservice.getRequest("/product?name=${name}&pageNumber=${page}",
        (response) {
      var products = response.data["products"];
      setState(() {
        if (page == 0) productList.clear();
        products.forEach((product) {
          productList.add(SearchItemCard(
            id: product["id"],
            productName: product['name'],
            imageUrl: product['imageName'],
            discount: product["discount"],
            price: product["price"],
          ));
        });
        count = response.data["count"];
        isLoading = false;
      });
    });
  }

  void onSearchTextChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          isLoading = true;
          item = query;
          currentPage = 0;
        });
        searchItemsByName(name: query);
      } else {
        setState(() {
          item = "";
          productList.clear();
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (!isLoading && item.isNotEmpty && productList.length < count) {
          setState(() {
            isLoading = true;
            currentPage++;
          });
          searchItemsByName(name: item, page: currentPage);
        }
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // Search input field
          TextField(
            onChanged: onSearchTextChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: 20,
              ),
              hintText: "Search Food...",
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black38,
                  style: BorderStyle.solid,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          if (productList.isEmpty && !isLoading)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/empty_search.png', width: 100),
                    const Text(
                      "Search for Food...",
                      style: TextStyle(color: Color.fromARGB(255, 50, 48, 48)),
                    ),
                  ],
                ),
              ),
            ),

          if (productList.isEmpty && isLoading)
            Expanded(
              child: Center(
                child: SearchItemCardShimmer(), // Shimmer when no products found
              ),
            ),
          if (productList.isNotEmpty || isLoading)
            Expanded(
              child: ListView.separated(
                controller: controller,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  // Show shimmer effect if loading
                  if (isLoading && index == productList.length) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SearchItemCardShimmer(),
                    );
                  }
                  return SizedBox(
                    width: 250,
                    child: productList[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 8),
                itemCount: productList.length + (isLoading ? 1 : 0),
              ),
            ),
        ],
      ),
    ),
  );
}

}
