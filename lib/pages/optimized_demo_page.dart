import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/optimized_controller.dart';

class OptimizedDemoPage extends StatelessWidget {
  const OptimizedDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 技巧7: 使用 Get.put 确保Controller存在
    final controller = Get.put(OptimizedController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX 优化技巧演示'),
        actions: [
          // 技巧8: 精确的局部更新
          GetBuilder<OptimizedController>(
            id: 'counter',
            builder: (controller) {
              return Chip(
                label: Text('${controller.counter}'),
                backgroundColor: Colors.blue.shade100,
              );
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 技巧9: 组合多个状态监听
              Obx(() {
                if (controller.isLoading && !controller.isRefreshing) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                return _buildUserInfoCard(controller);
              }),
              
              SizedBox(height: 20.h),
              
              // 技巧10: 使用GetX而不是Obx减少重建范围
              GetX<OptimizedController>(
                builder: (controller) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          Text(
                            '计数器: ${controller.counter}',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '积分: ${controller.points}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              SizedBox(height: 20.h),
              
              // 技巧11: 里程碑特殊显示
              GetBuilder<OptimizedController>(
                id: 'counter_milestone',
                builder: (controller) {
                  if (controller.counter % 5 != 0 || controller.counter == 0) {
                    return const SizedBox.shrink();
                  }
                  
                  return Card(
                    color: Colors.orange.shade100,
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Text(
                        '🎉 恭喜达成 ${controller.counter} 次里程碑！',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              
              SizedBox(height: 20.h),
              
              // 操作按钮
              _buildActionButtons(controller),
              
              SizedBox(height: 20.h),
              
              // 技巧12: 性能监控
              _buildPerformanceInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(OptimizedController controller) {
    return GetBuilder<OptimizedController>(
      id: 'user_info',
      builder: (controller) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundImage: controller.avatar.isNotEmpty
                          ? NetworkImage(controller.avatar)
                          : null,
                      child: controller.avatar.isEmpty
                          ? Icon(Icons.person, size: 30.w)
                          : null,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.username.isEmpty ? '未登录' : controller.username,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (controller.email.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(
                              controller.email,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // 刷新状态指示器
                    Obx(() {
                      if (controller.isRefreshing) {
                        return SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(OptimizedController controller) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: controller.incrementCounter,
            child: const Text('增加计数'),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.loadUserData,
            child: const Text('加载数据'),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceInfo() {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '性能优化说明:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '• 使用 GetBuilder 的 id 参数实现精确更新\n'
              '• Worker (debounce/throttle) 优化频繁操作\n'
              '• 组合状态监听减少重建次数\n'
              '• 条件渲染避免不必要的组件\n'
              '• 批量状态更新提升性能',
              style: TextStyle(fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}