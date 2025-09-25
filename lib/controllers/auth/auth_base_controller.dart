import 'package:get/get.dart';
import '../../models/user_info_entity.dart';
import '../../utils/storage_manager.dart';
import '../../services/http_service.dart';

/// 认证基础控制器 - 管理核心状态
abstract class AuthBaseController extends GetxController {
  // 用户信息
  final Rxn<UserInfoEntity> userInfo = Rxn<UserInfoEntity>();
  
  // 登录状态
  final RxBool isLoggedIn = false.obs;
  
  // HTTP服务
  late final HttpService _httpService;
  
  @override
  void onInit() {
    super.onInit();
    _httpService = Get.find<HttpService>();
    initializeAuthState();
  }
  
  /// 初始化认证状态
  void initializeAuthState() {
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
          onLoginStateRestored();
        } else {
          onTokenExpired();
        }
      }
    } catch (e) {
      onAuthError(e);
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
    
    onLoginSuccess();
  }
  
  /// 清除登录状态
  Future<void> clearLoginState() async {
    userInfo.value = null;
    isLoggedIn.value = false;
    
    await StorageManager.clearLoginData();
    _httpService.removeAuthToken();
    
    onLogoutComplete();
  }
  
  /// 检查权限
  bool hasRole(String role) {
    if (userInfo.value == null) return false;
    return isLoggedIn.value;
  }
  
  // 钩子方法 - 子类可以重写
  void onLoginStateRestored() {
    print('登录状态已恢复: ${userInfo.value?.account}');
  }
  
  void onTokenExpired() {
    print('Token已过期，清除本地登录数据');
    StorageManager.clearLoginData();
  }
  
  void onAuthError(dynamic error) {
    print('认证状态检查出错: $error');
    StorageManager.clearLoginData();
  }
  
  void onLoginSuccess() {
    print('登录成功: ${userInfo.value?.account}');
  }
  
  void onLogoutComplete() {
    print('退出登录完成');
  }
}