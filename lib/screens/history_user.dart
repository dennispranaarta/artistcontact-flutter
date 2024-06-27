import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/dataLogin/cubit/data_login_cubit.dart';
import 'package:my_app/dto/pesanan.dart';
import 'package:my_app/services/data_services.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
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
        title: Text('Order History'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pesananList.isEmpty
              ? Center(child: Text('No orders found'))
              : ListView.builder(
                  itemCount: pesananList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        title: Text(
                          'Artist ID: ${pesananList[index].idArtist}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text('ID: ${pesananList[index].idPesanan}'),
                            Text(
                                'Tanggal Pembayaran: ${pesananList[index].tanggalPembayaran}'),
                            Text(
                                'Tanggal Tampil: ${pesananList[index].tanggalTampil}'),
                            if (pesananList[index].namaLengkap != null)
                              Text(
                                  'Nama Lengkap: ${pesananList[index].namaLengkap}'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _showOrderDetailsDialog(pesananList[index]);
                          },
                          child: Text('Order Detail'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.blue,
                          ),
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
          title: Text('Order Details'),
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
                // Add more fields as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
