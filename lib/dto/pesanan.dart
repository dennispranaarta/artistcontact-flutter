class Pesanan {
  final int idPesanan; // Primary key yang digunakan untuk penghapusan
  final int idUser;
  final int idArtist;
  final String tanggalPembayaran;
  final String tanggalTampil;
  final String? namaLengkap;

  Pesanan({
    required this.idPesanan,
    required this.idUser,
    required this.idArtist,
    required this.tanggalPembayaran,
    required this.tanggalTampil,
    required this.namaLengkap,
  });

  // From JSON
  factory Pesanan.fromJson(Map<String, dynamic> json) {
    return Pesanan(
      idPesanan: json['id_pesanan'],
      idUser: json['id_user'],
      idArtist: json['id_artist'] ?? '',
      tanggalPembayaran: json['tanggal_pembayaran'] ?? '',
      tanggalTampil: json['tanggal_tampil'] ?? '',
      namaLengkap: json['nama_lengkap'] as String?,
    );
  }
}