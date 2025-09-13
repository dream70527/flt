import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'account_page.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class TabAccountPage extends GetView<MainController> {
  const TabAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const AccountPage(),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3),
    );
  }
}