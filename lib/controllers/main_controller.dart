import 'package:get/get.dart';

class MainController extends GetxController {
  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  void changeTab(int index) {
    _selectedIndex.value = index;
  }
}