import 'package:flutter/material.dart';
import 'package:resepku/splashscreen.dart';
<<<<<<< HEAD
import 'package:resepku/regis.dart';
=======
import 'package:resepku/home.dart';
>>>>>>> c6c5f675bf5dc641c802a9080689e73c35352e0f

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}
