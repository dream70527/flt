import 'package:get/get.dart';
import '../auth_api_service.dart';
import 'auth_state_service.dart';
import 'captcha_service.dart';

/// 登录业务逻辑服务
class LoginService extends GetxService {
  final AuthApiService _authApiService = AuthApiService();
  
  late final AuthStateService _authStateService;
  late final CaptchaService _captchaService;
  
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _authStateService = Get.find<AuthStateService>();
    _captchaService = Get.find<CaptchaService>();
  }
  
  /// 登录
  Future<bool> login({
    String? account,
    String? password,
    required String captchaCode,
  }) async {
    if (!_captchaService.isValidCaptcha()) {
      Get.snackbar('错误', '请先获取验证码');
      return false;
    }
    
    try {
      isLoading.value = true;
      
      final result = await _authApiService.login(
        account: account ?? 'apitest',
        password: password ?? '123456',
        captchaKey: _captchaService.captcha.value!.key,
        captchaCode: captchaCode,
      );
      
      if (result != null) {
        // 设置登录状态
        await _authStateService.setLoginState(result);
        
        Get.snackbar('成功', '登录成功');
        
        // 处理登录后跳转
        await _handleLoginSuccess();
        
        return true;
      }
      
      return false;
    } catch (e) {
      Get.snackbar('登录失败', e.toString());
      // 登录失败后重新获取验证码
      await _captchaService.getCaptcha();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 处理登录成功后的跳转
  Future<void> _handleLoginSuccess() async {
    final redirectRoute = _authStateService.getAndClearRedirectRoute();
    if (redirectRoute != null && redirectRoute.isNotEmpty) {
      Get.offAllNamed(redirectRoute);
    } else {
      Get.offAllNamed('/main');
    }
  }
  
  /// 退出登录
  Future<void> logout() async {
    try {
      await _authStateService.clearLoginState();
      _captchaService.clearCaptcha();
      
      Get.snackbar('提示', '已退出登录');
    } catch (e) {
      print('退出登录出错: $e');
      Get.snackbar('错误', '退出登录时出现错误');
    }
  }
  
  /// 检查是否需要登录
  void checkAndLogin() {
    if (!_authStateService.isLoggedIn.value) {
      Get.toNamed('/login');
    }
  }
}