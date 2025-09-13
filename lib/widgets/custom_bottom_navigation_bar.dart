import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../l10n/app_localizations.dart';
import '../routes/routes.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        // 如果点击的是当前页面，不进行跳转
        if (index == currentIndex) return;
        
        String targetRoute;
        switch (index) {
          case 0:
            targetRoute = Routes.tabHome;
            break;
          case 1:
            targetRoute = Routes.tabDiscover;
            break;
          case 2:
            targetRoute = Routes.tabReward;
            break;
          case 3:
            targetRoute = Routes.tabAccount;
            break;
          default:
            return;
        }
        
        // 检查目标路由是否已经在路由栈中
        if (Get.currentRoute == targetRoute) return;
        
        // 使用offNamedUntil确保清理路由栈但保持controller实例
        Get.offNamedUntil(targetRoute, (route) => false);
      },
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
    );
  }
}