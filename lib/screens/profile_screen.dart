import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userBio;

  const ProfileScreen({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userBio,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  bool _editingEnabled = false;
  late String _editedName;
  late String _editedBio;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _bioController = TextEditingController(text: widget.userBio);
    _editedName = widget.userName;
    _editedBio = widget.userBio;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/profil.jpg'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Nama Pengguna:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: _editingEnabled
                        ? TextFormField(
                            controller: _nameController,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Masukkan nama pengguna',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _editedName = value;
                              });
                            },
                          )
                        : Text(
                            _editedName,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                  ),
                  ListTile(
                    title: Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.userEmail,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Biodata:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: _editingEnabled
                        ? TextFormField(
                            controller: _bioController,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Masukkan biodata',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _editedBio = value;
                              });
                            },
                          )
                        : Text(
                            _editedBio,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _editingEnabled = !_editingEnabled;
                    if (!_editingEnabled) {
                      _editedName = _nameController.text;
                      _editedBio = _bioController.text;
                    }
                  });
                },
                child: Text(_editingEnabled ? 'Simpan Perubahan' : 'Edit Profil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
