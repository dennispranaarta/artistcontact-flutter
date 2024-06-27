// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:my_app/screens/create_artist.dart';
import 'package:my_app/screens/draweradmin.dart';
import 'package:my_app/screens/read_artist.dart';

import 'history_screen.dart';
import 'profile_screen.dart'; 
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationAdminScreen extends StatefulWidget {
  const NavigationAdminScreen({super.key});

  @override
  _NavigationAdminScreenState createState() => _NavigationAdminScreenState();
}

class _NavigationAdminScreenState extends State<NavigationAdminScreen> {
  int selectedIndex = 1;

  final List<Widget> _screens = [
    const HistoryScreen(),
    const NewArtistScreen(),
    const ReadArtistScreen(),
  ];

  final List<String> _pageTitles = ['History', 'Home', 'List Artist'];

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
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              iconSize: 46,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
                  
              },
            ),
          ),
        ],
      ),
      drawer: const AdminDrawer(), 
      body: _screens[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: const <Widget>[
          Icon(Icons.history, size: 30, color: Colors.white),
          Icon(Icons.home_outlined, size: 30, color: Colors.white),
          Icon(Icons.check_circle_outline, size: 30, color: Colors.white),
        ],
        color: const Color.fromARGB(255, 30, 30, 30),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        buttonBackgroundColor: const Color.fromARGB(255, 30, 30, 30),
        height: 50,
        animationDuration: const Duration(milliseconds: 500),
        index: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
