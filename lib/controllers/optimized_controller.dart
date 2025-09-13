import 'package:get/get.dart';

/// 高级优化的Controller示例
class OptimizedController extends GetxController {
  // 使用 RxString 而不是 String.obs 更高效
  final _username = ''.obs;
  final _email = ''.obs;
  final _avatar = ''.obs;
  
  // 分离不同类型的状态
  final _isLoading = false.obs;
  final _isRefreshing = false.obs;
  final _hasError = false.obs;
  
  // 计数器数据
  final _counter = 0.obs;
  final _points = 0.obs;
  
  // Getters
  String get username => _username.value;
  String get email => _email.value;
  String get avatar => _avatar.value;
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  bool get hasError => _hasError.value;
  int get counter => _counter.value;
  int get points => _points.value;

  /// 技巧1: 使用 Worker 监听状态变化
  @override
  void onInit() {
    super.onInit();
    
    // debounce: 防抖，500ms内多次调用只执行最后一次
    debounce(_username, (String value) {
      print('用户名更新: $value');
      _saveUserData();
    }, time: const Duration(milliseconds: 500));
    
    // throttle: 节流，1秒内最多执行一次
    interval(_counter, (int value) {
      print('计数器更新: $value');
      _updatePointsBasedOnCounter();
    }, time: const Duration(seconds: 1));
    
    // ever: 每次值改变都执行
    ever(_hasError, (bool hasError) {
      if (hasError) {
        Get.snackbar('错误', '发生了错误，请重试');
      }
    });
    
    // once: 只执行一次
    once(_isLoading, (bool loading) {
      if (!loading) {
        print('首次加载完成');
      }
    });
  }

  /// 技巧2: 批量更新状态
  void updateUserInfo(String username, String email, String avatar) {
    // 使用 update() 批量更新，避免多次UI刷新
    _username.value = username;
    _email.value = email;
    _avatar.value = avatar;
    // 只触发一次UI更新
    update(['user_info']);
  }

  /// 技巧3: 条件更新
  void incrementCounter() {
    _counter.value++;
    
    // 只有特定条件下才更新UI
    if (_counter.value % 5 == 0) {
      update(['counter_milestone']); // 只在里程碑时更新特殊UI
    }
    update(['counter']); // 总是更新计数器显示
  }

  /// 技巧4: 异步状态管理
  Future<void> loadUserData() async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 2));
      
      // 模拟随机失败
      if (DateTime.now().millisecond % 3 == 0) {
        throw Exception('网络错误');
      }
      
      updateUserInfo('John Doe', 'john@example.com', 'avatar_url');
      
    } catch (e) {
      _hasError.value = true;
    } finally {
      _isLoading.value = false;
    }
  }

  /// 技巧5: 下拉刷新优化
  Future<void> refreshData() async {
    if (_isRefreshing.value) return; // 防止重复刷新
    
    _isRefreshing.value = true;
    
    try {
      await loadUserData();
    } finally {
      _isRefreshing.value = false;
    }
  }

  void _saveUserData() {
    print('保存用户数据: $username, $email');
    // 实际保存逻辑
  }
  
  void _updatePointsBasedOnCounter() {
    _points.value = _counter.value * 10;
    update(['points']);
  }

  /// 技巧6: 内存优化 - 手动清理
  @override
  void onClose() {
    // 清理资源，避免内存泄漏
    print('OptimizedController 被销毁');
    super.onClose();
  }
}