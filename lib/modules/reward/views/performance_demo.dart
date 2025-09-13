import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/reward_controller.dart';
import '../widgets/independent_counter_widget.dart';

/// 性能优化演示页面
class PerformanceDemo extends StatelessWidget {
  const PerformanceDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX 性能优化演示'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // 强制刷新整个页面来测试
              Get.forceAppUpdate();
            },
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
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 性能优化演示',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '观察控制台输出，了解哪些组件被重新构建：',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '🔄 表示整个页面重建\n'
                      '✨ 表示带ID的组件重建\n'
                      '🎯 表示独立Controller组件重建',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // 方案一：使用 GetBuilder ID
            Text(
              '方案一：GetBuilder ID 机制',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 12.h),
            
            GetBuilder<RewardController>(
              id: 'demo_counter',
              builder: (controller) {
                print('✨ 方案一组件 build - 只更新带ID的部分');
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'ID计数器: ${controller.num}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () {
                          controller.num++;
                          controller.update(['demo_counter']); // 只更新指定ID
                        },
                        child: Text('点击增加 (只更新此组件)'),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            SizedBox(height: 20.h),
            
            // 方案二：独立 Controller
            Text(
              '方案二：独立 Controller',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 12.h),
            
            IndependentCounterWidget(),
            
            SizedBox(height: 20.h),
            
            // 对比：会影响整个页面的操作
            Text(
              '对比：影响整个页面的操作',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 12.h),
            
            GetBuilder<RewardController>(
              builder: (controller) {
                print('🔄 整个页面组件 build - 这会触发页面重建');
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '页面级计数器: ${controller.num}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () {
                          controller.num++;
                          controller.update(); // 更新所有监听的组件
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          '点击增加 (会重建整个页面)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            SizedBox(height: 20.h),
            
            // 总结
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📝 总结',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '• 方案一：使用 update([\'id\']) 只更新指定组件\n'
                      '• 方案二：独立 Controller 完全隔离状态\n'
                      '• 避免使用 update() 无参数调用，会重建所有组件',
                      style: TextStyle(fontSize: 12.sp),
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
}