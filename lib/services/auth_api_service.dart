import 'package:get/get.dart';
import '../models/user_info_entity.dart';
import '../models/captcha_entity.dart';
import '../services/http_service.dart';

class AuthApiService {
  late final HttpService _httpService;

  AuthApiService() {
    _httpService = Get.find<HttpService>();
  }

  /// 获取验证码
  Future<CaptchaEntity?> getCaptcha() async {
    try {
      final response = await _httpService.get<CaptchaEntity>(
        '/get-captcha/base64',
        converter: (data) => CaptchaEntity.fromJson(data),
      );
      
      if (response.success && response.data != null) {
        return response.data!;
      }
      
      throw Exception('获取验证码失败: ${response.message}');
    } catch (e) {
      throw Exception('获取验证码错误: $e');
    }
  }

  /// 用户登录
  Future<UserInfoEntity?> login({
    required String account,
    required String password,
    required String captchaKey,
    required String captchaCode,
  }) async {
    try {
      final response = await _httpService.post<UserInfoEntity>(
        '/login',
        data: {
          'account': account,
          'login_password': password,
          'key': captchaKey,
          'captcha': captchaCode,
        },
        converter: (data) => UserInfoEntity.fromJson(data),
      );
      
      if (response.success && response.data != null) {
        return response.data!;
      }
      
      throw Exception('登录失败: ${response.message}');
    } catch (e) {
      throw Exception('登录错误: $e');
    }
  }
}