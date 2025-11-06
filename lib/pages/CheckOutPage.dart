import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mcommerce/state/CheckoutState.dart';
import 'package:mcommerce/components/CustomButton.dart';
import 'package:mcommerce/components/TextFields.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isInitialized = false;
  late CheckoutState checkout;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      print("Initializing Checkout...");
      checkout = Provider.of<CheckoutState>(context, listen: false);
      checkout.loadCheckoutData();
      isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkout = Provider.of<CheckoutState>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: checkout.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Summary Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Summary",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildSummaryRow(
                              "SubTotal:",
                              "Rs. ${checkout.subtotal?.toStringAsFixed(2) ?? "0.00"}",
                            ),
                            const SizedBox(height: 10),
                            _buildSummaryRow(
                              "Delivery:",
                              checkout.delivery != null && checkout.delivery != 0.00
                                  ? "Rs. ${checkout.delivery.toStringAsFixed(2)}"
                                  : "Set delivery",
                            ),
                            const SizedBox(height: 10),
                            _buildSummaryRow(
                              "Total:",
                              "Rs. ${((checkout.subtotal ?? 0.00) + (checkout.delivery ?? 0.00)).toStringAsFixed(2)}",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Delivery Details Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Delivery Details",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              enable: false,
                              controller: checkout.nameController,
                              hintText: "Receiver Name",
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              enable: false,
                              controller: checkout.mobileController,
                              hintText: "Mobile Number",
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              controller: checkout.addressController,
                              hintText: "Enter Address",
                              lineCount: 4,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/mapPage");
                                  },
                                  icon: const Icon(
                                    Icons.edit_location_alt,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            CustomLongButton(
                              onPressed: (){
                                Provider.of<CheckoutState>(context,
                                        listen: false)
                                    .saveUserDetails();
                              },
                              backgroundColor: Colors.black,
                              text: "Make Payment",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
