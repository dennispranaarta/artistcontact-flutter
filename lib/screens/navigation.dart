// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:my_app/screens/AddOrderPage.dart';
import 'package:my_app/screens/history_user.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/profile_screen.dart'; // Import ProfileScreen
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'drawer.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 1;

  final List<Widget> _screens = [
    const OrderHistoryScreen(),
    const HomeScreen(),
    const AddOrderPage(),
  ];

  final List<String> _pageTitles = ['History', 'Home', 'Order'];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[selectedIndex],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(221, 30, 30, 30),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change drawer icon color to white
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              iconSize: 46,
              color: Colors.white, // Change profile icon color to white
              onPressed: () {
                // Navigate to ProfileScreen when the profile icon is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: MainDrawer(), 
      body: _screens[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: const <Widget>[
          Icon(Icons.history, size: 30, color: Colors.white),
          Icon(Icons.home_outlined, size: 30, color: Colors.white),
          Icon(Icons.check_circle_outline, size: 30, color: Colors.white),
        ],
        color: const Color.fromARGB(221, 30, 30, 30),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: const Color.fromARGB(221, 30, 30, 30),
        height: 50,
        animationDuration: const Duration(milliseconds: 500),
        index: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
