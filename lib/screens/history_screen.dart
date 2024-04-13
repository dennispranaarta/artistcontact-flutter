import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> _orders = [
    {'artist': 'Taylor Swift', 'rating': 4, 'photos': []},
    {'artist': 'Drake', 'rating': 3, 'photos': []},
    {'artist': 'Travis Scott', 'rating': 5, 'photos': []},
  ];

  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            final order = _orders[index];
            return Card(
              elevation: 4,
              child: ListTile(
                title: Text(order['artist']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRating(order['rating']),
                    SizedBox(height: 8),
                    Text('Foto Setelah Acara:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    _buildPhotos(order['photos']),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildRatingInput(order),
                    SizedBox(width: 8),
                    _buildAddPhotoButton(order),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  Widget _buildRatingInput(Map<String, dynamic> order) {
    return IconButton(
      icon: Icon(Icons.rate_review),
      onPressed: () {
        _showRatingDialog(order);
      },
    );
  }

  Widget _buildPhotos(List<dynamic> photos) {
    return photos.isEmpty
        ? Text('Belum ada foto')
        : SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Image.file(File(photos[index]), width: 100, fit: BoxFit.cover),
                );
              },
            ),
          );
  }

  Widget _buildAddPhotoButton(Map<String, dynamic> order) {
    return IconButton(
      icon: Icon(Icons.add_a_photo),
      onPressed: () {
        _uploadPhoto(order);
      },
    );
  }

  void _showRatingDialog(Map<String, dynamic> order) {
    int currentRating = order['rating'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Berikan Rating'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pilih nilai rating: $currentRating'),
                  SizedBox(height: 10),
                  Slider(
                    value: currentRating.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (value) {
                      setState(() {
                        currentRating = value.toInt();
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  order['rating'] = currentRating;
                });
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadPhoto(Map<String, dynamic> order) async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        order['photos'].add(pickedFile.path);
      });
    }
  }
}
