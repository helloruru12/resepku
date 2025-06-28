import 'package:flutter/material.dart';
import 'package:resepku/home.dart';
import 'package:resepku/splashscreen.dart';
import 'package:resepku/favorit.dart';
import 'package:resepku/detail.dart';
import 'package:resepku/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ResepKu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
