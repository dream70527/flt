import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/available_rewards_widget.dart';

/// 示例：如何在其他页面中使用 AvailableRewardsWidget
class RewardExampleUsage extends StatefulWidget {
  const RewardExampleUsage({super.key});

  @override
  State<RewardExampleUsage> createState() => _RewardExampleUsageState();
}

class _RewardExampleUsageState extends State<RewardExampleUsage> {
  bool isLoading = false;
  List<dynamic> sampleRewards = [
    {
      'id': '1',
      'name': 'Daily Login Bonus',
      'description': 'Get points for logging in every day',
      'points': 100,
      'type': 'bonus',
      'claimed': false,
    },
    {
      'id': '2',
      'name': 'Crypto Trading Badge',
      'description': 'Complete 10 trades to earn this badge',
      'points': 500,
      'type': 'badge',
      'claimed': true,
    },
    {
      'id': '3',
      'name': '50% Trading Fee Voucher',
      'description': 'Reduce your next trading fee by 50%',
      'points': 200,
      'type': 'voucher',
      'claimed': false,
    },
    {
      'id': '4',
      'name': 'BNB Token Reward',
      'description': 'Earn 0.1 BNB for completing tasks',
      'points': 1000,
      'type': 'token',
      'claimed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards Usage Example'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // 使用说明
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 AvailableRewardsWidget 使用示例',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '这个组件已经从 RewardPage 中抽离，可以在任何地方复用：',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 12.h),
                    
                    // 操作按钮
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            // 模拟加载
                            Future.delayed(Duration(seconds: 2), () {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          },
                          child: Text('模拟加载'),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              sampleRewards = [];
                            });
                          },
                          child: Text('清空奖励'),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              sampleRewards = [
                                {
                                  'id': '1',
                                  'name': 'Daily Login Bonus',
                                  'description': 'Get points for logging in every day',
                                  'points': 100,
                                  'type': 'bonus',
                                  'claimed': false,
                                },
                              ];
                            });
                          },
                          child: Text('重置数据'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // 使用抽离的组件
            AvailableRewardsWidget(
              rewards: sampleRewards,
              onClaimReward: _handleClaimReward,
              isLoading: isLoading,
            ),
            
            SizedBox(height: 24.h),
            
            // 代码示例
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📝 使用代码',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '''AvailableRewardsWidget(
  rewards: controller.rewards,
  onClaimReward: controller.claimReward,
  isLoading: controller.isLoading,
)''',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理奖励领取
  void _handleClaimReward(String rewardId) {
    setState(() {
      // 更新奖励状态为已领取
      final index = sampleRewards.indexWhere((r) => r['id'] == rewardId);
      if (index != -1) {
        sampleRewards[index]['claimed'] = true;
      }
    });
    
    // 显示成功消息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('奖励已领取！奖励ID: $rewardId'),
        backgroundColor: Colors.green,
      ),
    );
  }
}