import 'package:flutter/material.dart';
import 'package:my_app/screens/create_artist.dart';
import 'package:my_app/screens/read_artist.dart';

import 'history_screen.dart';
import 'profile_screen.dart';
import 'drawer.dart'; 
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationAdminScreen extends StatefulWidget {
  @override
  _NavigationAdminScreenState createState() => _NavigationAdminScreenState();
}

class _NavigationAdminScreenState extends State<NavigationAdminScreen> {
  int selectedIndex = 1;

  final List<Widget> _screens = [
    HistoryScreen(),
    NewArtistScreen(),
    ReadArtistScreen(),
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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.account_circle_rounded),
              iconSize: 46,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
                  
              },
            ),
          ),
        ],
      ),
      drawer: MainDrawer(), 
      body: _screens[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.history, size: 30),
          Icon(Icons.home_outlined, size: 30),
          Icon(Icons.check_circle_outline, size: 30),
        ],
        color: Colors.blue,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.blue[100],
        height: 50,
        animationDuration: Duration(milliseconds: 500),
        index: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
