import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/screens/AddOrderPage.dart'; // Assuming this is the import for AddOrderPage

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<dynamic>> categorizedArtists = {};
  List<dynamic> allArtists = [];
  String searchQuery = '';

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
        print('Failed to fetch artists: ${response.body}');
      }
    } catch (e) {
      print('Exception during fetching artists: $e');
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
  void initState() {
    super.initState();
    fetchArtists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Artists'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Artist',
                labelStyle: TextStyle(color: Colors.blueAccent),
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
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
                      backgroundColor: Colors.blue[50],
                      title: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
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

  ArtistTile({required this.artist});

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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('ID: ${artist['id_artist']}', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text('Kategori: ${artist['kategori_artist']}', style: TextStyle(color: Colors.grey)),
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
              backgroundColor: Colors.blueAccent,
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

  DetailScreen({required this.artist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artist['nama_artist']),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blueAccent), toolbarTextStyle: TextTheme(
          headline6: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold),
        ).bodyText2, titleTextStyle: TextTheme(
          headline6: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold),
        ).headline6,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ID: ${artist['id_artist']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 8),
              Text(
                'Kategori: ${artist['kategori_artist']}',
                style: TextStyle(fontSize: 16, color: Colors.blueAccent),
              ),
              SizedBox(height: 8),
              Divider(color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Deskripsi:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              Text(
                '${artist['deskripsi_artist']}',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              SizedBox(height: 8),
              Divider(color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Nomor: ${artist['nomor_artist']}',
                style: TextStyle(fontSize: 16, color: Colors.blueAccent),
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
              builder: (context) => AddOrderPage(),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
    theme: ThemeData(
      primaryColor: Colors.blueAccent,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.blueAccent),
        bodyText2: TextStyle(color: Colors.blueAccent),
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
    ),
  ));
}
