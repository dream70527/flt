import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/reward_controller.dart';

/// StatefulWidget 版本的 AvailableRewardsWidget
class AvailableRewardsStatefulWidget extends StatefulWidget {
  final List<dynamic> rewards;
  final Function(String rewardId) onClaimReward;
  final bool isLoading;

  const AvailableRewardsStatefulWidget({
    super.key,
    required this.rewards,
    required this.onClaimReward,
    this.isLoading = false,
  });

  @override
  State<AvailableRewardsStatefulWidget> createState() => _AvailableRewardsStatefulWidgetState();
}

class _AvailableRewardsStatefulWidgetState extends State<AvailableRewardsStatefulWidget> {
  late RewardController controller;
  int localCounter = 0; // 本地状态
  
  @override
  void initState() {
    super.initState();
    controller = Get.find<RewardController>();
    print('🔧 StatefulWidget initState - 只调用一次');
  }
  
  @override
  void didUpdateWidget(AvailableRewardsStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('🔄 StatefulWidget didUpdateWidget - 父组件数据变化时调用');
  }
  
  @override
  void dispose() {
    print('🗑️ StatefulWidget dispose - 组件销毁');
    super.dispose();
  }

  // 本地状态更新方法
  void _incrementLocalCounter() {
    setState(() {
      localCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ StatefulWidget build');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 混合状态管理：GetX + 本地状态
        GetBuilder<RewardController>(
          id: 'available_rewards',
          builder: (controller) {
            print('✨ GetBuilder in StatefulWidget - GetX状态更新');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GetX 管理的状态
                Text(
                  'Available Rewards (GetX): ${controller.num}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                
                // 本地 State 管理的状态
                Text(
                  'Local Counter (setState): $localCounter',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.green,
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                Row(
                  children: [
                    // GetX 状态更新
                    ElevatedButton(
                      onPressed: () {
                        controller.addNum();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: Text('GetX ++', style: TextStyle(color: Colors.white)),
                    ),
                    
                    SizedBox(width: 12.w),
                    
                    // 本地状态更新
                    ElevatedButton(
                      onPressed: _incrementLocalCounter,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Local ++', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        
        SizedBox(height: 16.h),
        
        // 奖励列表部分（不变）
        if (widget.isLoading)
          _buildLoadingState()
        else if (widget.rewards.isNotEmpty)
          _buildRewardsList(context)
        else
          _buildEmptyState(),
      ],
    );
  }

  // 以下方法与原版本相同
  Widget _buildRewardsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.rewards.length,
      itemBuilder: (context, index) {
        final reward = widget.rewards[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListTile(
            title: Text(reward['name'] ?? 'Reward'),
            subtitle: Text(reward['description'] ?? 'Description'),
            trailing: ElevatedButton(
              onPressed: () => widget.onClaimReward(reward['id']?.toString() ?? ''),
              child: Text('Claim'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 200.h,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40.w),
      child: Column(
        children: [
          Icon(Icons.card_giftcard_outlined, size: 48.w, color: Colors.grey),
          SizedBox(height: 10.h),
          Text(
            'No rewards available',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}