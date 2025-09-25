import 'package:claudecodeflt/pages/dropdown_demo_page.dart';
import 'package:claudecodeflt/pages/grid_selection_page.dart';
import 'package:claudecodeflt/pages/horizontal_image_list_page.dart';
import 'package:get/get.dart';
import '../pages/login_page.dart';
import '../pages/game_page.dart';
import '../pages/settings_page.dart';
import '../pages/about_page.dart';
import '../pages/layout_demo_page.dart';
import '../pages/dashed_container_demo.dart';
import '../pages/admin_page.dart';
import '../pages/main_tab_container.dart';
import '../pages/optimized_demo_page.dart';
import '../modules/reward/pages/reward_page.dart';
import '../modules/reward/views/tree_simulation_demo.dart';
import '../pages/dialog_demo_page.dart';
import '../bindings/main_tab_binding.dart';
import '../bindings/auth_binding.dart';
import '../bindings/game_binding.dart';
import '../bindings/about_binding.dart';
import '../modules/reward/bindings/reward_binding.dart';
import '../bindings/dialog_binding.dart';
import '../middleware/auth_middleware.dart';
import 'routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const MainTabContainer(),
      binding: MainTabBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.main,
      page: () => const MainTabContainer(),
      binding: MainTabBinding(),
      transition: Transition.noTransition,
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
      middlewares: [AuthMiddleware()], // 需要登录才能玩游戏
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      middlewares: [AuthMiddleware()], // 需要登录才能访问设置页面
    ),
    GetPage(
      name: Routes.about,
      page: () => const AboutPage(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: Routes.reward,
      page: () => const RewardPage(),
      binding: RewardBinding(),
    ),
    GetPage(
      name: Routes.layoutDemo,
      page: () => const LayoutDemoPage(),
    ),
    GetPage(
      name: Routes.dashedContainerDemo,
      page: () => const DashedContainerDemo(),
    ),
    GetPage(
      name: Routes.treeSimulation,
      page: () => const TreeSimulationDemo(),
    ),
    GetPage(
      name: Routes.dialogDemo,
      page: () => const DialogDemoPage(),
      binding: DialogBinding(),
    ),
    GetPage(
      name: Routes.dropdownDemo,
      page: () => const DropdownDemoPage(),
    ),
    GetPage(
      name: Routes.gridSelection,
      page: () => const GridSelectionPage(),
    ),
    GetPage(
      name: Routes.horizontalImageList,
      page: () => const HorizontalImageListPage(),
    ),
    // 演示权限控制的页面
    GetPage(
      name: Routes.admin,
      page: () => const AdminPage(),
      middlewares: [PermissionMiddleware(requiredRole: 'admin')], // 需要admin权限
    ),
    
    // Tab pages - 现在都指向同一个容器，通过参数区分
    GetPage(
      name: Routes.tabHome,
      page: () => const MainTabContainer(),
      binding: MainTabBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.tabDiscover,
      page: () => const MainTabContainer(),
      binding: MainTabBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.tabReward,
      page: () => const MainTabContainer(),
      binding: MainTabBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.tabAccount,
      page: () => const MainTabContainer(),
      binding: MainTabBinding(),
      transition: Transition.noTransition,
    ),
  ];
}