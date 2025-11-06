import 'package:flutter/material.dart';
import 'package:mcommerce/state/QuanntityState.dart';
import 'package:provider/provider.dart';

class Quantityselector extends StatelessWidget {
  final int maxQuantity;
  const Quantityselector({super.key,required this.maxQuantity});

  @override
  Widget build(BuildContext context) {
    final quantityState = Provider.of<QuanntityState>(context);

    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: quantityState.decreaseQuantity,
        ),
        Text(
          '${quantityState.getQuantity}',
          style: TextStyle(fontSize: 18),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            if(quantityState.getQuantity+1<=maxQuantity){
              quantityState.increaseQuantity();
            }
          },
        ),
      ],
    );
  }
}