import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/main_tab_controller.dart';
import '../l10n/app_localizations.dart';
import '../modules/home/pages/home_page.dart';
import 'discover_page.dart';
import '../modules/reward/pages/reward_page.dart';
import 'account_page.dart';

class MainTabContainer extends GetView<MainTabController> {
  const MainTabContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIndex,
        children: const [
          HomePage(),
          DiscoverPage(), 
          RewardPage(),
          AccountPage(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex,
        onTap: controller.changeTab,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24.w),
            activeIcon: Icon(Icons.home, size: 24.w),
            label: AppLocalizations.of(context)?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore, size: 24.w),
            activeIcon: Icon(Icons.explore, size: 24.w),
            label: 'Discover',
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