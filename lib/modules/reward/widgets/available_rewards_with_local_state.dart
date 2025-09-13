import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/reward_controller.dart';

/// 带本地状态控制的 AvailableRewardsWidget
/// 这个版本演示了如何混合使用 GetX 状态和本地状态
class AvailableRewardsWithLocalState extends StatefulWidget {
  final Function(String rewardId)? onClaimReward;

  const AvailableRewardsWithLocalState({
    super.key,
    this.onClaimReward,
  });

  @override
  State<AvailableRewardsWithLocalState> createState() => _AvailableRewardsWithLocalStateState();
}

class _AvailableRewardsWithLocalStateState extends State<AvailableRewardsWithLocalState> {
  // 本地状态
  int _displayCount = 3; // 默认显示3条
  bool _showOnlyAvailable = false; // 是否只显示可领取的
  String _sortBy = 'points'; // 排序方式
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  
  late RewardController _rewardController;

  @override
  void initState() {
    super.initState();
    _rewardController = Get.find<RewardController>();
    print('🔧 AvailableRewardsWithLocalState initState');
    
    // 监听搜索输入
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    print('🗑️ AvailableRewardsWithLocalState dispose');
    super.dispose();
  }

  // 过滤和排序奖励数据
  List<dynamic> _getFilteredRewards(List<dynamic> allRewards) {
    var filtered = allRewards.where((reward) {
      // 搜索过滤
      if (_searchText.isNotEmpty) {
        final name = (reward['name'] ?? '').toString().toLowerCase();
        final description = (reward['description'] ?? '').toString().toLowerCase();
        if (!name.contains(_searchText) && !description.contains(_searchText)) {
          return false;
        }
      }
      
      // 可用性过滤
      if (_showOnlyAvailable) {
        final requiredPoints = reward['points'] as int? ?? 0;
        if (_rewardController.totalPoints < requiredPoints) {
          return false;
        }
      }
      
      return true;
    }).toList();

    // 排序
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'points':
          return (a['points'] as int? ?? 0).compareTo(b['points'] as int? ?? 0);
        case 'name':
          return (a['name'] ?? '').toString().compareTo(b['name'] ?? '');
        default:
          return 0;
      }
    });

    // 限制显示数量
    return filtered.take(_displayCount).toList();
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ AvailableRewardsWithLocalState build');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 控制面板
        _buildControlPanel(),
        
        SizedBox(height: 16.h),
        
        // 奖励列表 - 使用 GetBuilder 监听 GetX 状态
        GetBuilder<RewardController>(
          builder: (controller) {
            print('✨ GetBuilder in AvailableRewardsWithLocalState');
            
            if (controller.isLoading) {
              return _buildLoadingState();
            }

            final filteredRewards = _getFilteredRewards(controller.rewards);
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 状态信息
                _buildStatusInfo(controller.rewards.length, filteredRewards.length),
                
                SizedBox(height: 12.h),
                
                // 奖励列表
                if (filteredRewards.isNotEmpty)
                  _buildRewardsList(filteredRewards)
                else
                  _buildEmptyState(),
              ],
            );
          },
        ),
      ],
    );
  }

  /// 构建控制面板
  Widget _buildControlPanel() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎛️ 控制面板 (本地状态)',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // 搜索框
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索奖励...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // 显示数量控制
            Row(
              children: [
                Text('显示数量: '),
                SizedBox(width: 8.w),
                ...List.generate(5, (index) {
                  final count = index + 1;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ChoiceChip(
                      label: Text('$count'),
                      selected: _displayCount == count,
                      onSelected: (selected) {
                        setState(() {
                          _displayCount = count;
                        });
                      },
                    ),
                  );
                }),
                ChoiceChip(
                  label: Text('全部'),
                  selected: _displayCount == 999,
                  onSelected: (selected) {
                    setState(() {
                      _displayCount = 999;
                    });
                  },
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // 过滤和排序选项
            Row(
              children: [
                // 只显示可领取的
                Checkbox(
                  value: _showOnlyAvailable,
                  onChanged: (value) {
                    setState(() {
                      _showOnlyAvailable = value ?? false;
                    });
                  },
                ),
                Text('只显示可领取'),
                
                SizedBox(width: 16.w),
                
                // 排序方式
                Text('排序: '),
                DropdownButton<String>(
                  value: _sortBy,
                  items: [
                    DropdownMenuItem(value: 'points', child: Text('按积分')),
                    DropdownMenuItem(value: 'name', child: Text('按名称')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value ?? 'points';
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建状态信息
  Widget _buildStatusInfo(int totalCount, int filteredCount) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 20.w),
          SizedBox(width: 8.w),
          Text(
            '显示 $filteredCount / $totalCount 个奖励',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
          Spacer(),
          GetBuilder<RewardController>(
            id: 'total_points',
            builder: (controller) {
              return Text(
                '可用积分: ${controller.totalPoints}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建奖励列表
  Widget _buildRewardsList(List<dynamic> rewards) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        final requiredPoints = reward['points'] as int? ?? 0;
        final canClaim = _rewardController.totalPoints >= requiredPoints;
        
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // 奖励图标
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: canClaim ? Colors.green.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: canClaim ? Colors.green : Colors.grey,
                    size: 24.w,
                  ),
                ),
                
                SizedBox(width: 16.w),
                
                // 奖励信息
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.stars, size: 16.w, color: Colors.orange),
                          SizedBox(width: 4.w),
                          Text(
                            '$requiredPoints pts',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: canClaim ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 领取按钮
                ElevatedButton(
                  onPressed: canClaim ? () {
                    widget.onClaimReward?.call(reward['id']?.toString() ?? '');
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canClaim ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    canClaim ? '领取' : '积分不足',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建加载状态
  Widget _buildLoadingState() {
    return SizedBox(
      height: 200.h,
      child: Center(child: CircularProgressIndicator()),
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
            Icons.search_off,
            size: 48.w,
            color: Colors.grey,
          ),
          SizedBox(height: 10.h),
          Text(
            _searchText.isNotEmpty ? '没有找到匹配的奖励' : '没有符合条件的奖励',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          if (_searchText.isNotEmpty || _showOnlyAvailable) ...[
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchText = '';
                  _showOnlyAvailable = false;
                  _displayCount = 999;
                });
              },
              child: Text('清除筛选条件'),
            ),
          ],
        ],
      ),
    );
  }
}