// lib/models/profil_model.dart

class Profil {
  final String id;
  final String namaLengkap;
  final String email;

  Profil({required this.id, required this.email, required this.namaLengkap});

  factory Profil.fromJson(Map<String, dynamic> json) {
    return Profil(
      id: json['id'],
      email: json['email'],
      namaLengkap: json['nama_lengkap'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'nama_lengkap': namaLengkap};
  }
}
