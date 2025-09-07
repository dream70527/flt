import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_api_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthApiService>(() => AuthApiService());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}