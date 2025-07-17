import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../main.dart';
import '../../models/profile_model.dart';
import '../../models/resep_model.dart';
import '../../services/supabase_service.dart';
import '../../utils/app_routes.dart';
import '../resep/resep_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  Profile? _profile;
  bool _isLoading = true;
  bool _isEditing = false;

  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _avatarUrl;

  List<Resep> resepList = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadUserReseps();
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

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final data = await _supabaseService.getProfile();
      if (data != null) {
        setState(() {
          _profile = Profile.fromJson(data);
          _usernameController.text = _profile!.username;
          _nameController.text = _profile!.name ?? '';
          _avatarUrl = _profile!.avatarUrl;
        });
      }
    } catch (e) {
      showErrorSnackbar('Gagal memuat profil: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadUserReseps() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await supabase
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
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      setState(() {
        resepList =
            (response as List)
                .map((data) => Resep.fromJson(data as Map<String, dynamic>))
                .toList();
      });
    } catch (e) {
      debugPrint('Gagal memuat resep user: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (_usernameController.text.isEmpty) {
      showErrorSnackbar('Username tidak boleh kosong');
      return;
    }

    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      showErrorSnackbar('Password dan konfirmasi tidak cocok');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _supabaseService.updateProfile(
        username: _usernameController.text,
        name: _nameController.text,
        avatarUrl: _avatarUrl,
      );

      if (_passwordController.text.isNotEmpty) {
        await _supabaseService.updatePassword(_passwordController.text);
      }

      showSuccessSnackbar('Profil berhasil diperbarui');
      setState(() => _isEditing = false);
      _passwordController.clear();
      _confirmPasswordController.clear();
      _loadProfile();
    } catch (e) {
      showErrorSnackbar('Gagal memperbarui profil: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadAvatar() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) return;

    setState(() => _isLoading = true);
    try {
      final fileName =
          '${supabase.auth.currentUser!.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      String imageUrl;

      if (kIsWeb) {
        final imageBytes = await imageFile.readAsBytes();
        imageUrl = await _supabaseService.uploadImageBytes(
          imageBytes,
          'avatars',
          fileName,
        );
      } else {
        final file = File(imageFile.path);
        imageUrl = await _supabaseService.uploadImage(
          file,
          'avatars',
          fileName,
        );
      }

      setState(() => _avatarUrl = imageUrl);
      await _updateProfile();
    } catch (e) {
      showErrorSnackbar('Gagal mengupload avatar: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await supabase.auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed(AppRoutes.beranda),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F0E7),
        elevation: 0,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Color(0xFFFFC320),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: _signOut,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _profile == null
              ? const Center(child: Text('Gagal memuat profil.'))
              : NestedScrollView(
                headerSliverBuilder:
                    (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: _uploadAvatar,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      _avatarUrl != null
                                          ? NetworkImage(_avatarUrl!)
                                          : null,
                                  child:
                                      _avatarUrl == null
                                          ? const Icon(Icons.person, size: 60)
                                          : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: _uploadAvatar,
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Ganti Avatar'),
                              ),
                              const SizedBox(height: 24),
                              _isEditing
                                  ? TextField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                                  : _buildDisplayBox(
                                    label: 'Username',
                                    value: _usernameController.text,
                                  ),
                              const SizedBox(height: 16),
                              _isEditing
                                  ? TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Nama Lengkap',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                                  : _buildDisplayBox(
                                    label: 'Nama Lengkap',
                                    value: _nameController.text,
                                  ),
                              if (_isEditing) ...[
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password Baru (Opsional)',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Konfirmasi Password Baru',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: Icon(
                                        _isEditing ? Icons.save : Icons.edit,
                                      ),
                                      label: Text(
                                        _isEditing ? 'Simpan' : 'Edit Profil',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_isEditing) {
                                          _updateProfile();
                                        } else {
                                          setState(() => _isEditing = true);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFFFC320,
                                        ),
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_isEditing) const SizedBox(width: 12),
                                  if (_isEditing)
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        icon: const Icon(Icons.close),
                                        label: const Text(
                                          'Batal',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isEditing = false;
                                            _usernameController.text =
                                                _profile!.username;
                                            _nameController.text =
                                                _profile!.name ?? '';
                                            _passwordController.clear();
                                            _confirmPasswordController.clear();
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _StickyHeaderDelegate(
                          child: Container(
                            color: const Color(0xFFF5F0E7),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Resep Saya',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child:
                      resepList.isEmpty
                          ? const Text('Belum ada resep yang ditambahkan.')
                          : ListView.builder(
                            itemCount: resepList.length,
                            itemBuilder: (context, index) {
                              final resep = resepList[index];
                              final createdAt = resep.createdAt;
                              final formattedDate =
                                  '${createdAt.day.toString().padLeft(2, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year}';

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 2,
                                  ),
                                  leading: const Icon(
                                    Icons.receipt_long,
                                    color: Color(0xFFFFC320),
                                  ),
                                  title: Text(
                                    resep.judul,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    formattedDate,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onTap: () {
                                    Get.to(
                                      () => ResepDetailScreen(resep: resep),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                ),
              ),
    );
  }

  Widget _buildDisplayBox({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return false;
  }
}
