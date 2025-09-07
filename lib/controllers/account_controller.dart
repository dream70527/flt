import 'package:get/get.dart';
import '../services/http_service.dart';

class AccountController extends GetxController {
  final _isLoading = false.obs;
  final _userInfo = <String, dynamic>{}.obs;

  bool get isLoading => _isLoading.value;
  Map<String, dynamic> get userInfo => _userInfo;

  String get username => _userInfo['username'] ?? 'Guest';
  String get email => _userInfo['email'] ?? '';
  String get avatar => _userInfo['avatar'] ?? '';

  late final HttpService _httpService;

  @override
  void onInit() {
    super.onInit();
    _httpService = Get.find<HttpService>();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
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
    _userInfo.clear();
    _httpService.removeAuthToken();
    Get.snackbar('Success', 'Logged out successfully');
  }
}