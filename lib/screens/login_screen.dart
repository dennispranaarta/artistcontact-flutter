import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:my_app/cubit/dataLogin/cubit/data_login_cubit.dart';
import 'package:my_app/dto/login.dart';
import 'package:my_app/screens/register_screen.dart'; // Import halaman register

import 'package:my_app/services/data_services.dart';
import 'package:my_app/utils/constants.dart';
import 'package:my_app/utils/secure_storage_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // State untuk menentukan apakah password tersembunyi atau tidak

  void _isLogin(DataLoginCubit dataLogin) {
    final profile = context.read<DataLoginCubit>();
    final currentState = profile.state;
    debugPrint('${currentState.roles}');

    if (dataLogin.state.roles == 'admin') {
      Navigator.pushReplacementNamed(context, "/admin");
    } else {
      Navigator.pushReplacementNamed(context, "/base");
    }
  }

  void sendLogin(BuildContext context, AuthCubit authCubit,
      DataLoginCubit dataLogin) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final response =
        await DataService.sendLoginData(username, password);
    if (response.statusCode == 200) {
      debugPrint("sending success");
      final data = jsonDecode(response.body);
      final loggedIn = Login.fromJson(data);
      await SecureStorageUtil.storage.write(
          key: tokenStoreName, value: loggedIn.accessToken);
      authCubit.login(loggedIn.accessToken);
      getProfile(dataLogin, loggedIn.accessToken, context);
      debugPrint(loggedIn.accessToken);
    } else {
      debugPrint("failed not");
    }
  }

  void getProfile(DataLoginCubit profileCubit, String? accessToken,
      BuildContext context) {
    if (accessToken == null) {
      debugPrint('Access token is null');
      return;
    }

    DataService.fetchProfile(accessToken).then((profile) {
      debugPrint(profile.toString());
      profileCubit.setProfile(profile.roles, profile.userLogged);
      profileCubit.state.roles == 'admin'
          ? Navigator.pushReplacementNamed(context, '/admin')
          : Navigator.pushReplacementNamed(context, '/base');
    }).catchError((error) {
      debugPrint('Error fetching profile: $error');
      // Show a user-friendly message here
    });
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final dataLogin = BlocProvider.of<DataLoginCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          textAlign: TextAlign.center, // Teks di tengah
          style: TextStyle(
            fontWeight: FontWeight.bold, // Teks tebal
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 50.0), // Spasi di atas logo aplikasi
              Image.asset(
                'assets/images/logo.png', // Ubah sesuai path logo aplikasi Anda
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20.0), // Spasi antara logo dan input fields
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
                obscureText:
                    _obscurePassword, // Set ke nilai state _obscurePassword
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey, // Warna ikon abu-abu
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword; // Toggle state _obscurePassword
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => sendLogin(context, authCubit, dataLogin),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10.0), // Spasi tambahan
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text(
                  "Didn't have account? Register here",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}
