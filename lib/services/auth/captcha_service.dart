import 'package:get/get.dart';
import '../../models/captcha_entity.dart';
import '../auth_api_service.dart';

/// 验证码管理服务
class CaptchaService extends GetxService {
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
    } catch (e) {
      Get.snackbar('错误', e.toString());
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
}