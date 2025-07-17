// lib/utils/app_routes.dart

import 'package:get/get.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/beranda/beranda_screen.dart';
import '../../screens/profile/profile_screen.dart';
// import '../../screens/favorit/favorit_screen.dart';
import '../../screens/splash_screen.dart';
import '../../screens/resep/resep_detail_screen.dart';
import '../../models/resep_model.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String beranda = '/beranda';
  static const String profile = '/profile';
  static const String favorit = '/favorit';
  static const String resepDetail = '/rDetail';

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: beranda, page: () => const BerandaScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    // GetPage(name: favorit, page: () => const FavoritScreen()),
    GetPage(
      name: resepDetail,
      page: () {
        final resep = Get.arguments as Resep;
        return ResepDetailScreen(resep: resep);
      },
    ),
  ];
}
