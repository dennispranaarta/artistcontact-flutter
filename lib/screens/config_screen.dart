import 'package:flutter/material.dart';
import 'package:my_app/endpoints/endpoints.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConfigScreenState createState() => ConfigScreenState();
}

class ConfigScreenState extends State<ConfigScreen> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadURL();
  }

  _loadURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('baseURL');
    if (url != null) {
      _urlController.text = url;
    }
  }

  _saveURL() async {
    String url = _urlController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseURL', url);
    Endpoints.updateBaseURL(url);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('URL saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Configuration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Please enter the URL below to configure the application settings. This URL will be securely stored and used to access necessary resources for the application. Make sure the URL is correct and accessible for proper functionality.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveURL,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}