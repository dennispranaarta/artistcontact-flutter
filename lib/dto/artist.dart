class Artist {
  final int idArtist; // Primary key yang digunakan untuk penghapusan
  final int idUser;
  final String namaArtist;
  final String kategoriArtist;
  final String? deskripsiArtist;
  final int nomorArtist;

  Artist({
    required this.idArtist,
    required this.idUser,
    
    required this.namaArtist,
    required this.kategoriArtist,
    this.deskripsiArtist,
    required this.nomorArtist,
  });

  // From JSON
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      idArtist: json['id_artist'],
      idUser: json['id_user'],
      namaArtist: json['nama_artist'] ?? '',
      kategoriArtist: json['kategori_artist'] ?? '',
      deskripsiArtist: json['deskripsi_artist'] ?? '',
      nomorArtist: json['nomor_artist'] as int,
    );
  }
}
