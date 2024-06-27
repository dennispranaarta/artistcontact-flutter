class PelangganDTO {
  final int? idPelanggan;
  final int? idUser;
  final int? idPesanan;
  final String? namaUser;

  PelangganDTO({
    this.idPelanggan,
    this.idUser,
    this.idPesanan,
    this.namaUser,
  });

  factory PelangganDTO.fromJson(Map<String, dynamic> json) {
    return PelangganDTO(
      idPelanggan: json['id_pelanggan'] as int?,
      idUser: json['id_user'] as int?,
      idPesanan: json['id_pesanan'] as int?,
      namaUser: json['nama_user'] as String?,
    );
  }
}
