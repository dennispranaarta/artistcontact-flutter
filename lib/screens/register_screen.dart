import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/endpoints/endpoints.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _nohpController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final namaLengkap = _namaLengkapController.text.trim();
    final nohp = _nohpController.text.trim();
    final address = _addressController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username dan password diperlukan'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Mengirim data registrasi ke backend
    final url = Uri.parse('${Endpoints.register}');
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
        'nama_lengkap': namaLengkap,
        'nohp': nohp,
        'address': address,
      },
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final registeredUsername = responseData['username'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrasi berhasil untuk $registeredUsername'),
          duration: Duration(seconds: 2),
        ),
      );
      // Setelah berhasil registrasi, bisa navigasi ke halaman lain misalnya login
      Navigator.of(context).pop(); // Kembali ke halaman sebelumnya (login screen)
    } else {
      final errorMessage = jsonDecode(response.body)['msg'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _namaLengkapController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _nohpController,
              decoration: InputDecoration(
                labelText: 'Nomor HP',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
