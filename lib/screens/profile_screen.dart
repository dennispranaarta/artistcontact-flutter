// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/dataLogin/cubit/data_login_cubit.dart';
import 'package:my_app/endpoints/endpoints.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  bool isLoading = true;
  Map<String, dynamic>? userData;
  String errorMessage = '';
  File? _image;
  String? _imageUrl;

  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _nohpController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final profile = context.read<DataLoginCubit>();
    final currentState = profile.state;

    int idUser = currentState.idUser;

    try {
      final response = await http.get(
        Uri.parse('${Endpoints.user}/read_by_user?id_user=$idUser'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data['datas'][0];
          _namaLengkapController.text = userData?['nama_lengkap'] ?? '';
          _nohpController.text = userData?['nohp'] ?? '';
          _addressController.text = userData?['address'] ?? '';
          _imageUrl = '${Endpoints.user}/photo/$idUser'; // Set image URL
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> updateUserProfile() async {
    final idUser = userData?['id_user'];

    final url = Uri.parse('${Endpoints.user}/update/$idUser');

    final response = await http.put(
      url,
      body: {
        'username': userData?['username'],
        'nama_lengkap': _namaLengkapController.text.trim(),
        'nohp': _nohpController.text.trim(),
        'address': _addressController.text.trim(),
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      // Refetch user data after update
      fetchUserData();
      setState(() {
        isEditing = false;
      });
    } else {
      final errorMessage = json.decode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    final profile = context.read<DataLoginCubit>();
    final currentState = profile.state;
    int idUser = currentState.idUser;

    if (_image == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${Endpoints.user}/upload'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    request.fields['id_user'] = idUser.toString();

    final response = await request.send();

    if (response.statusCode == 200) {
      // Get the response body
      final responseBody = await http.Response.fromStream(response);
      final responseData = json.decode(responseBody.body);
      final newImageUrl = responseData['image_url']; // Assume the server returns the new image URL

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo uploaded successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      // Update the image URL in the user data
      setState(() {
        _imageUrl = newImageUrl;
      });

      // Refetch user data after update
      fetchUserData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload photo'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _showEditProfileDialog() async {
    setState(() {
      isEditing = true;
    });
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Color.fromARGB(221, 30, 30, 30)),),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color.fromARGB(221, 30, 30, 30)),
            onPressed: () {
              _showEditProfileDialog();
            },
          ),
        ],
      ),
      body: BlocBuilder<DataLoginCubit, DataLoginState>(
        builder: (context, state) {
          return isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildProfileBox(),
                    );
        },
      ),
    );
  }

  Widget _buildProfileBox() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                _showImageSourceActionSheet(context);
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : _imageUrl != null
                        ? NetworkImage(_imageUrl!) as ImageProvider
                        : null,
                child: _image == null && _imageUrl == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 50,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _uploadImage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(221, 30, 30, 30),
              ),
              child: const Text('Upload Photo'),
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileItem(
            'Username',
            '${userData?['username'] ?? ''}',
          ),
          const SizedBox(height: 20),
          isEditing
              ? _buildEditableProfileItem('Nama Lengkap', _namaLengkapController)
              : _buildProfileItem('Nama Lengkap', _namaLengkapController.text),
          const SizedBox(height: 20),
          isEditing
              ? _buildEditableProfileItem('No HP', _nohpController)
              : _buildProfileItem('No HP', _nohpController.text),
          const SizedBox(height: 20),
          isEditing
              ? _buildEditableProfileItem('Alamat', _addressController)
              : _buildProfileItem('Alamat', _addressController.text),
          const SizedBox(height: 20),
          if (isEditing)
            Center(
              child: ElevatedButton(
                onPressed: () => updateUserProfile(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(221, 30, 30, 30),
                ),
                child: const Text('Update Profile'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildEditableProfileItem(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
        ),
      ],
    );
  }
}
