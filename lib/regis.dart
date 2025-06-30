import 'package:flutter/material.dart';

void main() {
  runApp(const Regis());
}

class Regis extends StatelessWidget {
  const Regis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF7F5EE,
      ), // Warna latar belakang krem, sama dengan Login
      body: Center(
        child: SingleChildScrollView(
          // Menggunakan SingleChildScrollView agar keyboard tidak menutupi input
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ), // Padding yang sama dengan Login
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Registrasi', // Judul halaman
                style: TextStyle(
                  fontSize: 40, // Ukuran font sama dengan Login
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  // fontFamily: 'Montserrat', // Contoh font, jika ada
                ),
              ),
              const SizedBox(height: 50), // Spasi yang sama
              _buildTextField(
                'Nama Lengkap',
              ), // Menggunakan helper untuk TextField
              const SizedBox(height: 20),
              _buildTextField('Username'),
              const SizedBox(height: 20),
              _buildTextField('Password', obscureText: true),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, // Membuat tombol full width
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika untuk proses registrasi di sini
                    print('Tombol Register ditekan!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFE4A700,
                    ), // Warna tombol kuning, sama dengan Login
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ), // Radius border sama dengan Login
                    ),
                    elevation: 0, // Tanpa elevasi, sama dengan Login
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18, // Ukuran font sama dengan Login
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.white, // Warna teks putih, sama dengan Login
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                // Menggunakan Row untuk teks "Sudah punya akun? Login"
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sudah punya akun?',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      // Kembali ke halaman Login
                      Navigator.pop(context); // Menghapus rute Regis dari stack
                      print('Tombol Login ditekan!');
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Warna biru, sama dengan Login
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method untuk membangun TextField agar konsisten
  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText, // Menggunakan hintText agar konsisten
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Radius border sama
          borderSide: BorderSide.none, // Menghilangkan border
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 20.0,
        ),
      ),
      style: const TextStyle(color: Colors.black), // Gaya teks input
    );
  }
}
