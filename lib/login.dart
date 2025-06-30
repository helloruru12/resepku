import 'package:flutter/material.dart';
import 'package:resepku/regis.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EE), // Warna latar belakang krem
      body: Center(
        child: SingleChildScrollView(
          // Menggunakan SingleChildScrollView agar keyboard tidak menutupi input
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  // fontFamily: 'Montserrat', // Contoh font, jika ada
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Username',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none, // Menghilangkan border
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true, // Untuk menyembunyikan teks password
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none, // Menghilangkan border
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, // Membuat tombol full width
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi saat tombol Login ditekan (saat ini kosong)
                    print('Tombol Login ditekan!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFE4A700,
                    ), // Warna tombol kuning
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0, // Menghilangkan shadow
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Belum punya akun?',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to the RegisterScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Regis(),
                        ),
                      );
                      print('Tombol Register ditekan!');
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
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
}
