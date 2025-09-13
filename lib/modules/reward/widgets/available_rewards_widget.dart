import 'package:claudecodeflt/modules/reward/controllers/reward_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Available Rewards Widget
/// 显示可用奖励列表的组件
class AvailableRewardsWidget extends StatelessWidget {
  final RewardController controller = Get.find<RewardController>();
  final List<dynamic> rewards;
  final Function(String rewardId) onClaimReward;
  final bool isLoading;

   AvailableRewardsWidget({
    super.key,
    required this.rewards,
    required this.onClaimReward,
    this.isLoading = false,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 使用带 id 的 GetBuilder，只监听特定更新
        GetBuilder<RewardController>(
          id: 'available_rewards',
          builder: (controller) {
            print('✨ AvailableRewardsWidget build - 只有这个组件重建');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Text(
                  'Available Rewards ${controller.num}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                InkWell(
                  onTap: (){
                    controller.addNum();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Add Num (${controller.num})',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        
        SizedBox(height: 16.h),
        // 奖励列表或空状态
        if (isLoading)
          _buildLoadingState()
        else if (rewards.isNotEmpty)
          _buildRewardsList(context)
        else
          _buildEmptyState(),
      ],
    );
  }

  /// 构建奖励列表
  Widget _buildRewardsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        return RewardItemCard(
          reward: reward,
          onClaim: () => onClaimReward(reward['id']?.toString() ?? ''),
        );
      },
    );
  }

  /// 构建加载状态
  Widget _buildLoadingState() {
    return SizedBox(
      height: 200.h,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Container(
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
    );
  }
}

/// 单个奖励项卡片组件
class RewardItemCard extends StatelessWidget {
  final dynamic reward;
  final VoidCallback onClaim;

  const RewardItemCard({
    super.key,
    required this.reward,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // 奖励图标
            _buildRewardIcon(context),
            SizedBox(width: 16.w),
            
            // 奖励信息
            Expanded(
              child: _buildRewardInfo(context),
            ),
            
            // 领取按钮
            _buildClaimButton(context),
          ],
        ),
      ),
    );
  }

  /// 构建奖励图标
  Widget _buildRewardIcon(BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        _getRewardIcon(),
        color: Theme.of(context).primaryColor,
        size: 30.w,
      ),
    );
  }

  /// 构建奖励信息
  Widget _buildRewardInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 奖励名称
        Text(
          reward['name'] ?? 'Reward',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        
        // 奖励描述
        Text(
          reward['description'] ?? 'Description',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        
        // 奖励积分
        Row(
          children: [
            Icon(
              Icons.stars,
              size: 16.w,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 4.w),
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
      ],
    );
  }

  /// 构建领取按钮
  Widget _buildClaimButton(BuildContext context) {
    final bool isClaimed = reward['claimed'] ?? false;
    
    return ElevatedButton(
      onPressed: isClaimed ? null : onClaim,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        backgroundColor: isClaimed 
            ? Colors.grey[300] 
            : Theme.of(context).primaryColor,
        foregroundColor: isClaimed 
            ? Colors.grey[600] 
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        isClaimed ? 'Claimed' : 'Claim',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 根据奖励类型获取图标
  IconData _getRewardIcon() {
    final String type = reward['type'] ?? 'gift';
    
    switch (type.toLowerCase()) {
      case 'coin':
      case 'token':
        return Icons.monetization_on;
      case 'voucher':
      case 'coupon':
        return Icons.local_offer;
      case 'badge':
      case 'achievement':
        return Icons.military_tech;
      case 'bonus':
        return Icons.card_giftcard;
      default:
        return Icons.card_giftcard;
    }
  }
}