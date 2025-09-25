import 'package:get/get.dart';
import '../../models/captcha_entity.dart';
import '../../services/auth_api_service.dart';

/// 验证码功能Mixin
mixin CaptchaMixin on GetxController {
  final AuthApiService _authApiService = AuthApiService();
  
  // 验证码状态
  final Rxn<CaptchaEntity> captcha = Rxn<CaptchaEntity>();
  final RxBool isCaptchaLoading = false.obs;
  
  /// 获取验证码
  Future<void> getCaptcha() async {
    try {
      isCaptchaLoading.value = true;
      final result = await _authApiService.getCaptcha();
      captcha.value = result;
      onCaptchaLoaded(result);
    } catch (e) {
      onCaptchaError(e);
      rethrow;
    } finally {
      isCaptchaLoading.value = false;
    }
  }
  
  /// 验证验证码是否有效
  bool isValidCaptcha() {
    return captcha.value != null;
  }
  
  /// 清除验证码
  void clearCaptcha() {
    captcha.value = null;
  }
  
  // 钩子方法
  void onCaptchaLoaded(CaptchaEntity captchaEntity) {
    print('验证码加载成功');
  }
  
  void onCaptchaError(dynamic error) {
    Get.snackbar('错误', error.toString());
    print('验证码加载失败: $error');
  }
}