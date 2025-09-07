import 'package:get/get.dart';
import '../services/http_service.dart';

class RewardController extends GetxController {
  final _isLoading = false.obs;
  final _rewards = <Map<String, dynamic>>[].obs;
  final _totalPoints = 0.obs;

  bool get isLoading => _isLoading.value;
  List<Map<String, dynamic>> get rewards => _rewards;
  int get totalPoints => _totalPoints.value;

  late final HttpService _httpService;

  @override
  void onInit() {
    super.onInit();
    _httpService = Get.find<HttpService>();
    loadRewards();
  }

  Future<void> loadRewards() async {
    try {
      _isLoading.value = true;
      final response = await _httpService.get<Map<String, dynamic>>('/rewards');
      if (response.success && response.data != null) {
        _totalPoints.value = response.data!['totalPoints'] ?? 0;
        _rewards.value = List<Map<String, dynamic>>.from(
          response.data!['rewards'] ?? [],
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load rewards: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> claimReward(String rewardId) async {
    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/rewards/claim',
        data: {'rewardId': rewardId},
      );
      if (response.success) {
        Get.snackbar('Success', 'Reward claimed successfully!');
        await loadRewards();
      } else {
        Get.snackbar('Error', response.message ?? 'Failed to claim reward');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to claim reward: $e');
    }
  }
}