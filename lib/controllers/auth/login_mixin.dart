import 'package:get/get.dart';
import '../../services/auth_api_service.dart';
import 'auth_base_controller.dart';
import 'captcha_mixin.dart';

/// 登录功能Mixin
mixin LoginMixin on AuthBaseController, CaptchaMixin {
  final AuthApiService _authApiService = AuthApiService();
  final RxBool isLoginLoading = false.obs;
  
  // 重定向路由
  String? _redirectRoute;
  
  /// 登录
  Future<bool> login({
    String? account,
    String? password,
    required String captchaCode,
  }) async {
    if (!isValidCaptcha()) {
      onLoginValidationError('请先获取验证码');
      return false;
    }
    
    try {
      isLoginLoading.value = true;
      onLoginStart();
      
      final result = await _authApiService.login(
        account: account ?? 'apitest',
        password: password ?? '123456',
        captchaKey: captcha.value!.key,
        captchaCode: captchaCode,
      );
      
      if (result != null) {
        await setLoginState(result);
        onLoginSuccessComplete();
        await handlePostLoginNavigation();
        return true;
      }
      
      onLoginFailed('登录失败');
      return false;
    } catch (e) {
      onLoginException(e);
      await getCaptcha(); // 重新获取验证码
      return false;
    } finally {
      isLoginLoading.value = false;
      onLoginEnd();
    }
  }
  
  /// 退出登录
  Future<void> logout() async {
    try {
      onLogoutStart();
      await clearLoginState();
      clearCaptcha();
      onLogoutSuccessComplete();
    } catch (e) {
      onLogoutError(e);
    }
  }
  
  /// 处理登录后导航
  Future<void> handlePostLoginNavigation() async {
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
  
  // 钩子方法
  void onLoginStart() {
    print('开始登录...');
  }
  
  void onLoginEnd() {
    print('登录流程结束');
  }
  
  void onLoginValidationError(String message) {
    Get.snackbar('错误', message);
  }
  
  void onLoginSuccessComplete() {
    Get.snackbar('成功', '登录成功');
  }
  
  void onLoginFailed(String message) {
    Get.snackbar('登录失败', message);
  }
  
  void onLoginException(dynamic error) {
    Get.snackbar('登录失败', error.toString());
    print('登录异常: $error');
  }
  
  void onLogoutStart() {
    print('开始退出登录...');
  }
  
  void onLogoutSuccessComplete() {
    Get.snackbar('提示', '已退出登录');
  }
  
  void onLogoutError(dynamic error) {
    print('退出登录出错: $error');
    Get.snackbar('错误', '退出登录时出现错误');
  }
}