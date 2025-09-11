import 'package:get/get.dart';
import '../pages/main_page.dart';
import '../pages/login_page.dart';
import '../pages/game_page.dart';
import '../pages/settings_page.dart';
import '../pages/about_page.dart';
import '../pages/layout_demo_page.dart';
import '../bindings/main_binding.dart';
import '../bindings/auth_binding.dart';
import '../bindings/game_binding.dart';
import '../bindings/about_binding.dart';
import 'routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.game,
      page: () => const GamePage(),
      binding: GameBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
    ),
    GetPage(
      name: Routes.about,
      page: () => const AboutPage(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: Routes.layoutDemo,
      page: () => const LayoutDemoPage(),
    ),
  ];
}