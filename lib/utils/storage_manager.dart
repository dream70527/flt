import 'package:get_storage/get_storage.dart';

class StorageManager {
  static final GetStorage _box = GetStorage();
  
  // Token相关的key
  static const String _tokenKey = 'user_token';
  static const String _userInfoKey = 'user_info';
  static const String _loginTimeKey = 'login_time';
  
  /// 初始化存储
  static Future<void> init() async {
    await GetStorage.init();
  }
  
  /// 保存token
  static Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
    await _box.write(_loginTimeKey, DateTime.now().millisecondsSinceEpoch);
  }
  
  /// 获取token
  static String? getToken() {
    return _box.read(_tokenKey);
  }
  
  /// 检查token是否存在
  static bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
  
  /// 保存用户信息
  static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    await _box.write(_userInfoKey, userInfo);
  }
  
  /// 获取用户信息
  static Map<String, dynamic>? getUserInfo() {
    return _box.read(_userInfoKey);
  }
  
  /// 获取登录时间
  static DateTime? getLoginTime() {
    final timestamp = _box.read(_loginTimeKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }
  
  /// 清除所有登录相关数据
  static Future<void> clearLoginData() async {
    await _box.remove(_tokenKey);
    await _box.remove(_userInfoKey);
    await _box.remove(_loginTimeKey);
  }
  
  /// 清除所有数据
  static Future<void> clearAll() async {
    await _box.erase();
  }
  
  /// 检查token是否过期（可选功能）
  static bool isTokenExpired({int expireHours = 24 * 7}) { // 默认7天过期
    final loginTime = getLoginTime();
    if (loginTime == null) return true;
    
    final now = DateTime.now();
    final expireTime = loginTime.add(Duration(hours: expireHours));
    return now.isAfter(expireTime);
  }
}