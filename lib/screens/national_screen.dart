import 'package:flutter/material.dart';

class NationalScreen extends StatefulWidget {
  @override
  _NationalScreenState createState() => _NationalScreenState();
}

class _NationalScreenState extends State<NationalScreen> {
  List<Map<String, dynamic>> nationalArtists = [
    {
      'name': 'Isyana Sarasvati',
      'description':
          'Isyana Sarasvati adalah seorang penyanyi-penulis lagu berkebangsaan Indonesia. Penyanyi yang memiliki kemampuan bermain alat musik piano dan biola ini telah merilis beberapa lagu hits.',
      'contactPerson': 'Contact Person : @isyana123',
      'imagePath': 'assets/images/isyana.jpg', // Lokasi gambar dari asset lokal
    },
    {
      'name': 'Afgan',
      'description':
          'Afgansyah Reza atau yang dikenal dengan Afgan adalah seorang penyanyi berkebangsaan Indonesia. Selain dikenal dengan suaranya yang merdu, Afgan juga aktif dalam berbagai kegiatan sosial.',
      'contactPerson': 'Contact Person : @afgan456',
      'imagePath': 'assets/images/afgan.jpg', // Lokasi gambar dari asset lokal
    },
    {
      'name': 'Raisa',
      'description':
          'Raisa Andriana atau yang dikenal dengan nama Raisa adalah seorang penyanyi berkebangsaan Indonesia. Raisa dikenal dengan suara merdunya dan lagu-lagu yang bernuansa pop.',
      'contactPerson': 'Contact Person : @raisa789',
      'imagePath': 'assets/images/raisa.jpg', // Lokasi gambar dari asset lokal
    },
    // Add other national artists...
  ];

  List<String> selectedArtists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artis Nasional'),
      ),
      body: ListView.builder(
        itemCount: nationalArtists.length,
        itemBuilder: (context, index) {
          return _buildArtistCard(nationalArtists[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedArtists.isEmpty) {
            _showSelectionErrorNotification();
          } else {
            _showSuccessNotification(); // Call the method here
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
