import 'package:get/get.dart';
import 'package:resepku/login.dart';
import 'package:resepku/regis.dart';
import 'package:resepku/splashscreen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const Regis()),
  ];
}
