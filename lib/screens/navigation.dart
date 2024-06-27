import 'package:flutter/material.dart';
import 'package:my_app/screens/AddOrderPage.dart';
import 'package:my_app/screens/history_user.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/profile_screen.dart'; // Import ProfileScreen
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'drawer.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 1;

  final List<Widget> _screens = [
    OrderHistoryScreen(),
    HomeScreen(),
    AddOrderPage(),
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
                // Navigasi ke ProfileScreen ketika ikon profil ditekan
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
