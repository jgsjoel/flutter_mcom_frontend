import 'package:flutter/material.dart';
import 'package:mcommerce/components/CustomButton.dart';
import 'package:mcommerce/components/QuantitySelector.dart';
import 'package:mcommerce/services/CartService.dart';
import 'package:mcommerce/services/ProductService.dart';
import 'package:mcommerce/state/QuanntityState.dart';
import 'package:provider/provider.dart';

class Productpage extends StatelessWidget {
  const Productpage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int id = arguments["id"];

    return ChangeNotifierProvider(
      create: (_) => QuanntityState(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
        ),
        body: FutureBuilder(
          future: loadProduct(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              var data = snapshot.data!;
              return Column(
                children: [
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product image
                          Container(
                            height: 400,
                            width: double.infinity,
                            child: Image.network(
                              data.imageUri,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          // Product details
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (data.discount > 0) ...[
                                  Row(
                                    children: [
                                      Text(
                                        'Rs. ${data.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration
                                              .lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Rs. ${(data.price * (1 - data.discount / 100)).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  
                                  Text(
                                    'Rs. ${data.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Weight: ${data.weight} Kg',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Quantity",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Quantityselector(maxQuantity: data.availableQty,),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Description",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  data.description,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    child: CustomLongButton(
                      onPressed: () {
                        final quantityState = Provider.of<QuanntityState>(context,listen: false);
                        addToCart(id, quantityState.getQuantity);
                      },
                      backgroundColor: Colors.black,
                      text: 'Add To Cart',
                      textColor: Colors.white,
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text("An error occurred"),
              );
            }
          },
        ),
      ),
    );
  }
}
