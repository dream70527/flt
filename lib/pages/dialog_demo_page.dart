import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/dialog_controller.dart';
import '../widgets/custom_dialog_widget.dart';

class DialogDemoPage extends GetView<DialogController> {
  const DialogDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '自定义弹窗演示',
          style: TextStyle(fontSize: 18.sp),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 页面介绍
            _buildIntroCard(),
            
            SizedBox(height: 20.h),
            
            // 基础弹窗演示
            _buildBasicDialogSection(),
            
            SizedBox(height: 20.h),
            
            // 预设弹窗演示
            _buildPresetDialogSection(),
            
            SizedBox(height: 20.h),
            
            // 高级弹窗演示
            _buildAdvancedDialogSection(),
            
            SizedBox(height: 20.h),
            
            // Promise风格弹窗演示
            _buildPromiseStyleSection(),
            
            SizedBox(height: 20.h),
            
            // 弹窗状态监听
            _buildStatusSection(),
          ],
        ),
      ),
    );
  }

  /// 构建介绍卡片
  Widget _buildIntroCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📱 GetX 自定义弹窗演示',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '特点：\n• 顶部黑色标题栏，白色标题文字\n• 右上角关闭按钮\n• 中间内容区域\n• 底部上下两个按钮\n• 圆角设计，响应式布局',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建基础弹窗演示区域
  Widget _buildBasicDialogSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 基础弹窗',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.showCustomDialog(
                        title: '基础弹窗',
                        content: '这是一个基础的自定义弹窗示例。\n\n你可以在这里放置任何内容，包括文字、图片等。',
                        topButton: '确认操作',
                        bottomButton: '稍后再说',
                        onTopPressed: () {
                          controller.closeDialog();
                          Get.snackbar('操作成功', '你点击了确认按钮');
                        },
                        onBottomPressed: () {
                          controller.closeDialog();
                          Get.snackbar('操作取消', '你点击了取消按钮');
                        },
                      );
                    },
                    icon: Icon(Icons.chat_bubble_outline),
                    label: Text('基础弹窗'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.showCustomDialog(
                        title: '长内容弹窗',
                        content: '这是一个包含长内容的弹窗示例。\n\n' * 10 + 
                               '内容区域支持滚动，当内容过长时会自动适应。\n\n'
                               '这样可以确保弹窗不会超出屏幕范围，用户体验更好。',
                        topButton: '我知道了',
                        bottomButton: '关闭',
                      );
                    },
                    icon: Icon(Icons.article_outlined),
                    label: Text('长内容'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建预设弹窗演示区域
  Widget _buildPresetDialogSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎨 预设弹窗类型',
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
                    onPressed: () {
                      DialogUtils.showInfo(
                        title: '信息提示',
                        message: '这是一个信息提示弹窗，用于显示重要信息。',

                      );
                    },
                    icon: Icon(Icons.info_outline),
                    label: Text('信息'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      DialogUtils.showSuccess(
                        message: '操作已成功完成！数据已保存。',
                        onConfirm: () {
                          Get.snackbar('成功', '用户确认成功信息');
                        },
                      );
                    },
                    icon: Icon(Icons.check_circle_outline),
                    label: Text('成功'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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
                    onPressed: () {
                      DialogUtils.showWarning(
                        message: '警告：此操作可能会影响系统稳定性，请谨慎操作。',
                        onConfirm: () {
                          Get.snackbar('警告', '用户已确认警告');
                        },
                      );
                    },
                    icon: Icon(Icons.warning_amber_outlined),
                    label: Text('警告'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      DialogUtils.showError(
                        message: '网络连接失败，请检查网络设置后重试。',
                        onConfirm: () {
                          Get.snackbar('错误', '用户选择重试');
                        },
                      );
                    },
                    icon: Icon(Icons.error_outline),
                    label: Text('错误'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建高级弹窗演示区域
  Widget _buildAdvancedDialogSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⚡ 高级功能演示',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      DialogUtils.showConfirm(
                        title: '确认删除',
                        message: '确定要删除这个重要文件吗？\n\n此操作不可撤销！',
                        confirmText: '删除',
                        cancelText: '保留',
                        // onConfirm: () {
                        //   Get.snackbar(
                        //     '已删除',
                        //     '文件已删除',
                        //     backgroundColor: Colors.red.shade100,
                        //   );
                        // },
                      );
                    },
                    icon: Icon(Icons.delete_outline),
                    label: Text('确认操作'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.showCustomDialog(
                        title: '自定义样式',
                        content: '🎉 这是一个完全自定义的弹窗！\n\n'
                               '✨ 支持表情符号\n'
                               '🎨 支持富文本\n'
                               '🚀 响应式设计\n'
                               '💫 流畅动画',
                        topButton: '太棒了！',
                        bottomButton: '一般般',
                        onTopPressed: () {
                          controller.closeDialog();
                          Get.snackbar('反馈', '感谢你的好评！', icon: Icon(Icons.thumb_up));
                        },
                      );
                    },
                    icon: Icon(Icons.palette_outlined),
                    label: Text('自定义'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建Promise风格弹窗演示区域
  Widget _buildPromiseStyleSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🚀 Promise风格弹窗 (类似JS)',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Promise风格说明',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '• 返回Future<bool> - 成功true，取消false\n'
                    '• 支持async/await语法\n'
                    '• 支持.then()链式调用\n'
                    '• 成功后才执行后续代码',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstrateAsyncAwait(),
                    icon: Icon(Icons.add_alert),
                    label: Text('async/await'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstrateThenCatch(),
                    icon: Icon(Icons.link),
                    label: Text('.then()链式'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _demonstrateWorkflow(),
                icon: Icon(Icons.play_arrow),
                label: Text('完整工作流程演示'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 演示 async/await 用法
  Future<void> _demonstrateAsyncAwait() async {
    try {
      // 显示确认弹窗，等待用户选择
      final confirmed = await controller.showConfirmWithPromise('确定要执行删除操作吗？');
      
      if (confirmed) {
        // 用户确认了，执行后续操作
        Get.snackbar(
          '✅ 成功',
          '用户确认，开始执行删除操作...',
          backgroundColor: Colors.green.shade100,
        );
        
        // 模拟异步操作
        await Future.delayed(Duration(seconds: 1));
        
        // 显示结果
        await controller.showInfoWithPromise('删除操作已完成！');
        
        Get.snackbar(
          '🎉 完成',
          '整个流程执行完毕',
          backgroundColor: Colors.blue.shade100,
        );
      } else {
        // 用户取消了，不执行后续操作
        Get.snackbar(
          '❌ 取消',
          '用户取消操作，未执行删除',
          backgroundColor: Colors.orange.shade100,
        );
      }
    } catch (error) {
      // 处理异常
      Get.snackbar('❌ 错误', '操作过程中发生错误: $error');
    }
  }

  /// 演示 .then()/.catch() 链式调用
  void _demonstrateThenCatch() {
    controller.showConfirmWithPromise('是否保存当前更改？')
      .then((confirmed) {
        if (confirmed) {
          Get.snackbar('💾 保存中', '正在保存数据...');
          
          // 返回另一个Future，继续链式调用
          return Future.delayed(Duration(seconds: 1), () => true);
        } else {
          throw Exception('用户取消保存');
        }
      })
      .then((saveResult) {
        // 保存成功后的操作
        return controller.showInfoWithPromise('数据保存成功！');
      })
      .then((_) {
        // 所有操作完成
        Get.snackbar(
          '🎉 完成',
          '链式操作全部执行完毕',
          backgroundColor: Colors.green.shade100,
        );
      })
      .catchError((error) {
        // 捕获任何环节的错误
        Get.snackbar(
          '⚠️ 提示',
          error.toString().contains('取消') ? '操作已取消' : '发生错误: $error',
          backgroundColor: Colors.orange.shade100,
        );
      });
  }

  /// 演示完整工作流程
  Future<void> _demonstrateWorkflow() async {
    try {
      // 步骤1：确认开始
      bool startConfirmed = await controller.showDialogWithPromise(
        title: '开始流程',
        content: '即将开始多步骤操作流程，是否继续？',
        confirmText: '开始',
        cancelText: '取消',
      );

      if (!startConfirmed) {
        Get.snackbar('取消', '用户取消了操作');
        return; // 如果取消，直接返回，不执行后续代码
      }

      // 步骤2：选择操作类型
      bool isAdvanced = await controller.showDialogWithPromise(
        title: '选择模式',
        content: '请选择操作模式',
        confirmText: '高级模式',
        cancelText: '简单模式',
      );

      Get.snackbar(
        '模式选择',
        isAdvanced ? '已选择高级模式' : '已选择简单模式',
        backgroundColor: Colors.blue.shade100,
      );

      // 步骤3：执行操作
      await Future.delayed(Duration(milliseconds: 800));

      // 步骤4：确认结果
      await controller.showInfoWithPromise(
        isAdvanced 
          ? '高级模式操作已完成！已启用所有高级功能。' 
          : '简单模式操作已完成！已配置基础功能。'
      );

      // 步骤5：最终确认
      bool saveSettings = await controller.showConfirmWithPromise('是否保存这些设置？');

      if (saveSettings) {
        await Future.delayed(Duration(milliseconds: 500));
        Get.snackbar(
          '🎉 成功',
          '所有设置已保存，流程执行完毕！',
          backgroundColor: Colors.green.shade100,
        );
      } else {
        Get.snackbar(
          '⚠️ 注意',
          '设置未保存，但流程已完成',
          backgroundColor: Colors.orange.shade100,
        );
      }

    } catch (error) {
      Get.snackbar('错误', '工作流程出现异常: $error');
    }
  }

  /// 构建状态监听区域
  Widget _buildStatusSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 弹窗状态监听',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            Obx(() => Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: controller.isDialogShowing.value 
                    ? Colors.green.shade50 
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: controller.isDialogShowing.value 
                      ? Colors.green.shade300 
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    controller.isDialogShowing.value 
                        ? Icons.visibility 
                        : Icons.visibility_off,
                    color: controller.isDialogShowing.value 
                        ? Colors.green 
                        : Colors.grey,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '弹窗状态: ${controller.isDialogShowing.value ? "显示中" : "已隐藏"}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (controller.isDialogShowing.value)
                          Text(
                            '标题: ${controller.dialogTitle.value}',
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
            )),
          ],
        ),
      ),
    );
  }
}