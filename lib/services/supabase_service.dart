import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Registrasi user menggunakan Supabase Auth + simpan ke tabel `profil`
  Future<void> registerUser({
    required String namaLengkap,
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user != null) {
        // Simpan profil ke tabel `profil`
        await _client.from('profil').insert({
          'id': user.id,
          'nama_lengkap': namaLengkap,
          'email': email,
        });
      }
    } on AuthException catch (e) {
      throw Exception('Gagal registrasi: ${e.message}');
    } catch (e) {
      throw Exception('Kesalahan saat registrasi: $e');
    }
  }

  /// Login user menggunakan email dan password (Supabase Auth)
  Future<User?> login({required String email, required String password}) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response.user;
    } on AuthException catch (e) {
      throw Exception('Login gagal: ${e.message}');
    } catch (e) {
      throw Exception('Kesalahan saat login: $e');
    }
  }

  /// Ambil profil berdasarkan ID pengguna (dari Auth)
  Future<Map<String, dynamic>?> getprofilById(String userId) async {
    final profil =
        await _client.from('profil').select().eq('id', userId).maybeSingle();
    return profil;
  }

  /// Ambil semua user dari tabel `profil` (opsional)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await _client.from('profil').select();
    return List<Map<String, dynamic>>.from(response);
  }

  /// Cek apakah email sudah digunakan di `profil` (opsional, biasanya dicek via Auth)
  Future<bool> isEmailTaken(String email) async {
    final response =
        await _client
            .from('profil')
            .select('id')
            .eq('email', email)
            .maybeSingle();
    return response != null;
  }
}
