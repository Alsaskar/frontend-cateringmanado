import 'package:cateringmanado_new/screens/cart_order.dart';
import 'package:cateringmanado_new/screens/dashboard.dart';
import 'package:cateringmanado_new/screens/history_order.dart';
import 'package:cateringmanado_new/screens/profil.dart';
import 'package:flutter/material.dart';

class DashboardCustomer extends StatefulWidget {
  const DashboardCustomer({super.key});

  @override
  State<DashboardCustomer> createState() => _DashboardCustomerState();
}

class _DashboardCustomerState extends State<DashboardCustomer> {
  int _selectedIndex = 0;

  // list screen
  final List<Widget> _screens = [
    Dashboard(),
    HistoryOrder(),
    CartOrder(),
    Profil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xff47b0ff), // Atur warna item yang dipilih
          unselectedItemColor: Color(0xff1f9af7),
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}
