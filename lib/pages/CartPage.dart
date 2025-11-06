import 'package:flutter/material.dart';
import 'package:mcommerce/components/CustomButton.dart';
import 'package:mcommerce/state/CartState.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cartstate()..init(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          ),
          title: Text("Cart",style: TextStyle(fontSize: 50),),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Consumer<Cartstate>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                width: 250,
                                child: provider.cardItemList[index],
                                key: ValueKey(provider.cardItemList[index].id),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(width: 8),
                            itemCount: provider.cardItemList.length,
                          ),
                        ),
                        // Bottom Button and subtotal
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "SubTotal:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  Text(
                                    "Rs. ${provider.getTotal.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 25),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                "*Delivery charges will be added after updating your location.",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.red),
                              ),
                              SizedBox(height: 10),
                              CustomLongButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/checkoutPage");
                                },
                                backgroundColor: Colors.black,
                                text: "Check out",
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
