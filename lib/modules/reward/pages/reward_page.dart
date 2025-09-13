import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/reward_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/available_rewards_widget.dart';

class RewardPage extends GetView<RewardController> {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.reward ?? 'Reward',
          style: TextStyle(fontSize: 18.sp),
        ),
        actions: [
          // 添加测试按钮
          GetBuilder<RewardController>(
            builder: (controller) {
              return TextButton(
                onPressed: controller.addNum,
                child: Text(
                  'Test: ${controller.num}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
      body: GetBuilder<RewardController>(
        builder: (controller) {
          print('🔄 RewardPage build - 整个页面重建');
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    GetBuilder<RewardController>(
                      id: 'total_points', // 指定ID，只有调用update(['total_points'])时才更新
                      builder: (controller) {
                        return Text(
                          'Total Points ${controller.num}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8.h),
                    GetBuilder<RewardController>(
                      id: 'total_points',
                      builder: (controller) {
                        return Text(
                          '${controller.totalPoints}',
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'pts',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // 使用抽离的组件
              AvailableRewardsWidget(
                rewards: controller.rewards,
                onClaimReward: controller.claimReward,
                isLoading: controller.isLoading,
              ),
            ],
          ),
        );
        }, // GetBuilder 的闭包
      ),
    );
  }
}