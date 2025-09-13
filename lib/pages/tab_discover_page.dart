import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'discover_page.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class TabDiscoverPage extends GetView<MainController> {
  const TabDiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DiscoverPage(),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}