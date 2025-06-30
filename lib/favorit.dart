import 'package:flutter/material.dart';
import 'package:resepku/home.dart';
import 'package:resepku/tambah.dart';
import 'package:resepku/detail.dart';

class HalamanFavorit extends StatelessWidget {
  const HalamanFavorit({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> resepFavorit = [
      {
        'title': 'Nasi Goreng',
        'image': 'assets/images/logo1.png',
        'bahan': 'Nasi, Bawang Merah, Bawang Putih, Telur, Kecap, Garam',
        'langkah': '1. Tumis bumbu\n2. Masukkan telur\n3. Tambahkan nasi\n4. Tambah kecap & garam\n5. Aduk rata'
      },
      {
        'title': 'Mie Goreng',
        'image': 'assets/images/logo1.png',
        'bahan': 'Mie, Sayur, Telur, Kecap, Bumbu instan',
        'langkah': '1. Rebus mie\n2. Tumis bumbu dan sayur\n3. Masukkan mie dan telur\n4. Aduk rata'
      },
      {
        'title': 'Donat Kentang',
        'image': 'assets/images/logo1.png',
        'bahan': 'Kentang, Tepung Terigu, Telur, Ragi, Gula',
        'langkah': '1. Campur semua bahan\n2. Diamkan 1 jam\n3. Bentuk donat\n4. Goreng hingga matang'
      },
      {
        'title': 'Es Teler',
        'image': 'assets/images/logo1.png',
        'bahan': 'Alpukat, Kelapa muda, Nangka, Sirup, Es serut',
        'langkah': '1. Potong buah\n2. Masukkan ke mangkuk\n3. Tambah sirup dan susu\n4. Sajikan dengan es serut'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E7),

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F0E7),
        elevation: 0,
        title: const Text(
          'Favorit Resep',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            itemCount: resepFavorit.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1/1,
            ),
            itemBuilder: (context, index) {
              final resep = resepFavorit[index];
              return _resepCard(
                title: resep['title']!,
                image: resep['image']!,
                bahan: resep['bahan']!,
                langkah: resep['langkah']!,
                context: context,
              );
            },
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
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.home, size: 28),
                ),
              ),
            ),

            // Tambah
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TambahPage()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add, size: 28),
                ),
              ),
            ),

            // Favorit aktif
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {}, // halaman aktif
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite, size: 28, color: Colors.orange),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resepCard({
    required String title,
    required String image,
    required String bahan,
    required String langkah,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailResepPage(
              title: title,
              image: image,
              bahan: bahan,
              langkah: langkah,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
