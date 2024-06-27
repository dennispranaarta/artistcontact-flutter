// ignore_for_file: file_names, library_private_types_in_public_api, empty_catches

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/dataLogin/cubit/data_login_cubit.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/services/data_services.dart';
import 'package:http/http.dart' as http;

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idArtistController = TextEditingController();
  final TextEditingController _tanggalPembayaranController = TextEditingController();
  final TextEditingController _tanggalTampilController = TextEditingController();
  final TextEditingController _searchArtistController = TextEditingController();

  List<dynamic> _artists = [];
  List<dynamic> _filteredArtists = [];
  dynamic _selectedArtist;

  @override
  void initState() {
    super.initState();
    _fetchArtists();
    _searchArtistController.addListener(_filterArtists);
  }

  Future<void> _fetchArtists() async {
    String url = '${Endpoints.artist}/read';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['datas'];
        setState(() {
          _artists = data;
          _filteredArtists = data;
        });
      } else {
      }
    } catch (e) {
    }
  }

  void _filterArtists() {
    String query = _searchArtistController.text;
    setState(() {
      _filteredArtists = _artists.where((artist) {
        return artist['nama_artist'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(221, 30, 30, 30),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final profile = context.read<DataLoginCubit>();
      final currentState = profile.state;

      final idArtist = _selectedArtist != null ? _selectedArtist['id_artist'].toString() : '';
      final tanggalPembayaran = _tanggalPembayaranController.text;
      final tanggalTampil = _tanggalTampilController.text;

      final response = await DataService.sendCreateOrderData(currentState.idUser, idArtist, tanggalPembayaran, tanggalTampil);

      if (response.statusCode == 200) {
        await _showDialog('Success', 'Order placed successfully.');
        debugPrint('Order placed successfully');
      } else {
        await _showDialog('Error', 'Failed to place order. Error code: ${response.statusCode}');
        debugPrint("Failed to place order ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextField(
                    controller: _searchArtistController,
                    decoration: InputDecoration(
                      labelText: 'Search Artist',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<dynamic>(
                    decoration: InputDecoration(
                      labelText: 'Select Artist',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    isExpanded: true,
                    items: _filteredArtists.map((artist) {
                      return DropdownMenuItem<dynamic>(
                        value: artist,
                        child: Text(artist['nama_artist']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedArtist = value;
                        _idArtistController.text = _selectedArtist['id_artist'].toString();
                      });
                    },
                    onSaved: (value) {
                      _selectedArtist = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an artist';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context, _tanggalPembayaranController),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Tanggal Pembayaran',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _tanggalPembayaranController.text.isEmpty
                            ? 'Pilih Tanggal'
                            : _tanggalPembayaranController.text,
                        style: TextStyle(color: _tanggalPembayaranController.text.isEmpty ? Colors.grey : Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context, _tanggalTampilController),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Tanggal Tampil',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _tanggalTampilController.text.isEmpty
                            ? 'Pilih Tanggal'
                            : _tanggalTampilController.text,
                        style: TextStyle(color: _tanggalTampilController.text.isEmpty ? Colors.grey : Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromARGB(221, 30, 30, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idArtistController.dispose();
    _tanggalPembayaranController.dispose();
    _tanggalTampilController.dispose();
    _searchArtistController.dispose();
    super.dispose();
  }
}
