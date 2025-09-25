import '../models/user_info_entity.dart';
import '../models/captcha_entity.dart';
import '../services/auth_api_service.dart';
import '../utils/storage_manager.dart';

/// 认证数据仓库 - 统一管理数据访问
class AuthRepository {
  final AuthApiService _apiService = AuthApiService();
  
  // ==== API相关 ====
  
  /// 获取验证码
  Future<CaptchaEntity> getCaptcha() async {
    return await _apiService.getCaptcha();
  }
  
  /// 登录
  Future<UserInfoEntity?> login({
    required String account,
    required String password,
    required String captchaKey,
    required String captchaCode,
  }) async {
    return await _apiService.login(
      account: account,
      password: password,
      captchaKey: captchaKey,
      captchaCode: captchaCode,
    );
  }
  
  // ==== 本地存储相关 ====
  
  /// 保存用户信息到本地
  Future<void> saveUserToLocal(UserInfoEntity user) async {
    if (user.token.isNotEmpty) {
      await StorageManager.saveToken(user.token);
      await StorageManager.saveUserInfo(user.toJson());
    }
  }
  
  /// 从本地获取用户信息
  UserInfoEntity? getUserFromLocal() {
    try {
      final token = StorageManager.getToken();
      final userInfoData = StorageManager.getUserInfo();
      
      if (token != null && token.isNotEmpty && userInfoData != null) {
        if (!StorageManager.isTokenExpired()) {
          return UserInfoEntity.fromJson(userInfoData);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// 获取本地token
  String? getLocalToken() {
    return StorageManager.getToken();
  }
  
  /// 检查token是否过期
  bool isTokenExpired() {
    return StorageManager.isTokenExpired();
  }
  
  /// 清除本地认证数据
  Future<void> clearLocalAuthData() async {
    await StorageManager.clearLoginData();
  }
}