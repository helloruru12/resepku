import 'package:flutter/material.dart';
import 'package:resepku/login.dart';
import 'package:resepku/splashscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://silrdympepkqpiuxvadh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpbHJkeW1wZXBrcXBpdXh2YWRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5MjY0NjksImV4cCI6MjA2NzUwMjQ2OX0.ARMa6jG-WQyUfzxE0SPLhtFG6sVc8FBMPCCCsmXEZ64',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
