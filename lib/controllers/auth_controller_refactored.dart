import 'package:get/get.dart';
import '../services/auth/auth_state_service.dart';
import '../services/auth/captcha_service.dart';
import '../services/auth/login_service.dart';

/// 重构后的AuthController - 作为各个服务的协调器
class AuthControllerRefactored extends GetxController {
  // 依赖注入各个服务
  late final AuthStateService _authStateService;
  late final CaptchaService _captchaService;
  late final LoginService _loginService;
  
  @override
  void onInit() {
    super.onInit();
    
    // 确保服务已注册
    Get.lazyPut(() => AuthStateService(), fenix: true);
    Get.lazyPut(() => CaptchaService(), fenix: true);
    Get.lazyPut(() => LoginService(), fenix: true);
    
    // 获取服务实例
    _authStateService = Get.find<AuthStateService>();
    _captchaService = Get.find<CaptchaService>();
    _loginService = Get.find<LoginService>();
  }
  
  // ==== 用户状态相关 ====
  
  /// 用户信息
  get userInfo => _authStateService.userInfo;
  
  /// 登录状态
  get isLoggedIn => _authStateService.isLoggedIn;
  
  /// 检查用户权限
  bool hasRole(String role) => _authStateService.hasRole(role);
  
  /// 设置重定向路由
  void setRedirectRoute(String? route) => _authStateService.setRedirectRoute(route);
  
  // ==== 验证码相关 ====
  
  /// 验证码数据
  get captcha => _captchaService.captcha;
  
  /// 验证码加载状态
  get isCaptchaLoading => _captchaService.isCaptchaLoading;
  
  /// 获取验证码
  Future<void> getCaptcha() => _captchaService.getCaptcha();
  
  // ==== 登录相关 ====
  
  /// 登录加载状态
  get isLoginLoading => _loginService.isLoading;
  
  /// 登录
  Future<bool> login({
    String? account,
    String? password,
    required String captchaCode,
  }) => _loginService.login(
        account: account,
        password: password,
        captchaCode: captchaCode,
      );
  
  /// 退出登录
  Future<void> logout() => _loginService.logout();
  
  /// 检查是否需要登录
  void checkAndLogin() => _loginService.checkAndLogin();
  
  // ==== Token相关 ====
  
  /// 刷新Token（如果需要的话，可以创建单独的TokenService）
  Future<void> refreshToken() async {
    // TODO: 如果需要token刷新功能，可以创建TokenService
    try {
      if (!_authStateService.isLoggedIn.value) return;
      
      // 刷新逻辑...
    } catch (e) {
      print('刷新token失败: $e');
    }
  }
}