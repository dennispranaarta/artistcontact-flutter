import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/dataLogin/cubit/data_login_cubit.dart';
import 'package:my_app/dto/pesanan.dart';
import 'package:my_app/services/data_services.dart';

class AddOrderPage extends StatefulWidget {
  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idArtistController = TextEditingController();
  final TextEditingController _tanggalPembayaranController = TextEditingController();
  final TextEditingController _tanggalTampilController = TextEditingController();
  final TextEditingController _namaPemesanController = TextEditingController();

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
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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

      final idArtist = _idArtistController.text;
      final tanggalPembayaran = _tanggalPembayaranController.text;
      final tanggalTampil = _tanggalTampilController.text;

      final response = await DataService.sendCreateOrderData(currentState.idUser, idArtist, tanggalPembayaran, tanggalTampil);

      if(response.statusCode == 200){
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
        title: Text('Add Order'),
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
                  TextFormField(
                    controller: _idArtistController,
                    decoration: InputDecoration(
                      labelText: 'ID Artist',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ID Artist';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
    _namaPemesanController.dispose();
    super.dispose();
  }
}

