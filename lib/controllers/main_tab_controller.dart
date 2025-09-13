import 'package:get/get.dart';
import '../routes/routes.dart';

class MainTabController extends GetxController {
  final _currentIndex = 0.obs;
  
  int get currentIndex => _currentIndex.value;

  @override
  void onInit() {
    super.onInit();
    // 从路由推断初始tab索引
    _updateIndexFromRoute();
  }

  void changeTab(int index) {
    if (_currentIndex.value == index) return;
    
    // 只改变索引，页面通过IndexedStack自动切换，不进行路由跳转
    _currentIndex.value = index;
  }

  void _updateIndexFromRoute() {
    // 从路由名称推断tab索引
    final currentRoute = Get.currentRoute;
    switch (currentRoute) {
      case Routes.tabHome:
        _currentIndex.value = 0;
        break;
      case Routes.tabDiscover:
        _currentIndex.value = 1;
        break;
      case Routes.tabReward:
        _currentIndex.value = 2;
        break;
      case Routes.tabAccount:
        _currentIndex.value = 3;
        break;
      default:
        _currentIndex.value = 0;
    }
  }

  void setTabIndex(int index) {
    _currentIndex.value = index;
  }
}