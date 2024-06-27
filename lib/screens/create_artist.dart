// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/endpoints/endpoints.dart';

class NewArtistScreen extends StatefulWidget {
  const NewArtistScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewArtistScreenState createState() => _NewArtistScreenState();
}

class _NewArtistScreenState extends State<NewArtistScreen> {
  TextEditingController namaArtistController = TextEditingController();
  TextEditingController deskripsiArtistController = TextEditingController();
  TextEditingController nomorArtistController = TextEditingController();
  String kategoriArtist = 'Internasional'; // Default value for dropdown

  Future<void> createArtist() async {
    if (namaArtistController.text.isEmpty ||
        kategoriArtist.isEmpty ||
        deskripsiArtistController.text.isEmpty ||
        nomorArtistController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    String url = '${Endpoints.artist}/create';
    try {
      var response = await http.post(Uri.parse(url), body: {
        'nama_artist': namaArtistController.text,
        'kategori_artist': kategoriArtist,
        'deskripsi_artist': deskripsiArtistController.text,
        'nomor_artist': nomorArtistController.text,
      });
      if (response.statusCode == 200) {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artist created successfully')),
        );
      } else {
        // Handle other status codes
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create artist')),
        );
      }
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB4B4B4), Color(0xFF1E1E1E)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Selamat Datang ke Halaman Admin',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(221, 30, 30, 30),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30.0),
                          TextField(
                            controller: namaArtistController,
                            decoration: InputDecoration(
                              labelText: 'Nama Artist',
                              labelStyle: const TextStyle(color: Color.fromARGB(221, 30, 30, 30)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              prefixIcon: const Icon(Icons.person, color: Color.fromARGB(221, 30, 30, 30)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          DropdownButtonFormField<String>(
                            value: kategoriArtist,
                            onChanged: (String? newValue) {
                              setState(() {
                                kategoriArtist = newValue!;
                              });
                            },
                            items: <String>['Internasional', 'Nasional', 'Provinsi']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Kategori Artist',
                              labelStyle: const TextStyle(color: Color.fromARGB(221, 30, 30, 30)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              prefixIcon: const Icon(Icons.category, color: Color.fromARGB(221, 30, 30, 30)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: deskripsiArtistController,
                            decoration: InputDecoration(
                              labelText: 'Deskripsi Artist',
                              labelStyle: const TextStyle(color: Color.fromARGB(221, 30, 30, 30)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              prefixIcon: const Icon(Icons.description, color: Color.fromARGB(221, 30, 30, 30)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: nomorArtistController,
                            decoration: InputDecoration(
                              labelText: 'Nomor Artist',
                              labelStyle: const TextStyle(color: Color.fromARGB(221, 30, 30, 30)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              prefixIcon: const Icon(Icons.phone, color: Color.fromARGB(221, 30, 30, 30)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          SizedBox(
                            width: double.infinity,
                            height: 60.0,
                            child: ElevatedButton(
                              onPressed: createArtist,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                backgroundColor: const Color.fromARGB(221, 30, 30, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                shadowColor: Colors.black.withOpacity(0.25),
                                elevation: 10,
                              ),
                              child: const Text(
                                'Create Artist',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
