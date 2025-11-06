import 'package:flutter/material.dart';
import 'package:mcommerce/state/CartItemState.dart';
import 'package:mcommerce/state/CartState.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double price;
  final int quantity;
  final int id;
  final double discount;
  final int selectedQuantity;

  const CartItemCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.id,
    required this.selectedQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context){
        final cartItemState = Cartitemstate();
        cartItemState.init(quantity,selectedQuantity);
        print("Qty: ${cartItemState.getQty}");
        return cartItemState;
      },
      child: Consumer<Cartitemstate>(
        builder: (context, state, child) {
          double finalPrice = price;
          if (discount != 0) {
            finalPrice = price - (price * discount / 100);
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              // color: const Color.fromARGB(179, 198, 197, 197),
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
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
                  const SizedBox(width: 10),
                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          productName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (discount > 0)
                          Text(
                            "\Rs. ${(price * selectedQuantity).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          "\Rs. ${(finalPrice * selectedQuantity).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // Quantity selector
                  Row(
                    children: [
                      if (!state.delete && state.getQty > 1)
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            state.decrement(context, id);
                          },
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            Provider.of<Cartstate>(context, listen: false)
                                .deleteItem(id);
                          },
                        ),
                      Text(
                        "${state.getQty}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          state.increament(context, id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
