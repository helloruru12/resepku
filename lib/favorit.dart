import 'package:flutter/material.dart';
import 'package:resepku/home.dart';
import 'package:resepku/tambah.dart';

class HalamanFavorit extends StatelessWidget {
  const HalamanFavorit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EA), // warna krem dari gambar
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
                    'Favorit',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo1.png'), // Gambar chef
                    radius: 20,
                  ),
                ],
              ),
            ),

            // Item Favorit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _resepCard('Nasi Goreng', 'assets/images/logo1.png'),
                  const SizedBox(width: 12),
                  _resepCard('Donat Kentang', 'assets/images/logo1.png'),
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
                          MaterialPageRoute(builder: (_) => const HomePage()));
                    },
                    child: const Icon(Icons.home, size: 28),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const TambahPage()));
                    },
                    child: const Icon(Icons.add, size: 28),
                  ),
                  const Icon(Icons.favorite, size: 28, color: Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resepCard(String title, String imagePath) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 80,
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
