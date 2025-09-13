import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/main_controller.dart';
import '../pages/reward_page.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';

class TabRewardPage extends GetView<MainController> {
  const TabRewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const RewardPage(),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}