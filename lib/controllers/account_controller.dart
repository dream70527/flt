import 'package:get/get.dart';
import '../services/http_service.dart';
import '../controllers/auth_controller.dart';

class AccountController extends GetxController {
  final _isLoading = false.obs;
  final _userInfo = <String, dynamic>{}.obs;
  
  late final HttpService _httpService;
  late final AuthController _authController;

  bool get isLoading => _isLoading.value;
  Map<String, dynamic> get userInfo => _userInfo;

  String get username => _userInfo['username'] ?? 'Guest';
  String get email => _userInfo['email'] ?? '';
  String get avatar => _userInfo['avatar'] ?? '';
  
  // 获取登录状态
  bool get isLoggedIn => _authController.isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
    _httpService = Get.find<HttpService>();
    _authController = Get.find<AuthController>();
    
    // 监听登录状态变化
    ever(_authController.isLoggedIn, (bool loggedIn) {
      if (loggedIn) {
        _loadUserInfoFromAuth();
      } else {
        _userInfo.clear();
      }
    });
    
    // 如果已经登录，加载用户信息
    if (_authController.isLoggedIn.value) {
      _loadUserInfoFromAuth();
    }
  }

  /// 从AuthController获取用户信息
  void _loadUserInfoFromAuth() {
    final authUserInfo = _authController.userInfo.value;
    if (authUserInfo != null) {
      _userInfo.value = {
        'username': authUserInfo.nickname.isNotEmpty ? authUserInfo.nickname : authUserInfo.account,
        'email': authUserInfo.email,
        'avatar': '', // 如果有头像字段可以添加
        'account': authUserInfo.account,
        'phone': authUserInfo.phoneNo,
        'vipLevel': authUserInfo.vipLevel,
      };
    }
  }

  /// 检查登录状态，未登录时跳转登录页
  void checkLoginAndNavigate() {
    if (!_authController.isLoggedIn.value) {
      _authController.checkAndLogin();
    }
  }

  Future<void> loadUserInfo() async {
    if (!_authController.isLoggedIn.value) {
      return;
    }
    
    try {
      _isLoading.value = true;
      final response = await _httpService.get<Map<String, dynamic>>('/user/info');
      if (response.success && response.data != null) {
        _userInfo.value = response.data!;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user info: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (!_authController.isLoggedIn.value) {
      _authController.checkAndLogin();
      return;
    }
    
    try {
      _isLoading.value = true;
      final response = await _httpService.put<Map<String, dynamic>>(
        '/user/profile',
        data: data,
      );
      if (response.success) {
        await loadUserInfo();
        Get.snackbar('Success', 'Profile updated successfully!');
      } else {
        Get.snackbar('Error', response.message ?? 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void logout() {
    _authController.logout();
  }
}