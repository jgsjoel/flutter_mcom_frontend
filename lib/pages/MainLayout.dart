import 'package:flutter/material.dart';
import 'package:mcommerce/pages/HomePage.dart';
import 'package:mcommerce/pages/OrdersPage.dart';
import 'package:mcommerce/pages/SearchPage.dart';
import 'package:mcommerce/pages/UserProfile.dart';

class Mainlayout extends StatefulWidget {
  final int initialIndex;

  const Mainlayout({super.key, this.initialIndex = 0});

  @override
  State<Mainlayout> createState() => _MainlayoutState();
}

class _MainlayoutState extends State<Mainlayout> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> body = [
    HomePage(),
    Searchpage(),
    OrdersPage(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: body[_currentIndex]),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.all(TextStyle(fontSize: 0)),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.white, size: 30);
            }
            return const IconThemeData(color: Color.fromARGB(179, 161, 161, 161), size: 28);
          }),
        ),
        child: NavigationBar(
          backgroundColor: Colors.black,
          elevation: 20,
          surfaceTintColor: Colors.transparent,
          height: 60,
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_filled),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search_sharp),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.checklist_rounded),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_2_outlined),
              selectedIcon: Icon(Icons.person_2),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
