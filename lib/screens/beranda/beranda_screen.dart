// lib/screens/beranda/beranda_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/resep_model.dart';
import '../../utils/app_routes.dart';
import '../resep/resep_detail_screen.dart';
// import '../resep/resep_form_screen.dart';
import 'package:intl/intl.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Resep> _reseps = [];
  List<Resep> _filteredReseps = [];
  bool _isLoading = true;
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadReseps();
    fetchAvatar();
    _searchController.addListener(_filterReseps);
  }

  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Sukses',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      maxWidth: 300,
      duration: const Duration(seconds: 2),
    );
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      maxWidth: 300,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> fetchAvatar() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final data =
          await Supabase.instance.client
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

  Future<void> _loadReseps() async {
    try {
      final response = await Supabase.instance.client
          .from('reseps')
          .select('''
            id,
            user_id,
            judul,
            bahan,
            langkah,
            img_resep,
            created_at,
            jumlah_favorit,
            profiles(name)
          ''')
          .order('created_at', ascending: false);

      final resepList =
          (response as List).map((json) => Resep.fromJson(json)).toList();

      setState(() {
        _reseps = resepList;
        _filteredReseps = resepList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showErrorSnackbar('Gagal memuat data resep: $e');
    }
  }

  void _filterReseps() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredReseps =
          _reseps.where((r) => r.judul.toLowerCase().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF5F0E7),
        elevation: 0,
        title: const Text(
          'ResepKu',
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
                    avatarUrl == null || avatarUrl!.isEmpty
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
              ),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari resep...',
                        suffixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child:
                          _filteredReseps.isEmpty
                              ? const Center(
                                child: Text('Tidak ada resep ditemukan.'),
                              )
                              : RefreshIndicator(
                                onRefresh: _loadReseps,
                                child: GridView.builder(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  itemCount: _filteredReseps.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                        childAspectRatio: 1,
                                      ),
                                  itemBuilder: (context, index) {
                                    final resep = _filteredReseps[index];
                                    return GestureDetector(
                                      onTap:
                                          () => Get.to(
                                            () =>
                                                ResepDetailScreen(resep: resep),
                                          ),
                                      child: _resepCard(resep),
                                    );
                                  },
                                ),
                              ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _resepCard(Resep resep) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Gambar 40%
              SizedBox(
                height: totalHeight * 0.6,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child:
                      resep.imgResep != null
                          ? Image.network(resep.imgResep!, fit: BoxFit.cover)
                          : Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, size: 50),
                          ),
                ),
              ),
              const SizedBox(height: 8),
              // Judul 20%
              SizedBox(
                height: totalHeight * 0.1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      resep.judul,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),

              // Nama dan Tanggal 20%
              if (resep.name != null)
                SizedBox(
                  height: totalHeight * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Oleh: ${resep.name}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateFormat(
                            'dd MMM yyyy',
                            'id_ID',
                          ).format(resep.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              // Icon Favorite 20%
              SizedBox(
                height: totalHeight * 0.1,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${resep.jumlahFavorit ?? 0}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _bottomIcon(Icons.home, onTap: () {}, isActive: true),
          _bottomIcon(
            Icons.add,
            onTap: () async {
              // final result = await Get.to(() => const ResepFormScreen());
              // if (result == true) {
              //   await _loadReseps();
              //   showSuccessSnackbar('Resep berhasil ditambahkan!');
              // }
            },
          ),
          _bottomIcon(
            Icons.favorite,
            onTap: () => Get.offAllNamed(AppRoutes.favorit),
          ),
        ],
      ),
    );
  }

  Widget _bottomIcon(
    IconData icon, {
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 28,
            color: isActive ? Colors.amber : Colors.black87,
          ),
        ),
      ),
    );
  }
}
