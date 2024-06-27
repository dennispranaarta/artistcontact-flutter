// ignore_for_file: unused_import, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/dataLogin/cubit/data_login_cubit.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/screens/AddOrderPage.dart';
import 'package:my_app/screens/create_artist.dart';
import 'package:my_app/screens/help_screen.dart';
import 'package:my_app/screens/history_user.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/profile_screen.dart';
import 'package:my_app/screens/read_artist.dart';
import 'history_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  String _namaLengkap = '';
  String _username = '';
  String? _profileImageUrl;

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
          _profileImageUrl = '${Endpoints.user}/photo/$idUser';
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
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()), // Navigate to profile screen
              );
            },
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/drawer.png'),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              accountName: Text(
                _namaLengkap,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                _username,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : const AssetImage('assets/images/profil.jpg') as ImageProvider,
                child: _profileImageUrl == null
                    ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
                    : null,
              ),
            ),
          ),
          ListTile(
            title: const Text('Add Artist'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewArtistScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('List Artist'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReadArtistScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Order History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          ListTile(
            title: const Row(
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
                  builder: (context) => const LoginScreen(),
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
