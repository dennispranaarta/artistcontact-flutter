
class UserDTO {
  final String username;
  final String password;
  final String roles;
  final String namaLengkap;
  final String nohp;
  final String address;
  final String foto; // New field for storing photo URL or path

  UserDTO({
    required this.username,
    required this.password,
    this.roles = 'umum',
    required this.namaLengkap,
    required this.nohp,
    required this.address,
    required this.foto, // Updated constructor to include foto
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      username: json['username'],
      password: json['password'],
      roles: json['roles'],
      namaLengkap: json['nama_lengkap'],
      nohp: json['nohp'],
      address: json['address'],
      foto: json['foto'] ?? '', // Ensure foto is not null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'roles': roles,
      'nama_lengkap': namaLengkap,
      'nohp': nohp,
      'address': address,
      'foto': foto, // Including foto in JSON
    };
  }
}
