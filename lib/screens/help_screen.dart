import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Penggunaan', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(221, 30, 30, 30),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Selamat Datang di Artist Contact',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(221, 30, 30, 30),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Text(
                'Artist Contact merupakan sebuah aplikasi yang memudahkan pengguna untuk mencari contact person dari artist. Dengan aplikasi ini, Anda dapat dengan mudah menemukan dan menghubungi artist yang Anda inginkan.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Cara Menggunakan Aplikasi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(221, 30, 30, 30),
              ),
            ),
            const SizedBox(height: 16),
            _buildGuideStep(
              step: '1. Mencari Artist',
              description:
                  'Buka aplikasi dan di halaman utama, Anda dapat mencari artist dengan mengetikkan nama artist pada kolom pencarian. Anda juga dapat menjelajahi artist yang tersedia berdasarkan kategori.',
            ),
            _buildGuideStep(
              step: '2. Melihat Detail Artist',
              description:
                  'Klik pada artist yang Anda inginkan untuk melihat detail informasi, termasuk nomor telepon yang dapat dihubungi. Gunakan nomor tersebut untuk berkoordinasi dengan contact person dari masing-masing artist.',
            ),
            _buildGuideStep(
              step: '3. Menyimpan Data Pemesanan',
              description:
                  'Anda dapat menyimpan data pemesanan Anda melalui aplikasi untuk menghindari kehilangan data. Gunakan fitur "Tambah Pemesanan" untuk menyimpan informasi penting terkait pemesanan Anda.',
            ),
            _buildGuideStep(
              step: '4. Mengakses Profil dan Pengaturan',
              description:
                  'Anda dapat mengakses profil Anda dan melakukan pengaturan melalui menu yang ada di bagian samping aplikasi. Pastikan untuk selalu memperbarui informasi profil Anda.',
            ),
            _buildGuideStep(
              step: '5. Menggunakan Fitur Tambahan',
              description:
                  'Aplikasi ini juga menyediakan fitur tambahan seperti melihat riwayat pemesanan, membuat artist baru, dan melihat informasi tentang aplikasi. Manfaatkan fitur-fitur ini untuk pengalaman yang lebih baik.',
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Hubungi Kami',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(221, 30, 30, 30),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Jika Anda memiliki pertanyaan lebih lanjut atau membutuhkan bantuan, jangan ragu untuk menghubungi kami melalui halaman profil atau melalui kontak yang tersedia di aplikasi.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action for the button, like navigating to the contact page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(221, 30, 30, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Hubungi Kami',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideStep({required String step, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(221, 30, 30, 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
