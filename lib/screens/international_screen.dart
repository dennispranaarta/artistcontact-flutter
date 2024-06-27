import 'package:flutter/material.dart';

class InternationalScreen extends StatefulWidget {
  @override
  _InternationalScreenState createState() => _InternationalScreenState();
}

class _InternationalScreenState extends State<InternationalScreen> {
  List<Map<String, dynamic>> nationalArtists = [
    {
      'name': 'Taylor Swift',
      'description':
          'Taylor Alison Swift adalah seorang penyanyi-penulis lagu berkebangsaan Amerika Serikat. Penulisan lagu naratifnya, yang sering berpusat di sekitar kehidupan pribadinya, telah menerima pujian kritis dan liputan media yang luas.',
      'contactPerson': 'Contact Person : @taylor123',
      'imagePath': 'assets/images/taylor.jpg', 
    },
    {
      'name': 'Drake',
      'description':
          'Aubrey Drake Graham adalah seorang rapper, penyanyi, penulis lagu, produser rekaman, aktor, dan pengusaha asal Kanada. Drake awalnya dikenal sebagai aktor serial televisi drama remaja Degrassi: The Next Generation di awal tahun 2000-an.',
      'contactPerson': 'Contact Person : @drake456',
      'imagePath': 'assets/images/drake.jpg', 
    },
    {
      'name': 'Travis Scott',
      'description':
          'Jacques Bermon Webster II, dikenal secara profesional sebagai Travis Scott, adalah seorang rapper, penyanyi, penulis lagu, dan produser rekaman Amerika. Nama panggungnya merupakan kombinasi dari nama pamannya dan nama depan salah satu inspirasinya, Kid Cudi.',
      'contactPerson': 'Contact Person : @travis789',
      'imagePath': 'assets/images/traviss.jpg', 
    },
    
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
