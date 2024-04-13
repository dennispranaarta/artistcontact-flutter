import 'package:flutter/material.dart';

class ProvincialScreen extends StatefulWidget {
  @override
  _ProvincialScreenState createState() => _ProvincialScreenState();
}

class _ProvincialScreenState extends State<ProvincialScreen> {
  List<Map<String, dynamic>> provincialArtists = [
    {
      'name': 'Navicula',
      'description':
          'Navicula adalah band indie rock yang terbentuk di Bali pada tahun 1996. Mereka terkenal karena musik mereka yang kritis sosial dan lingkungan, serta gaya hidup alternatif yang mereka anut. Navicula telah merilis beberapa album dan tampil di berbagai festival musik baik di Indonesia maupun internasional. Selain Navicula, masih ada beberapa band lainnya yang berasal dari Bali, tetapi Navicula adalah salah satu yang paling dikenal secara luas.',
      'contactPerson': 'Contact Person : @navicula123',
      'imagePath': 'assets/images/navicula.jpg', // Lokasi gambar dari asset lokal
    },
    {
      'name': 'Nostress',
      'description':
          'Nosstress adalah grup musik indie akustik yang berasal dari Bali, Indonesia. Grup ini terdiri dari Man Angga dan Guna Warma. Awalnya Nosstress hanya membawakan cover lagu versi akustik hingga akhirnya merilis karya orisinalnya dengan balutan genre blues dan folk Bali.',
      'contactPerson': 'Contact Person : @nostress456',
      'imagePath': 'assets/images/nostress.jpg', // Lokasi gambar dari asset lokal
    },
    {
      'name': 'SID',
      'description':
          'Superman Is Dead merupakan sebuah grup musik punk rock yang berasal dari Bali, Indonesia, bermarkas di Poppies Lane II - Kuta. Grup musik ini beranggotakan tiga pemuda asal Bali, yaitu: Bobby Kool vokalis, Eka Rock bassis dan Jerinx drummer.',
      'contactPerson': 'Contact Person : @jerinx789',
      'imagePath': 'assets/images/SID.jpg', // Lokasi gambar dari asset lokal
    },
    // Add other provincial artists...
  ];

  List<String> selectedArtists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artis Provinsi'),
      ),
      body: ListView.builder(
        itemCount: provincialArtists.length,
        itemBuilder: (context, index) {
          return _buildArtistCard(provincialArtists[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedArtists.isEmpty) {
            _showSelectionErrorNotification();
          } else {
            _showSuccessNotification(); // Panggil metode di sini
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _buildArtistCard(Map<String, dynamic> artist) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(artist['imagePath']),
            ),
            title: Text(
              artist['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                _showArtistDetailsDialog(artist);
              },
              child: Text(selectedArtists.contains(artist['name']) ? 'Batal' : 'Pilih Artis'),
            ),
          ),
        ],
      ),
    );
  }

  void _showArtistDetailsDialog(Map<String, dynamic> artist) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              artist['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Text(
                artist['description'],
                textAlign: TextAlign.center,
                style: TextStyle(), // Menambahkan teks tebal pada deskripsi
              ),
              SizedBox(height: 10),
              Text(
                artist['contactPerson'],
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold), // Menambahkan teks tebal pada kontak person
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _toggleArtistSelection(artist['name']);
                Navigator.of(context).pop();
              },
              child: Text(selectedArtists.contains(artist['name']) ? 'Batal' : 'Pilih'),
            ),
          ],
        );
      },
    );
  }

  void _toggleArtistSelection(String artistName) {
    setState(() {
      if (selectedArtists.contains(artistName)) {
        selectedArtists.remove(artistName);
      } else {
        selectedArtists.add(artistName);
      }
    });
  }

  void _showSuccessNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil memilih artis: $selectedArtists'),
      ),
    );
  }

  void _showSelectionErrorNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Artis belum dipilih'),
      ),
    );
  }
}
