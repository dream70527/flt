import 'package:get/get.dart';

/// 专门管理计数器的控制器
class CounterController extends GetxController {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    update(); // 只影响监听 CounterController 的 Widget
  }
  
  void decrement() {
    _count--;
    update();
  }
  
  void reset() {
    _count = 0;
    update();
  }
}