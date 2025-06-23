import 'package:flutter/material.dart';
import 'package:resepku/favorit.dart';
import 'package:resepku/home.dart';

class TambahPage extends StatelessWidget {
  const TambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tambah Resep',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo1.png'),
                    radius: 20,
                  ),
                ],
              ),
            ),

            // Form input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Nama Resep',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tombol unggah file (simulasi)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text('Choose file'),
                      onPressed: () {
                        // simulasi pilih gambar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur upload belum tersedia')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Bahan-bahan',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),

                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Langkah-langkah',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Resep disimpan')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Navigation
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const HalamanFavorit()));
                    },
                    child: const Icon(Icons.home, size: 28),
                  ),
                  const Icon(Icons.add, size: 28, color: Colors.orange),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const HalamanFavorit()));
                    },
                    child: const Icon(Icons.favorite, size: 28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
