class Resep {
  final int id;
  final String userId;
  final String judul;
  final String bahan;
  final String langkah;
  final String? imgResep;
  final DateTime createdAt;
  final String? name;
  final int? jumlahFavorit; // Tambahan

  Resep({
    required this.id,
    required this.userId,
    required this.judul,
    required this.bahan,
    required this.langkah,
    this.imgResep,
    required this.createdAt,
    this.name,
    this.jumlahFavorit, // Tambahan
  });

  factory Resep.fromJson(Map<String, dynamic> json) {
    return Resep(
      id: json['id'],
      userId: json['user_id'],
      judul: json['judul'],
      bahan: json['bahan'],
      langkah: json['langkah'],
      imgResep: json['img_resep'],
      createdAt: DateTime.parse(json['created_at']),
      name: json['profiles']?['name'],
      jumlahFavorit: json['jumlah_favorit'], // Ambil dari Supabase
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'judul': judul,
      'bahan': bahan,
      'langkah': langkah,
      'img_resep': imgResep,
      'created_at': createdAt.toIso8601String(),
      'profiles': {'name': name},
      'jumlah_favorit': jumlahFavorit,
    };
  }
}
