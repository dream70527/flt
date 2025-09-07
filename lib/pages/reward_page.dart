import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/reward_controller.dart';
import '../l10n/app_localizations.dart';

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
      ),
      body: Obx(() {
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
                    Text(
                      'Total Points',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${controller.totalPoints}',
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
              Text(
                'Available Rewards',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              if (controller.rewards.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.rewards.length,
                  itemBuilder: (context, index) {
                    final reward = controller.rewards[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12.h),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Row(
                          children: [
                            Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.card_giftcard,
                                color: Theme.of(context).primaryColor,
                                size: 30.w,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reward['name'] ?? 'Reward',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    reward['description'] ?? 'Description',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    '${reward['points'] ?? 0} pts',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => controller.claimReward(reward['id']),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                              ),
                              child: Text(
                                'Claim',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(40.w),
                  child: Column(
                    children: [
                      Icon(
                        Icons.card_giftcard_outlined,
                        size: 48.w,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'No rewards available',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}