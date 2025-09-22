import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../routes/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/dialog.dart';
import '../../../widgets/lottie_demo_widget.dart';

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
                
                // 网格选择演示入口
                _buildGridSelectionEntry(context),
                
                SizedBox(height: 20.h),
                
                // 弹窗测试按钮
                _buildDialogTestButtons(context),
                
                SizedBox(height: 20.h),
                
                // Lottie动画演示
                LottieDemoWidget(),
                
                SizedBox(height: 20.h),
                
                // 权限测试按钮
                // _buildAuthTestButtons(context),
                
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

  /// 构建网格选择演示入口
  Widget _buildGridSelectionEntry(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          onTap: () => Get.toNamed(Routes.gridSelection),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade400,
                  Colors.orange.shade600,
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
                    Icons.grid_view,
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
                        '网格选择组件',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '2列3行布局，支持多选，亮色背景',
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

  /// 构建弹窗测试按钮区域
  Widget _buildDialogTestButtons(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💬 弹窗功能测试',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            // 第一行按钮
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showBasicDialog(),
                    icon: Icon(Icons.info_outline, size: 16.w),
                    label: Text('基础弹窗'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showConfirmDialog(),
                    icon: Icon(Icons.help_outline, size: 16.w),
                    label: Text('确认弹窗'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // 第二行按钮
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showPromiseDialog(),
                    icon: Icon(Icons.auto_awesome, size: 16.w),
                    label: Text('Promise弹窗'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showUtilsDialog(),
                    icon: Icon(Icons.build, size: 16.w),
                    label: Text('工具类弹窗'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            Text(
              '💡 提示：这些按钮演示了在首页中如何使用DialogController',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // 原生弹窗对比
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🆚 弹窗对比测试',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showNativeDialog(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('原生弹窗'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showNativePromise(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('原生Promise'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 方式1：使用基础弹窗
  void _showBasicDialog() {
    DialogUtils.show(
      title: '首页弹窗测试',
      message: '这是从首页调用的弹窗！\n\n使用utils/dialog.dart独立实现。',
      confirmText: '很棒',
      cancelText: '关闭',
      onConfirm: () {
        DialogUtils.quickSuccess('首页弹窗测试成功！');
      },
    );
  }

  /// 方式2：使用确认弹窗
  void _showConfirmDialog() {
    DialogUtils.show(
      title: '退出确认',
      message: '确定要退出应用吗？',
      confirmText: '退出',
      cancelText: '取消',
      onConfirm: () {
        DialogUtils.quickInfo('用户选择了退出');
      },
      onCancel: () {
        DialogUtils.quickInfo('用户取消了退出');
      },
    );
  }

  /// 方式3：Promise风格弹窗
  Future<void> _showPromiseDialog() async {
    // 使用Promise风格的确认弹窗
    final confirmed = await DialogUtils.confirm(
      title: '数据刷新',
      message: '是否要刷新首页数据？',
      confirmText: '刷新',
      cancelText: '取消',
    );
    
    if (confirmed) {
      // 用户确认了，执行刷新
      DialogUtils.quickInfo('正在刷新首页数据...');
      await Future.delayed(Duration(seconds: 1));
      
      // 调用首页控制器的刷新方法
      controller.refresh();
      
      DialogUtils.quickSuccess('首页数据已刷新！');
    } else {
      DialogUtils.quickWarning('用户取消了刷新操作');
    }
  }

  /// 方式4：使用预设弹窗方法
  void _showUtilsDialog() async {
    // 演示多个Promise方法
    bool shouldSave = await DialogUtils.confirmSave('是否保存当前的首页配置？');
    
    if (shouldSave) {
      DialogUtils.quickInfo('正在保存配置...');
      await Future.delayed(Duration(milliseconds: 800));
      
      bool shouldExit = await DialogUtils.confirmExit('保存成功！是否退出设置？');
      
      if (shouldExit) {
        DialogUtils.quickSuccess('配置已保存并退出！');
      } else {
        DialogUtils.success(
          message: '配置已保存，继续编辑中...',
          onConfirm: () {
            DialogUtils.quickInfo('继续编辑模式');
          },
        );
      }
    } else {
      DialogUtils.quickWarning('配置未保存');
    }
  }

  /// 原生弹窗演示
  void _showNativeDialog() {
    NativeDialog.show(
      title: '原生弹窗测试',
      message: '这是使用Flutter原生AlertDialog实现的弹窗！\n\n与自定义弹窗的区别：\n• 使用系统默认样式\n• 按钮横向排列\n• 符合Material Design',
      confirmText: '很好',
      cancelText: '关闭',
      onConfirm: () {
        NativeDialog.success(
          message: '你选择了原生弹窗的确认按钮！',
        );
      },
    );
  }

  /// 原生Promise弹窗演示
  Future<void> _showNativePromise() async {
    final confirmed = await NativeDialog.confirm(
      title: '原生Promise测试',
      message: '这是原生弹窗的Promise风格使用方式。\n\n是否要执行数据同步？',
      confirmText: '同步',
      cancelText: '取消',
    );
    
    if (confirmed) {
      DialogUtils.quickInfo('开始同步数据...');
      await Future.delayed(Duration(seconds: 1));
      
      NativeDialog.success(
        message: '数据同步完成！',
        onConfirm: () {
          DialogUtils.quickSuccess('同步流程执行完毕');
        },
      );
    } else {
      NativeDialog.warning(
        message: '用户取消了数据同步',
      );
    }
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