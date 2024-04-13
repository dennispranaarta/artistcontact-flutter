import 'package:flutter/material.dart';
import 'package:my_app/screens/sql_screen.dart';
import 'checklist_screen.dart';
import 'news_screen.dart';
import 'history_screen.dart'; 
import 'profile_screen.dart'; 
import 'about_screen.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          GestureDetector( 
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(userName: 'Dennis Prana', userEmail: 'dennispranaa27@gmail.com', userBio: 'Haloo',)));
            },
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/drawer.png'),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: Offset(0, 3), 
                  ),
                ],
              ),
              accountName: Text(
                'Dennis Prana',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              accountEmail: Text(
                'dennispranaa27@gmail.com',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profil.jpg'),
              ),
            ),
          ),
          ListTile(
            title: Text('Checklist'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistScreen()));
            },
          ),
          ListTile(
            title: Text('Latihan API'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => LongListScreen()));
            },
          ),
          ListTile( 
            title: Text('History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
            },
          ),
          ListTile( 
            title: Text('Latihan CRUD SQL'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => CrudSQLScreen()));
            },
          ),
          ListTile( 
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
            },
          ),
          
        ],
      ),
    );
  }
}
