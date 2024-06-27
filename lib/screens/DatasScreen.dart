// ignore_for_file: prefer_const_constructors, use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/components/bottom_up_transition.dart';
import 'package:my_app/dto/datas.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'editscreen.dart';
import 'formScreen.dart';
import 'package:my_app/services/data_services.dart';

class DatasScreen extends StatefulWidget {
  const DatasScreen({Key? key}) : super(key: key);

  @override
  _DatasScreenState createState() => _DatasScreenState();
}

class _DatasScreenState extends State<DatasScreen> {
  Future<List<Datas>>? _datas;

  @override
  void initState() {
    super.initState();
    _datas = DataService.fetchDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data List'),
        leading: IconButton(
          icon: const Icon(Icons
              .arrow_back), // Customize icon (optional)// Customize color (optional)
          onPressed: () {
            // Your custom back button functionality here
            Navigator.pushReplacementNamed(
                context, '/base'); // Default back button behavior
            // You can add additional actions here (e.g., show confirmation dialog)
          },
        ),
      ),
      body: FutureBuilder<List<Datas>>(
        future: _datas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: item.imageUrl != null
                      ? Row(
                          children: [
                            Image.network(
                              fit: BoxFit.fitWidth,
                              width: 350,
                              Uri.parse(
                                      '${Endpoints.baseURLLive}/public/${item.imageUrl!}')
                                  .toString(),
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons
                                      .error), // Display error icon if image fails to load
                            ),
                          ],
                        )
                      : null,
                  subtitle: Column(children: [
                    Text('Name : ${item.name}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 36, 31, 31),
                          fontWeight: FontWeight.normal,
                        )),
                    const Divider(),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, item);
                          },
                          icon: Icon(Icons.delete),
                        ),
                        
                        
                      ],
                    )
                  ]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 54, 40, 176),
        tooltip: 'Increment',
        onPressed: () {
          // Navigator.pushNamed(context, '/form-screen');
          // BottomUpRoute(page: const FormScreen());
          Navigator.push(context, BottomUpRoute(page: const FormScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Datas datas) async {
    final bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Data'),
        content: Text('Are you sure you want to delete this ${datas.name}?'),
        actions: [
          TextButton(
            onPressed: () {
              // Tidak jadi menghapus, kembali dengan nilai false
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Konfirmasi untuk menghapus, kembali dengan nilai true
              Navigator.of(context).pop(true);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );

    // Jika pengguna mengonfirmasi penghapusan, lanjutkan penghapusan
    if (confirmed) {
      try {
        // Memanggil metode deleteDatas untuk menghapus data dengan ID tertentu
        await DataService.deleteDatas(datas.idDatas);
        // Refresh data setelah berhasil menghapus
        setState(() {
          _datas = DataService.fetchDatas();
        });
        // Tampilkan snackbar atau pesan berhasil dihapus
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data deleted successfully'),
          ),
        );
      } catch (e) {
        // Tangani kesalahan jika gagal menghapus data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete data: $e'),
          ),
        );
      }
    }
  }
}