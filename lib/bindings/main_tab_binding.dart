import 'package:get/get.dart';
import '../controllers/main_tab_controller.dart';
import '../controllers/main_controller.dart';
import '../modules/home/controllers/home_controller.dart';
import '../controllers/discover_controller.dart';
import '../modules/reward/controllers/reward_controller.dart';
import '../controllers/account_controller.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_api_service.dart';

class MainTabBinding extends Bindings {
  @override
  void dependencies() {
    // 全局服务
    Get.lazyPut<AuthApiService>(() => AuthApiService());
    Get.lazyPut<AuthController>(() => AuthController());
    
    // Tab控制器
    Get.put<MainTabController>(MainTabController(), permanent: true);
    Get.put<MainController>(MainController(), permanent: true);
    
    // 所有tab页面的控制器都设为永久实例
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<DiscoverController>(DiscoverController(), permanent: true);
    Get.put<RewardController>(RewardController(), permanent: true);
    Get.put<AccountController>(AccountController(), permanent: true);
  }
}