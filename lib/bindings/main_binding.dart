import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/reward_controller.dart';
import '../controllers/account_controller.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_api_service.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthApiService>(() => AuthApiService());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<RewardController>(() => RewardController());
    Get.lazyPut<AccountController>(() => AccountController());
  }
}