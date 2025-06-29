import 'package:flutter/material.dart';
// import 'package:resepku/profil.dart';
// import 'package:resepku/tambah.dart';
import 'package:resepku/favorit.dart';
import 'package:resepku/home.dart';

class DetailResepPage extends StatelessWidget {
  final String title;
  final String image;
  final String bahan;
  final String langkah;

  const DetailResepPage({
    super.key,
    required this.title,
    required this.image,
    required this.bahan,
    required this.langkah,
  });

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
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder:
                //         (context) => const HalamanProfil(
                //           username: 'user123',
                //           nama: 'Budi Santoso',
                //           email: 'budi@gmail.com',
                //         ),
                //   ),
                // );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profil.png'),
                radius: 20,
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
                boxShadow: [
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

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 20),

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
          ],
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
                  Navigator.push(
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

            // Add
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const TambahResep(),
                  //   ),
                  // );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add, size: 28),
                ),
              ),
            ),

            // Favorite
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HalamanFavorit(),
                    ),
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
