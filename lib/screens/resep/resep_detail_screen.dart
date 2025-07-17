// lib/screens/resep/resep_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../models/resep_model.dart';
import '../../utils/app_routes.dart';

class ResepDetailScreen extends StatefulWidget {
  final Resep resep;

  const ResepDetailScreen({super.key, required this.resep});

  @override
  State<ResepDetailScreen> createState() => _ResepDetailScreenState();
}

class _ResepDetailScreenState extends State<ResepDetailScreen> {
  String? avatarUrl;
  bool isFavorited = false;
  int jumlahFavorit = 0;

  @override
  void initState() {
    super.initState();
    fetchAvatar();
    jumlahFavorit = widget.resep.jumlahFavorit ?? 0;
    checkIfFavorited();
  }

  Future<void> fetchAvatar() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data =
          await supabase
              .from('profiles')
              .select('avatar_url')
              .eq('id', userId)
              .maybeSingle();

      if (data != null && mounted) {
        setState(() {
          avatarUrl = data['avatar_url'];
        });
      }
    } catch (e) {
      debugPrint('Gagal ambil avatar: $e');
    }
  }

  Future<void> checkIfFavorited() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final data =
        await supabase
            .from('favorits')
            .select()
            .eq('id_user', userId)
            .eq('id_resep', widget.resep.id)
            .maybeSingle();

    setState(() {
      isFavorited = data != null;
    });
  }

  Future<void> toggleFavorite() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    if (isFavorited) {
      await supabase
          .from('favorits')
          .delete()
          .eq('id_user', userId)
          .eq('id_resep', widget.resep.id);
      setState(() {
        isFavorited = false;
        jumlahFavorit -= 1;
      });
    } else {
      await supabase.from('favorits').insert({
        'id_user': userId,
        'id_resep': widget.resep.id,
      });
      setState(() {
        isFavorited = true;
        jumlahFavorit += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.resep.judul;
    final String image = widget.resep.imgResep ?? '';
    final String bahan = widget.resep.bahan;
    final String langkah = widget.resep.langkah;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E7),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F0E7),
        elevation: 0,
        title: const Text(
          'Detail Resep',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 195, 32),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.profile),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    avatarUrl != null && avatarUrl!.isNotEmpty
                        ? NetworkImage(avatarUrl!)
                        : null,
                child:
                    (avatarUrl == null || avatarUrl!.isEmpty)
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child:
                    image.startsWith('http')
                        ? Image.network(image, fit: BoxFit.cover)
                        : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 50),
                        ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Nama
                  Expanded(
                    child: Text(
                      'Oleh: ${widget.resep.name ?? "-"}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Tanggal
                  Expanded(
                    child: Text(
                      DateFormat(
                        'dd MMM yyyy',
                        'id_ID',
                      ).format(widget.resep.createdAt),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Favorit
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$jumlahFavorit',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol favorit
                  ElevatedButton.icon(
                    onPressed: toggleFavorite,
                    icon: Icon(
                      isFavorited
                          ? Icons.remove_circle_outline
                          : Icons.favorite_border,
                      size: 18,
                    ),
                    label: Text(
                      isFavorited ? 'Hapus' : 'Favorit',
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFavorited ? Colors.grey : Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Text(
              'Bahan-bahan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(bahan, style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Langkah-langkah',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(langkah, style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
