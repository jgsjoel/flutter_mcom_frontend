import 'package:flutter/material.dart';
import 'package:mcommerce/components/Snackbar.dart';
import 'package:mcommerce/state/GlobalState.dart';
import 'package:provider/provider.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<Globalstate>(context,listen: true);
    return ElevatedButton(
      onPressed:(state.getItemCount == 0)? (){
        showSnackBar("Cart Is Empty", context);
      } : () {
        Navigator.pushNamed(context, "/cartPage");
      },
      style: ElevatedButton.styleFrom(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.25),
        padding: const EdgeInsets.all(10),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.shopping_cart,
            color: Colors.white,
            size: 24,
          ),
          Positioned(
            top: -7,
            right: -14,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                "${state.getItemCount}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
