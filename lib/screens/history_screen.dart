import 'package:flutter/material.dart';
import 'package:my_app/services/data_services.dart';
import 'package:my_app/dto/pesanan.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Pesanan>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = DataService.getOrders();
  }

  Future<void> _deleteOrder(int idPesanan) async {
    print('Attempting to delete order with ID: $idPesanan'); // Debug statement
    try {
      await DataService.deleteOrder(idPesanan);
      setState(() {
        _ordersFuture = DataService.getOrders();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order successfully deleted'),
          backgroundColor: Colors.black,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showUpdateDialog(BuildContext context, Pesanan order) async {
    final TextEditingController pembayaranController = TextEditingController(text: order.tanggalPembayaran);
    final TextEditingController tampilController = TextEditingController(text: order.tanggalTampil);

    Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.blue,
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), colorScheme: ColorScheme.light(primary: Colors.blue).copyWith(secondary: Colors.blueAccent),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      }
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          title: const Text(
            'Update Order',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pembayaranController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Payment Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.blue),
                    onPressed: () => _selectDate(context, pembayaranController),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: tampilController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Show Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.blue),
                    onPressed: () => _selectDate(context, tampilController),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red, side: BorderSide(color: Colors.red),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Set the text color to white
              ),
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white), // Ensure the text color is white
              ),
              onPressed: () async {
                final newTanggalPembayaran = pembayaranController.text;
                final newTanggalTampil = tampilController.text;
                Navigator.of(context).pop();
                try {
                  await DataService.updateOrder(
                    order.idPesanan,
                    newTanggalPembayaran,
                    newTanggalTampil,
                  );
                  setState(() {
                    _ordersFuture = DataService.getOrders();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order successfully updated'),
                      backgroundColor: Colors.black,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update order: $e'),
                      backgroundColor: Colors.black,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showOrderDetailsDialog(BuildContext context, Pesanan order) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          title: Text(
            'Order Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(Icons.person, 'Artist ID', order.idArtist.toString()),
              _buildDetailRow(Icons.date_range, 'Payment Date', order.tanggalPembayaran),
              _buildDetailRow(Icons.event, 'Show Date', order.tanggalTampil),
              // Add more details as needed
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red, side: BorderSide(color: Colors.red),
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: FutureBuilder<List<Pesanan>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load orders'),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    title: Text(
                      order.namaLengkap ?? 'Unknown User',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Artist ID: ${order.idArtist}'),
                        Text('Payment Date: ${order.tanggalPembayaran}'),
                        Text('Show Date: ${order.tanggalTampil}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info),
                          color: Colors.green,
                          onPressed: () {
                            _showOrderDetailsDialog(context, order);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () {
                            _showUpdateDialog(context, order);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () async {
                            final shouldDelete = await _showDeleteConfirmationDialog(context);
                            if (shouldDelete) {
                              _deleteOrder(order.idPesanan);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red, side: BorderSide(color: Colors.red),
              ),
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red, // Set the text color to white
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white), // Ensure the text color is white
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    )) ?? false;
  }
}
