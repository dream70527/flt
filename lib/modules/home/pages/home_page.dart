import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../routes/routes.dart';
import '../../../l10n/app_localizations.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.home ?? 'Home',
          style: TextStyle(fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            onPressed: controller.refresh,
            icon: Icon(Icons.refresh, size: 24.w),
          ),
        ],
      ),
      body: Obx(() {
        // if (controller.isLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.welcome ?? 'Welcome!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.home,
                        size: 48.w,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Home Content',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                
                // 游戏入口按钮
                _buildGameEntry(context),
                
                SizedBox(height: 20.h),
                
                // 布局演示入口按钮
                _buildLayoutDemoEntry(context),
                
                SizedBox(height: 20.h),
                
                // Flutter三棵树演示入口
                _buildTreeSimulationEntry(context),
                
                SizedBox(height: 20.h),
                
                // GetX弹窗演示入口
                _buildDialogDemoEntry(context),
                
                SizedBox(height: 20.h),
                
                // 权限测试按钮
                _buildAuthTestButtons(context),
                
                SizedBox(height: 20.h),
                if (controller.activities.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.activities.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 8.h),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(controller.activities[index].name),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 48.w,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'No data available',
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
          ),
        );
      }),
    );
  }

  /// 构建游戏入口
  Widget _buildGameEntry(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          onTap: () => Get.toNamed(Routes.game),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.games,
                    color: Colors.white,
                    size: 32.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '开始游戏',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '点击进入精彩游戏世界',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建布局演示入口
  Widget _buildLayoutDemoEntry(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          onTap: () => Get.toNamed(Routes.layoutDemo),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade400,
                  Colors.green.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.dashboard,
                    color: Colors.white,
                    size: 32.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flutter 布局演示',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '查看常用布局组件示例',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建Flutter三棵树演示入口
  Widget _buildTreeSimulationEntry(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          onTap: () => Get.toNamed(Routes.treeSimulation),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade400,
                  Colors.purple.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.account_tree,
                    color: Colors.white,
                    size: 32.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flutter 三棵树演示',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '深入理解Widget、Element、RenderObject',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建GetX弹窗演示入口
  Widget _buildDialogDemoEntry(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          onTap: () => Get.toNamed(Routes.dialogDemo),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal.shade400,
                  Colors.teal.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 32.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GetX 自定义弹窗',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '黑色标题栏、圆角设计、多种弹窗类型',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建权限测试按钮
  Widget _buildAuthTestButtons(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '权限控制测试',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(Routes.settings),
                    icon: const Icon(Icons.settings),
                    label: const Text('设置页面'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(Routes.admin),
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text('管理页面'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '• 设置页面：需要登录\n• 管理页面：需要admin权限',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}