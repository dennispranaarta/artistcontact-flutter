import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/dataLogin/cubit/data_login_cubit.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/screens/AddOrderPage.dart';
import 'package:my_app/screens/create_artist.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/profile_screen.dart'; // Pastikan Anda sudah memiliki profile_screen.dart
import 'checklist_screen.dart';
import 'history_screen.dart';
import 'about_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _namaLengkap = '';
  String _username = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final profile = context.read<DataLoginCubit>();
    final currentState = profile.state;

    int idUser = currentState.idUser;

    try {
      final response = await http.get(
        Uri.parse('${Endpoints.user}/read_by_user?id_user=$idUser'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _namaLengkap = data['datas'][0]['nama_lengkap'];
          _username = data['datas'][0]['username'];
        });
      } else {
        setState(() {
          _namaLengkap = 'Failed to load data';
          _username = '';
        });
      }
    } catch (e) {
      setState(() {
        _namaLengkap = 'An error occurred';
        _username = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Tutup drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()), // Navigasi ke profil screen
              );
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
                _namaLengkap,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                _username,
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
            title: Text('History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Create'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewArtistScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Pemesanan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddOrderPage()),
              );
            },
          ),
          BlocBuilder<DataLoginCubit, DataLoginState>(
            builder: (context, state) {
              return ListTile(
                title: Text(state.roles == 'admin' ? 'Admin' : 'Umum'),
              );
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
