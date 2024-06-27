// ignore_for_file: unused_element, use_build_context_synchronously

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
  const LoginScreen({super.key});

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
    debugPrint(currentState.roles);

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
        title: const Text(
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
              const SizedBox(height: 50.0), // Spasi di atas logo aplikasi
              Image.asset(
                'assets/images/logo.png', // Ubah sesuai path logo aplikasi Anda
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40.0), // Spasi antara logo dan input fields
              _buildUsernameField(),
              const SizedBox(height: 20.0),
              _buildPasswordField(),
              const SizedBox(height: 20.0),
              _buildLoginButton(context, authCubit, dataLogin),
              const SizedBox(height: 20.0),
              _buildRegisterButton(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/config_screen');
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.settings),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: const Icon(Icons.person),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthCubit authCubit, DataLoginCubit dataLogin) {
    return ElevatedButton(
      onPressed: () => sendLogin(context, authCubit, dataLogin),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: const Color.fromARGB(221, 30, 30, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5,
      ),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      },
      child: const Text(
        "Don't have an account? Register here",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}
