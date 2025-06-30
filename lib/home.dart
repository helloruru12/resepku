import 'package:flutter/material.dart';
// import 'package:resepku/profil.dart';
// import 'package:resepku/tambah.dart';
import 'package:resepku/favorit.dart';
import 'package:resepku/detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> semuaResep = [
    {
      'title': 'Nasi Goreng',
      'image': 'assets/images/logo1.png',
      'bahan':
          '- 2 piring nasi\n- 1 telur\n- 2 siung bawang putih\n- Kecap manis\n- Garam\n- Minyak goreng',
      'langkah':
          '1. Tumis bawang putih hingga harum\n2. Masukkan telur dan orak-arik\n3. Tambahkan nasi, kecap, dan garam\n4. Aduk rata dan sajikan',
    },
    {
      'title': 'Mie Goreng',
      'image': 'assets/images/logo1.png',
      'bahan':
          '- 1 bungkus mie instan\n- 1 telur\n- Sayuran (kol, sawi)\n- Bumbu mie instan',
      'langkah':
          '1. Rebus mie hingga matang\n2. Tumis telur dan sayuran\n3. Masukkan mie dan bumbu, aduk rata\n4. Sajikan hangat',
    },
    {
      'title': 'Donat Kentang',
      'image': 'assets/images/logo1.png',
      'bahan':
          '- 500 gr kentang kukus\n- 250 gr tepung terigu\n- 2 butir telur\n- Ragi instan\n- Gula & garam secukupnya',
      'langkah':
          '1. Haluskan kentang, campur bahan lain\n2. Uleni hingga kalis\n3. Bentuk bulat, diamkan hingga mengembang\n4. Goreng hingga kuning keemasan',
    },
    {
      'title': 'Es Teler',
      'image': 'assets/images/logo1.png',
      'bahan':
          '- Alpukat\n- Kelapa muda\n- Nangka\n- Sirup cocopandan\n- Susu kental manis\n- Es serut',
      'langkah':
          '1. Siapkan semua buah\n2. Tata dalam gelas\n3. Tambahkan es, sirup, dan susu\n4. Sajikan dingin',
    },
    {
      'title': 'Ayam Bakar',
      'image': 'assets/images/logo1.png',
      'bahan':
          '- 1 ekor ayam potong\n- Bawang merah & putih\n- Kecap manis\n- Ketumbar, garam\n- Air jeruk nipis',
      'langkah':
          '1. Haluskan bumbu, lumuri ayam\n2. Diamkan 1 jam\n3. Bakar ayam sambil dioles bumbu\n4. Sajikan dengan sambal',
    },
    {
      'title': 'Sate Ayam',
      'image': 'assets/images/logo1.png',
      'bahan':
          '- Daging ayam potong dadu\n- Bumbu kacang\n- Kecap manis\n- Tusuk sate',
      'langkah':
          '1. Tusuk ayam ke tusuk sate\n2. Bakar sambil dioles kecap\n3. Sajikan dengan bumbu kacang',
    },
  ];

  List<Map<String, String>> filteredResep = [];

  @override
  void initState() {
    super.initState();
    filteredResep = semuaResep;
    _searchController.addListener(_filterResep);
  }

  void _filterResep() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredResep =
          semuaResep
              .where((resep) => resep['title']!.toLowerCase().contains(query))
              .toList();
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

      body: Padding(
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
                  vertical: 0,
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
              child: GridView.builder(
                itemCount: filteredResep.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final resep = filteredResep[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DetailResepPage(
                                title: resep['title']!,
                                image: resep['image']!,
                                bahan: resep['bahan'] ?? '',
                                langkah: resep['langkah'] ?? '',
                              ),
                        ),
                      );
                    },
                    child: _resepCard(resep['title']!, resep['image']!),
                  );
                },
              ),
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const HomePage()),
                  // );
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

  Widget _resepCard(String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ClipRRect(
              child: AspectRatio(
                aspectRatio: 3 / 2,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
