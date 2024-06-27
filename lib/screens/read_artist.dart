import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/endpoints/endpoints.dart';

class ReadArtistScreen extends StatefulWidget {
  @override
  _ReadArtistScreenState createState() => _ReadArtistScreenState();
}

class _ReadArtistScreenState extends State<ReadArtistScreen> {
  Map<String, List<dynamic>> artistsByCategory = {};
  List<dynamic> allArtists = [];
  List<dynamic> filteredArtists = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchArtists();
    searchController.addListener(_filterArtists);
  }

  Future<void> fetchArtists() async {
    String url = '${Endpoints.artist}/read';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> artists = json.decode(response.body)['datas'];
        setState(() {
          allArtists = artists;
          filteredArtists = allArtists;
          artistsByCategory = {};
          for (var artist in filteredArtists) {
            String category = artist['kategori_artist'];
            if (artistsByCategory.containsKey(category)) {
              artistsByCategory[category]!.add(artist);
            } else {
              artistsByCategory[category] = [artist];
            }
          }
        });
      } else {
        print('Failed to fetch artists: ${response.body}');
      }
    } catch (e) {
      print('Exception during fetching artists: $e');
    }
  }

  void _filterArtists() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredArtists = allArtists.where((artist) {
        String name = artist['nama_artist'].toLowerCase();
        return name.contains(query);
      }).toList();
      artistsByCategory = {};
      for (var artist in filteredArtists) {
        String category = artist['kategori_artist'];
        if (artistsByCategory.containsKey(category)) {
          artistsByCategory[category]!.add(artist);
        } else {
          artistsByCategory[category] = [artist];
        }
      }
    });
  }

  Future<void> deleteArtist(int idArtist) async {
    String url = '${Endpoints.artist}/delete/$idArtist';
    try {
      var response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Successfully deleted artist');
        fetchArtists();
      } else {
        print('Failed to delete artist: ${response.body}');
      }
    } catch (e) {
      print('Exception during deleting artist: $e');
    }
  }

  Future<void> updateArtist(int idArtist, String namaArtist, String kategoriArtist, String deskripsiArtist, String nomorArtist) async {
    String url = '${Endpoints.artist}/update/$idArtist';
    try {
      var response = await http.put(Uri.parse(url), body: {
        'nama_artist': namaArtist,
        'kategori_artist': kategoriArtist,
        'deskripsi_artist': deskripsiArtist,
        'nomor_artist': nomorArtist,
      });
      if (response.statusCode == 200) {
        print('Successfully updated artist');
        fetchArtists();
      } else {
        print('Failed to update artist: ${response.body}');
      }
    } catch (e) {
      print('Exception during updating artist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Artist by Name',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF0072FF)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: artistsByCategory.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: EdgeInsets.all(16.0),
                        children: artistsByCategory.keys.map((category) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: ExpansionTile(
                              title: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: artistsByCategory[category]!.map<Widget>((artist) {
                                return ListTile(
                                  title: Text(
                                    artist['nama_artist'],
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Deskripsi: ${artist['deskripsi_artist']}',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      SizedBox(height: 4),
                                      Text('Nomor: ${artist['nomor_artist']}'),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Color(0xFF0072FF)),
                                        onPressed: () {
                                          _showUpdateDialog(context, artist);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Delete Artist'),
                                                content: Text('Are you sure you want to delete ${artist['nama_artist']}?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Delete'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      deleteArtist(artist['id_artist']);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, Map<String, dynamic> artist) {
    TextEditingController namaArtistController = TextEditingController(text: artist['nama_artist']);
    TextEditingController kategoriArtistController = TextEditingController(text: artist['kategori_artist']);
    TextEditingController deskripsiArtistController = TextEditingController(text: artist['deskripsi_artist']);
    TextEditingController nomorArtistController = TextEditingController(text: artist['nomor_artist'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Artist'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: namaArtistController,
                  decoration: InputDecoration(
                    labelText: 'Nama Artist',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    prefixIcon: Icon(Icons.person, color: Color(0xFF0072FF)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: kategoriArtistController,
                  decoration: InputDecoration(
                    labelText: 'Kategori Artist',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    prefixIcon: Icon(Icons.category, color: Color(0xFF0072FF)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: deskripsiArtistController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Artist',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    prefixIcon: Icon(Icons.description, color: Color(0xFF0072FF)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: nomorArtistController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Artist',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    prefixIcon: Icon(Icons.phone, color: Color(0xFF0072FF)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red, side: BorderSide(color: Colors.red),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                updateArtist(
                  artist['id_artist'],
                  namaArtistController.text,
                  kategoriArtistController.text,
                  deskripsiArtistController.text,
                  nomorArtistController.text,
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0072FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text('Update', style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }
}
