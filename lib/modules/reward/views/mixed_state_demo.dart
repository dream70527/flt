import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/reward_controller.dart';
import '../widgets/available_rewards_with_local_state.dart';

/// 混合状态管理演示页面
class MixedStateDemo extends StatelessWidget {
  const MixedStateDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('混合状态管理演示'),
        actions: [
          // 添加一些测试奖励的按钮
          PopupMenuButton<String>(
            onSelected: (value) {
              final controller = Get.find<RewardController>();
              switch (value) {
                case 'add_points':
                  controller.addPoints(500);
                  break;
                case 'reset_points':
                  controller.resetPoints();
                  break;
                case 'reload_rewards':
                  controller.loadRewards();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'add_points', child: Text('🎁 增加500积分')),
              PopupMenuItem(value: 'reset_points', child: Text('🔄 重置积分')),
              PopupMenuItem(value: 'reload_rewards', child: Text('📥 重新加载奖励')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 说明文档
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 混合状态管理演示',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '这个组件演示了如何在 StatefulWidget 中混合使用：',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '🔵 GetX 状态：奖励数据、积分、加载状态\n'
                      '🟠 本地状态：显示数量、搜索、过滤、排序\n'
                      '🟢 用户交互：实时搜索、数量选择、条件筛选',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.orange, size: 20.w),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            '尝试搜索、改变显示数量、切换过滤条件，观察本地状态的变化',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // GetX 状态监控面板
            GetBuilder<RewardController>(
              builder: (controller) {
                return Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📊 GetX 状态监控',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatusCard(
                                '总积分',
                                '${controller.totalPoints}',
                                Icons.monetization_on,
                                Colors.orange,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildStatusCard(
                                '奖励总数',
                                '${controller.rewards.length}',
                                Icons.card_giftcard,
                                Colors.blue,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildStatusCard(
                                '加载状态',
                                controller.isLoading ? '加载中' : '已完成',
                                controller.isLoading ? Icons.refresh : Icons.check_circle,
                                controller.isLoading ? Colors.orange : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(height: 20.h),
            
            // 混合状态管理的奖励组件
            AvailableRewardsWithLocalState(
              onClaimReward: (rewardId) {
                print('🎁 尝试领取奖励: $rewardId');
                final controller = Get.find<RewardController>();
                controller.claimReward(rewardId);
              },
            ),
            
            SizedBox(height: 20.h),
            
            // 技术说明
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔧 技术实现要点',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildTechPoint(
                      'StatefulWidget + GetBuilder',
                      '外层StatefulWidget管理本地状态，内层GetBuilder监听GetX状态',
                    ),
                    _buildTechPoint(
                      '状态分离',
                      'UI交互状态(本地) vs 业务数据状态(GetX)',
                    ),
                    _buildTechPoint(
                      '性能优化',
                      '只有相关状态变化时才触发重建',
                    ),
                    _buildTechPoint(
                      '用户体验',
                      '本地状态提供即时响应，GetX状态保证数据一致性',
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

  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.w),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechPoint(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            margin: EdgeInsets.only(top: 6.h, right: 8.w),
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}