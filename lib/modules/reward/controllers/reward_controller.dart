import 'package:get/get.dart';

class RewardController extends GetxController {
  int num = 0;
  bool _isLoading = false;
  List<Map<String, dynamic>> _rewards = [];
  int _totalPoints = 1250;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get rewards => _rewards;
  int get totalPoints => _totalPoints;

  @override
  void onInit() {
    super.onInit();
    loadRewards();
  }

  addNum(){
    num++;
    update(['available_rewards','total_points']); // 更新积分显示区域
  }

  Future<void> loadRewards() async {
    try {
      _isLoading = true;
      update(); // 更新加载状态
      
      // 模拟网络请求延迟
      await Future.delayed(const Duration(milliseconds: 500));
      
      // 模拟数据
      _rewards = [
        {
          'id': '1',
          'name': 'Gift Card \$10',
          'description': 'Amazon gift card worth \$10',
          'points': 500,
        },
        {
          'id': '2',
          'name': 'Coffee Voucher',
          'description': 'Free coffee at your favorite cafe',
          'points': 200,
        },
        {
          'id': '3',
          'name': 'Premium Subscription',
          'description': '1 month premium subscription',
          'points': 1000,
        },
        {
          'id': '4',
          'name': 'Movie Ticket',
          'description': 'Free movie ticket for any cinema',
          'points': 800,
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load rewards: $e');
    } finally {
      _isLoading = false;
      update(); // 更新完成状态
    }
  }

  Future<void> claimReward(String rewardId) async {
    try {
      // 查找奖励
      final reward = _rewards.firstWhere((r) => r['id'] == rewardId);
      final requiredPoints = reward['points'] as int;
      
      if (_totalPoints >= requiredPoints) {
        _totalPoints -= requiredPoints;
        Get.snackbar('Success', 'Reward "${reward['name']}" claimed successfully!');
        // 从列表中移除已兑换的奖励
        _rewards.removeWhere((r) => r['id'] == rewardId);
        update(); // 手动触发UI更新
        update(['total_points']); // 更新积分显示
      } else {
        Get.snackbar('Error', 'Insufficient points to claim this reward');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to claim reward: $e');
    }
  }

  // 测试方法：增加积分
  void addPoints(int points) {
    _totalPoints += points;
    update(['total_points']); // 只更新积分相关的UI
    Get.snackbar('Points Added', '+$points points added!');
  }

  // 测试方法：重置积分
  void resetPoints() {
    _totalPoints = 1250;
    update(['total_points']);
    Get.snackbar('Points Reset', 'Points reset to 1250');
  }
}