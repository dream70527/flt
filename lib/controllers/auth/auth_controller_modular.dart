import 'package:get/get.dart';
import 'auth_base_controller.dart';
import 'captcha_mixin.dart';
import 'login_mixin.dart';

/// 模块化的AuthController - 组合各种功能
class AuthControllerModular extends AuthBaseController 
    with CaptchaMixin, LoginMixin {
  
  @override
  void onInit() {
    super.onInit();
    print('AuthControllerModular 初始化完成');
  }
  
  /// 刷新Token
  Future<void> refreshToken() async {
    try {
      if (!isLoggedIn.value || userInfo.value == null) return;
      
      // TODO: 实现token刷新逻辑
      print('刷新token...');
    } catch (e) {
      print('刷新token失败: $e');
    }
  }
  
  // 可以重写钩子方法来定制行为
  @override
  void onLoginStateRestored() {
    super.onLoginStateRestored();
    // 可以添加额外的逻辑，比如加载用户配置等
  }
  
  @override
  void onLoginSuccessComplete() {
    super.onLoginSuccessComplete();
    // 可以添加登录成功后的额外逻辑，比如统计、埋点等
  }
  
  @override
  void onLogoutSuccessComplete() {
    super.onLogoutSuccessComplete();
    // 可以添加退出登录后的清理逻辑
  }
}