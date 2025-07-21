// lib/screens/resep/resep_form_screen.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../main.dart';
import '../../../../models/resep_model.dart';
import '../../../../services/supabase_service.dart';
import '../../../../widgets/custom_input_field.dart';
import '../../../../utils/app_routes.dart';

class ResepFormScreen extends StatefulWidget {
  const ResepFormScreen({super.key});

  @override
  State<ResepFormScreen> createState() => _ResepFormScreenState();
}

class _ResepFormScreenState extends State<ResepFormScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _bahanController = TextEditingController();
  final _langkahController = TextEditingController();

  bool _isLoading = false;
  Resep? _existingResep;
  XFile? _imageFile;
  String? _existingImageUrl;
  String? avatarUrl;

  @override
  void initState() {
    super.initState();

    if (Get.arguments is Resep) {
      _existingResep = Get.arguments as Resep;
      _judulController.text = _existingResep!.judul;
      _bahanController.text = _existingResep!.bahan;
      _langkahController.text = _existingResep!.langkah;
      _existingImageUrl = _existingResep!.imgResep;
    }

    fetchAvatar();
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        String? imageUrl = _existingImageUrl;
        if (_imageFile != null) {
          final fileName =
              '${supabase.auth.currentUser!.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';
          if (kIsWeb) {
            final imageBytes = await _imageFile!.readAsBytes();
            imageUrl = await _supabaseService.uploadImageBytes(
              imageBytes,
              'reseps-images',
              fileName,
            );
          } else {
            final file = File(_imageFile!.path);
            imageUrl = await _supabaseService.uploadImage(
              file,
              'reseps-images',
              fileName,
            );
          }
        }

        final now = DateTime.now().toUtc().toIso8601String();
        await _supabaseService.insertResep({
          'judul': _judulController.text,
          'bahan': _bahanController.text,
          'langkah': _langkahController.text,
          'img_resep': imageUrl,
          'created_at': now,
        });

        Get.back(result: true);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal menyimpan resep: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _bahanController.dispose();
    _langkahController.dispose();
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
          'Tambah Resep',
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child:
                      _imageFile != null
                          ? (kIsWeb
                              ? Image.network(
                                _imageFile!.path,
                                fit: BoxFit.cover,
                              )
                              : Image.file(
                                File(_imageFile!.path),
                                fit: BoxFit.cover,
                              ))
                          : (_existingImageUrl != null
                              ? Image.network(
                                _existingImageUrl!,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const Icon(Icons.image, size: 50),
                              )),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pilih Gambar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              CustomInputField(
                controller: _judulController,
                labelText: 'Judul Resep',
                validator:
                    (value) =>
                        value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _bahanController,
                labelText: 'Bahan-Bahan',
                maxLines: 5,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Bahan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _langkahController,
                labelText: 'Langkah-Langkah',
                maxLines: 6,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Langkah tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
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
          _bottomIcon(
            Icons.home,
            onTap: () {
              Get.offAllNamed(AppRoutes.beranda);
            },
            isActive: false,
          ),
          _bottomIcon(Icons.add, onTap: () {}, isActive: true),
          _bottomIcon(
            Icons.favorite,
            onTap: () {
              Get.offAllNamed(AppRoutes.favorit);
            },
            isActive: false,
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