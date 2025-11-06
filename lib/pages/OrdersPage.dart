import 'package:flutter/material.dart';
import 'package:mcommerce/pages/OldOrdersPage.dart';
import 'package:mcommerce/pages/OngoingOrderPage.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController; 

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Orders",
          style: TextStyle(fontSize: 40),
        ),
        bottom: tabController == null
            ? null
            : TabBar(
                controller: tabController,
                tabs: const [
                  Tab(
                      icon: Icon(Icons.autorenew),
                      child: Text("Ongoing Orders")),
                  Tab(icon: Icon(Icons.history), child: Text("Past Orders")),
                ],
              ),
      ),
      body: tabController == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: tabController,
              children: const [
                OngoingOrderPage(),
                OldOrdersPage(),
              ],
            ),
    );
  }
}
