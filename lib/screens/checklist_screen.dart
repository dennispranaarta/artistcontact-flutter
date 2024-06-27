import 'package:flutter/material.dart';

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  Map<String, DateTime?> _selectedDates = {
    'Taylor Swift': null,
    'Drake': null,
    'Traviss Scott': null,
  };

  Future<void> _selectDate(BuildContext context, String artistName) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        _selectedDates[artistName] = picked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tanggal tampil $artistName: ${picked.day}/${picked.month}/${picked.year}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView.builder(
        itemCount: _selectedDates.length,
        itemBuilder: (context, index) {
          final artistName = _selectedDates.keys.elementAt(index);
          final selectedDate = _selectedDates[artistName];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white, // Ubah warna latar belakang
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), 
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  artistName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), 
                ),
                trailing: selectedDate != null
                    ? Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}')
                    : ElevatedButton(
                        onPressed: () => _selectDate(context, artistName),
                        child: Text('Pilih Tanggal'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), 
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
