import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // -----------------------
  // UPLOAD GAMBAR
  // -----------------------

  // Mobile
  Future<String> uploadImage(
    File file,
    String bucketName,
    String fileName,
  ) async {
    final bytes = await file.readAsBytes();
    await supabase.storage
        .from(bucketName)
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    return supabase.storage.from(bucketName).getPublicUrl(fileName);
  }

  // Web
  Future<String> uploadImageBytes(
    Uint8List bytes,
    String bucketName,
    String fileName,
  ) async {
    await supabase.storage
        .from(bucketName)
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    return supabase.storage.from(bucketName).getPublicUrl(fileName);
  }

  // -----------------------
  // PROFILE PENGGUNA
  // -----------------------

  Future<Map<String, dynamic>?> getProfile() async {
    final userId = supabase.auth.currentUser!.id;
    final data =
        await supabase.from('profiles').select().eq('id', userId).single();
    return data;
  }

  Future<void> updateProfile({
    required String username,
    String? avatarUrl,
    String? name,
  }) async {
    final userId = supabase.auth.currentUser!.id;
    final updates = {
      'id': userId,
      'username': username,
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (name != null) updates['name'] = name;

    await supabase.from('profiles').upsert(updates);
  }

  Future<void> updatePassword(String newPassword) async {
    await supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  // -----------------------
  // CRUD RESEP
  // -----------------------

  Future<void> insertResep(Map<String, dynamic> data) async {
    final userId = supabase.auth.currentUser!.id;
    final resepData = {...data, 'user_id': userId};
    await supabase.from('reseps').insert(resepData);
  }

  Future<void> updateResep(int id, Map<String, dynamic> data) async {
    await supabase.from('reseps').update(data).eq('id', id);
  }

  Future<void> deleteResep(int id) async {
    await supabase.from('reseps').delete().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> getAllReseps() async {
    final userId = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('reseps')
        .select()
        .eq('user_id', userId)
        .order('tanggal', ascending: false);
    return data;
  }

  Future<List<Map<String, dynamic>>> getAllResepsWithProfile() async {
    final data = await supabase
        .from('reseps')
        .select('''
          id,
          user_id,
          judul,
          bahan,
          langkah,
          img_resep,
          tanggal,
          jumlah_favorit,
          profiles(name)
        ''')
        .order('tanggal', ascending: false);
    return data;
  }
}
