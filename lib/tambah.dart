import 'package:flutter/material.dart';
import 'package:resepku/favorit.dart';
import 'package:resepku/home.dart';
import 'package:file_picker/file_picker.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  String? _selectedFileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
    } else {
      setState(() {
        _selectedFileName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () {},
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profil.png'),
                radius: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah Resep Baru',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nama Resep',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Row dua kotak: choose file + nama file
              Row(
                children: [
                  // Tombol "Choose File"
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.image),
                        label: const Text('Choose file'),
                        onPressed: _pickFile,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Keterangan Nama File
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 48,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFFF5F0E7), // sama dengan background
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.insert_drive_file_rounded, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedFileName ?? 'Belum ada file',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const TextField(
                decoration: InputDecoration(
                  labelText: 'Bahan-bahan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              const TextField(
                decoration: InputDecoration(
                  labelText: 'Langkah-langkah',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Resep disimpan')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1E332),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Home
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.home, size: 28),
                ),
              ),
            ),

            // Tambah (aktif)
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {}, // sedang di halaman ini
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add, size: 28, color: Colors.orange),
                ),
              ),
            ),

            // Favorit
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HalamanFavorit()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
