import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/endpoints/endpoints.dart';

class NewArtistScreen extends StatefulWidget {
  @override
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
        SnackBar(content: Text('Please fill in all fields')),
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
        print('Successfully created artist');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Artist created successfully')),
        );
      } else {
        // Handle other status codes
        print('Failed to create artist: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create artist')),
        );
      }
    } catch (e) {
      // Handle other errors
      print('Exception during artist creation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Selamat Datang ke Halaman Admin',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0072FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.0),
                      TextField(
                        controller: namaArtistController,
                        decoration: InputDecoration(
                          labelText: 'Nama Artist',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: Icon(Icons.person, color: Color(0xFF0072FF)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                        ),
                      ),
                      SizedBox(height: 20.0),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: Icon(Icons.category, color: Color(0xFF0072FF)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: deskripsiArtistController,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi Artist',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: Icon(Icons.description, color: Color(0xFF0072FF)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: nomorArtistController,
                        decoration: InputDecoration(
                          labelText: 'Nomor Artist',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: Icon(Icons.phone, color: Color(0xFF0072FF)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        width: double.infinity,
                        height: 60.0,
                        child: ElevatedButton(
                          onPressed: createArtist,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20.0), backgroundColor: Color(0xFF0072FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            shadowColor: Colors.black.withOpacity(0.25),
                            elevation: 10,
                          ),
                          child: Text(
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
        ),
      ),
    );
  }
}
