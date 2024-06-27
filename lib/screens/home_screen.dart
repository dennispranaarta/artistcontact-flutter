// ignore_for_file: unused_field, library_private_types_in_public_api, empty_catches

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/screens/AddOrderPage.dart'; // Assuming this is the import for AddOrderPage

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<dynamic>> categorizedArtists = {};
  List<dynamic> allArtists = [];
  String searchQuery = '';
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    fetchArtists();
    fetchUserProfile();
  }

  Future<void> fetchArtists() async {
    String url = '${Endpoints.artist}/read';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['datas'];
        setState(() {
          allArtists = data;
          categorizedArtists = _groupArtistsByCategory(data); // Group artists by category
        });
      } else {
      }
    } catch (e) {
    }
  }

  Future<void> fetchUserProfile() async {
    // Assumes that you have the user ID available
    int userId = 1; // Replace with actual user ID
    String url = '${Endpoints.user}/photo/$userId';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _profileImageUrl = url;
        });
      } else {
      }
    } catch (e) {
    }
  }

  Map<String, List<dynamic>> _groupArtistsByCategory(List<dynamic> artists) {
    Map<String, List<dynamic>> groupedArtists = {};
    for (var artist in artists) {
      String category = artist['kategori_artist'];
      if (!groupedArtists.containsKey(category)) {
        groupedArtists[category] = [];
      }
      groupedArtists[category]!.add(artist);
    }
    return groupedArtists;
  }

  Map<String, List<dynamic>> searchArtists(String query) {
    Map<String, List<dynamic>> filtered = {};
    for (var category in categorizedArtists.keys) {
      var filteredList = categorizedArtists[category]!.where((artist) =>
          artist['nama_artist'].toLowerCase().contains(query.toLowerCase())).toList();
      if (filteredList.isNotEmpty) {
        filtered[category] = filteredList;
      }
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Artists'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Artist',
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  categorizedArtists = searchArtists(searchQuery);
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: categorizedArtists.keys.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      backgroundColor: Colors.black12,
                      title: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      children: categorizedArtists[category]!.map((artist) {
                        return ArtistTile(artist: artist);
                      }).toList(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ArtistTile extends StatelessWidget {
  final Map<String, dynamic> artist;

  const ArtistTile({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: Text(
            artist['nama_artist'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('ID: ${artist['id_artist']}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text('Kategori: ${artist['kategori_artist']}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          trailing: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(artist: artist),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            label: const Text('Detail', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(221, 30, 30, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> artist;

  const DetailScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artist['nama_artist']),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(221, 30, 30, 30)),
        toolbarTextStyle: const TextTheme(
          titleLarge: TextStyle(color: Color.fromARGB(221, 30, 30, 30), fontSize: 20, fontWeight: FontWeight.bold),
        ).bodyMedium,
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(color: Color.fromARGB(221, 30, 30, 30), fontSize: 20, fontWeight: FontWeight.bold),
        ).titleLarge,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ID: ${artist['id_artist']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(221, 30, 30, 30)),
              ),
              const SizedBox(height: 8),
              Text(
                'Kategori: ${artist['kategori_artist']}',
                style: const TextStyle(fontSize: 16, color: Color.fromARGB(221, 30, 30, 30)),
              ),
              const SizedBox(height: 8),
              const Divider(color: Colors.grey),
              const SizedBox(height: 8),
              const Text(
                'Deskripsi:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(221, 30, 30, 30)),
              ),
              Text(
                '${artist['deskripsi_artist']}',
                style: const TextStyle(fontSize: 14, color: Color.fromARGB(221, 30, 30, 30)),
              ),
              const SizedBox(height: 8),
              const Divider(color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'Nomor: ${artist['nomor_artist']}',
                style: const TextStyle(fontSize: 16, color: Color.fromARGB(221, 30, 30, 30)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddOrderPage(),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomeScreen(),
    theme: ThemeData(
      primaryColor: Colors.black,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color.fromARGB(221, 30, 30, 30)),
        bodyMedium: TextStyle(color: Color.fromARGB(221, 30, 30, 30)),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
    ),
  ));
}
