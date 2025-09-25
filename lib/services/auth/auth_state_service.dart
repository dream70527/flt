import 'package:get/get.dart';
import '../../models/user_info_entity.dart';
import '../../utils/storage_manager.dart';
import '../http_service.dart';

/// 认证状态管理服务
class AuthStateService extends GetxService {
  // 用户信息
  final Rxn<UserInfoEntity> userInfo = Rxn<UserInfoEntity>();
  
  // 登录状态
  final RxBool isLoggedIn = false.obs;
  
  // 重定向路由
  String? _redirectRoute;
  
  late final HttpService _httpService;
  
  @override
  void onInit() {
    super.onInit();
    _httpService = Get.find<HttpService>();
    _checkLoginStatus();
  }
  
  /// 检查登录状态
  void _checkLoginStatus() {
    try {
      final token = StorageManager.getToken();
      final userInfoData = StorageManager.getUserInfo();
      
      if (token != null && token.isNotEmpty && userInfoData != null) {
        if (!StorageManager.isTokenExpired()) {
          userInfo.value = UserInfoEntity.fromJson(userInfoData);
          isLoggedIn.value = true;
          _httpService.setAuthToken(token);
          print('从本地存储恢复登录状态: ${userInfo.value?.account}');
        } else {
          print('Token已过期，清除本地登录数据');
          StorageManager.clearLoginData();
        }
      }
    } catch (e) {
      print('检查登录状态出错: $e');
      StorageManager.clearLoginData();
    }
  }
  
  /// 设置登录状态
  Future<void> setLoginState(UserInfoEntity user) async {
    userInfo.value = user;
    isLoggedIn.value = true;
    
    if (user.token.isNotEmpty) {
      await StorageManager.saveToken(user.token);
      await StorageManager.saveUserInfo(user.toJson());
      _httpService.setAuthToken(user.token);
    }
  }
  
  /// 清除登录状态
  Future<void> clearLoginState() async {
    userInfo.value = null;
    isLoggedIn.value = false;
    
    await StorageManager.clearLoginData();
    _httpService.removeAuthToken();
  }
  
  /// 设置重定向路由
  void setRedirectRoute(String? route) {
    _redirectRoute = route;
  }
  
  /// 获取重定向路由并清除
  String? getAndClearRedirectRoute() {
    final route = _redirectRoute;
    _redirectRoute = null;
    return route;
  }
  
  /// 检查用户是否有特定角色权限
  bool hasRole(String role) {
    if (userInfo.value == null) return false;
    return isLoggedIn.value;
  }
}