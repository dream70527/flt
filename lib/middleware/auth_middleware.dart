import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // 检查是否已登录
    if (!authController.isLoggedIn.value) {
      // 保存原始路由，登录成功后跳转回去
      authController.setRedirectRoute(route);
      // 重定向到登录页面
      return const RouteSettings(name: Routes.login);
    }
    
    return null; // 不重定向，继续访问原页面
  }
}

// 可选：创建更灵活的权限中间件
class PermissionMiddleware extends GetMiddleware {
  final String requiredRole;
  
  PermissionMiddleware({required this.requiredRole});

  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // 先检查是否登录
    if (!authController.isLoggedIn.value) {
      authController.setRedirectRoute(route);
      return const RouteSettings(name: Routes.login);
    }
    
    // 检查权限
    if (!authController.hasRole(requiredRole)) {
      Get.snackbar(
        '权限不足', 
        '您没有访问此页面的权限',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return const RouteSettings(name: Routes.home);
    }
    
    return null;
  }
}