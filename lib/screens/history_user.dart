import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/dataLogin/cubit/data_login_cubit.dart';
import 'package:my_app/dto/pesanan.dart';
import 'package:my_app/services/data_services.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Pesanan> pesananList = [];
  bool isLoading = true;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    fetchPesanan();
  }

  Future<void> fetchPesanan() async {
    final profile = context.read<DataLoginCubit>();
    final currentState = profile.state;

    int idUser = currentState.idUser;
    List<Pesanan> fetchedPesanan = await _dataService.fetchPesananByUser(idUser);
    setState(() {
      pesananList = fetchedPesanan;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pesananList.isEmpty
              ? const Center(child: Text('No orders found'))
              : ListView.builder(
                  itemCount: pesananList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        title: Text(
                          'Artist ID: ${pesananList[index].idArtist}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('ID: ${pesananList[index].idPesanan}'),
                            Text(
                                'Tanggal Pembayaran: ${pesananList[index].tanggalPembayaran}'),
                            Text(
                                'Tanggal Tampil: ${pesananList[index].tanggalTampil}'),
                            if (pesananList[index].namaLengkap != null)
                              Text(
                                  'Nama Lengkap: ${pesananList[index].namaLengkap}'),
                            Text(
                              'Status: ${pesananList[index].status}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: pesananList[index].status == 'Sudah Selesai'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _showOrderDetailsDialog(pesananList[index]);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(221, 30, 30, 30),
                          ),
                          child: const Text('Order Detail'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showOrderDetailsDialog(Pesanan pesanan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${pesanan.idPesanan}'),
                Text('Artist ID: ${pesanan.idArtist}'),
                Text('Tanggal Pembayaran: ${pesanan.tanggalPembayaran}'),
                Text('Tanggal Tampil: ${pesanan.tanggalTampil}'),
                if (pesanan.namaLengkap != null)
                  Text('Nama Lengkap: ${pesanan.namaLengkap}'),
                Text('Status: ${pesanan.status}'),
                // Add more fields as needed
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
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
