import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../l10n/app_localizations.dart';
import 'home_page.dart';
import 'reward_page.dart';
import 'account_page.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const RewardPage(),
      const AccountPage(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex,
        children: pages,
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex,
        onTap: controller.changeTab,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24.w),
            activeIcon: Icon(Icons.home, size: 24.w),
            label: AppLocalizations.of(context)?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard, size: 24.w),
            activeIcon: Icon(Icons.card_giftcard, size: 24.w),
            label: AppLocalizations.of(context)?.reward ?? 'Reward',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24.w),
            activeIcon: Icon(Icons.person, size: 24.w),
            label: AppLocalizations.of(context)?.account ?? 'Account',
          ),
        ],
      )),
    );
  }
}