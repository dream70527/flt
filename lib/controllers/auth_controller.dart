import 'package:get/get.dart';
import '../models/user_info_entity.dart';
import '../models/captcha_entity.dart';
import '../services/auth_api_service.dart';
import '../services/http_service.dart';
import '../utils/storage_manager.dart';

class AuthController extends GetxController {
  final AuthApiService _authApiService = AuthApiService();
  late final HttpService _httpService;
  
  // 用户信息
  final Rxn<UserInfoEntity> userInfo = Rxn<UserInfoEntity>();
  
  // 登录状态
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;
  
  // 验证码
  final Rxn<CaptchaEntity> captcha = Rxn<CaptchaEntity>();
  final RxBool isCaptchaLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _httpService = Get.find<HttpService>();
    _checkLoginStatus();
  }
  
  /// 检查登录状态
  void _checkLoginStatus() {
    try {
      // 从本地存储中获取token
      final token = StorageManager.getToken();
      final userInfoData = StorageManager.getUserInfo();
      
      if (token != null && token.isNotEmpty && userInfoData != null) {
        // 检查token是否过期
        if (!StorageManager.isTokenExpired()) {
          // 恢复用户信息和登录状态
          userInfo.value = UserInfoEntity.fromJson(userInfoData);
          isLoggedIn.value = true;
          
          // 设置HTTP服务的认证token
          _httpService.setAuthToken(token);
          
          print('从本地存储恢复登录状态: ${userInfo.value?.account}');
        } else {
          // token过期，清除本地数据
          print('Token已过期，清除本地登录数据');
          StorageManager.clearLoginData();
        }
      }
    } catch (e) {
      print('检查登录状态出错: $e');
      // 出错时清除可能损坏的数据
      StorageManager.clearLoginData();
    }
  }
  
  /// 获取验证码
  Future<void> getCaptcha() async {
    try {
      isCaptchaLoading.value = true;
      final result = await _authApiService.getCaptcha();
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
      isLoading.value = true;
      
      final result = await _authApiService.login(
        account: account ?? 'apitest',
        password: password ?? '123456',
        captchaKey: captcha.value!.key,
        captchaCode: captchaCode,
      );
      
      if (result != null) {
        // 保存用户信息
        userInfo.value = result;
        isLoggedIn.value = true;
        
        // 保存token到本地存储
        if (result.token.isNotEmpty) {
          await StorageManager.saveToken(result.token);
          await StorageManager.saveUserInfo(result.toJson());
          
          // 设置HTTP服务的认证token
          _httpService.setAuthToken(result.token);
        }
        
        Get.snackbar('成功', '登录成功');
        return true;
      }
      
      return false;
    } catch (e) {
      Get.snackbar('登录失败', e.toString());
      // 登录失败后重新获取验证码
      await getCaptcha();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 退出登录
  Future<void> logout() async {
    try {
      // 清除内存中的数据
      userInfo.value = null;
      isLoggedIn.value = false;
      captcha.value = null;
      
      // 清除本地存储的数据
      await StorageManager.clearLoginData();
      
      // 移除HTTP服务的认证token
      _httpService.removeAuthToken();
      
      Get.snackbar('提示', '已退出登录');
    } catch (e) {
      print('退出登录出错: $e');
      Get.snackbar('错误', '退出登录时出现错误');
    }
  }
  
  /// 检查是否需要登录
  void checkAndLogin() {
    if (!isLoggedIn.value) {
      Get.toNamed('/login'); // 跳转到登录页面
    }
  }
  
  /// 刷新token（可选功能）
  Future<void> refreshToken() async {
    try {
      if (!isLoggedIn.value || userInfo.value == null) return;
      
      // TODO: 如果后端支持刷新token的接口，可以在这里调用
      // final newToken = await _authApiService.refreshToken();
      // if (newToken != null) {
      //   await StorageManager.saveToken(newToken);
      //   _httpService.setAuthToken(newToken);
      // }
    } catch (e) {
      print('刷新token失败: $e');
    }
  }
}