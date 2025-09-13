import 'package:flutter/material.dart';
import 'tab_home_page.dart';

// 保留MainPage用于向后兼容，直接重定向到TabHomePage
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabHomePage();
  }
}