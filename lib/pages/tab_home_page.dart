import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../modules/home/pages/home_page.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class TabHomePage extends GetView<MainController> {
  const TabHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomePage(),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}