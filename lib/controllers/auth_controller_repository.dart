import 'package:get/get.dart';
import '../models/user_info_entity.dart';
import '../models/captcha_entity.dart';
import '../repositories/auth_repository.dart';
import '../services/http_service.dart';

/// 使用Repository模式的AuthController
class AuthControllerRepository extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  late final HttpService _httpService;
  
  // 用户信息
  final Rxn<UserInfoEntity> userInfo = Rxn<UserInfoEntity>();
  
  // 登录状态
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoginLoading = false.obs;
  
  // 验证码
  final Rxn<CaptchaEntity> captcha = Rxn<CaptchaEntity>();
  final RxBool isCaptchaLoading = false.obs;
  
  // 重定向路由
  String? _redirectRoute;
  
  @override
  void onInit() {
    super.onInit();
    _httpService = Get.find<HttpService>();
    _initializeAuth();
  }
  
  /// 初始化认证状态
  void _initializeAuth() {
    final user = _authRepository.getUserFromLocal();
    if (user != null) {
      userInfo.value = user;
      isLoggedIn.value = true;
      
      final token = _authRepository.getLocalToken();
      if (token != null) {
        _httpService.setAuthToken(token);
      }
    }
  }
  
  /// 获取验证码
  Future<void> getCaptcha() async {
    try {
      isCaptchaLoading.value = true;
      final result = await _authRepository.getCaptcha();
      captcha.value = result;
    } catch (e) {
      Get.snackbar('错误', e.toString());
    } finally {
      isCaptchaLoading.value = false;
    }
  }
  
  /// 登录
  Future<bool> login({
    String? account,
    String? password,
    required String captchaCode,
  }) async {
    if (captcha.value == null) {
      Get.snackbar('错误', '请先获取验证码');
      return false;
    }
    
    try {
      isLoginLoading.value = true;
      
      final result = await _authRepository.login(
        account: account ?? 'apitest',
        password: password ?? '123456',
        captchaKey: captcha.value!.key,
        captchaCode: captchaCode,
      );
      
      if (result != null) {
        // 更新内存状态
        userInfo.value = result;
        isLoggedIn.value = true;
        
        // 保存到本地存储
        await _authRepository.saveUserToLocal(result);
        
        // 设置HTTP认证
        if (result.token.isNotEmpty) {
          _httpService.setAuthToken(result.token);
        }
        
        Get.snackbar('成功', '登录成功');
        
        // 处理登录后跳转
        _handlePostLoginNavigation();
        
        return true;
      }
      
      return false;
    } catch (e) {
      Get.snackbar('登录失败', e.toString());
      await getCaptcha(); // 重新获取验证码
      return false;
    } finally {
      isLoginLoading.value = false;
    }
  }
  
  /// 退出登录
  Future<void> logout() async {
    try {
      // 清除内存状态
      userInfo.value = null;
      isLoggedIn.value = false;
      captcha.value = null;
      
      // 清除本地存储
      await _authRepository.clearLocalAuthData();
      
      // 移除HTTP认证
      _httpService.removeAuthToken();
      
      Get.snackbar('提示', '已退出登录');
    } catch (e) {
      Get.snackbar('错误', '退出登录时出现错误');
    }
  }
  
  /// 处理登录后导航
  void _handlePostLoginNavigation() {
    final redirectRoute = getAndClearRedirectRoute();
    if (redirectRoute != null && redirectRoute.isNotEmpty) {
      Get.offAllNamed(redirectRoute);
    } else {
      Get.offAllNamed('/main');
    }
  }
  
  /// 检查是否需要登录
  void checkAndLogin() {
    if (!isLoggedIn.value) {
      Get.toNamed('/login');
    }
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
  
  /// 刷新token
  Future<void> refreshToken() async {
    try {
      if (!isLoggedIn.value || userInfo.value == null) return;
      
      // TODO: 实现刷新token逻辑
      // 如果需要的话，可以在Repository中添加refreshToken方法
    } catch (e) {
      print('刷新token失败: $e');
    }
  }
}