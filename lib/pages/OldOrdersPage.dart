import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcommerce/state/GlobalState.dart';
import 'package:provider/provider.dart';

class OldOrdersPage extends StatefulWidget {
  const OldOrdersPage({super.key});

  @override
  State<OldOrdersPage> createState() => _OldOrdersPageState();
}

class _OldOrdersPageState extends State<OldOrdersPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = Provider.of<Globalstate>(context,listen: false).getEmail;
    print(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Past Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('Orders')
            .where('active', isEqualTo: false)
            .where('email', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Past Orders"));
          }

          var orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text("Invoice ID: ${orders[index].id}"),
                subtitle: Text("Status: ${order['status']}"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  _showOrderDetails(
                      context, orders[index].id, order['products']);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showOrderDetails(
      BuildContext context, String invoiceId, List<dynamic> products) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Invoice ID: $invoiceId",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Items",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const Divider(),
              ...products.map((product) {
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text("Quantity: ${product['quantity']}"),
                  trailing: Text(
                      "\Rs. ${(product['price'] * product['quantity']).toStringAsFixed(2)}"),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
