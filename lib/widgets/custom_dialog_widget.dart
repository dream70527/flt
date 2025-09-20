import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/dialog_controller.dart';

/// 自定义弹窗组件
class CustomDialogWidget extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;
  final String topButtonText;
  final String bottomButtonText;
  final VoidCallback? onTopPressed;
  final VoidCallback? onBottomPressed;
  final VoidCallback? onClose;

  const CustomDialogWidget({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.topButtonText = '确认',
    this.bottomButtonText = '取消',
    this.onTopPressed,
    this.onBottomPressed,
    this.onClose,
  }) : assert(content != null || contentWidget != null, 'content 和 contentWidget 不能同时为空'),
       assert(content == null || contentWidget == null, 'content 和 contentWidget 不能同时提供');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: Get.width * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部标题栏
            _buildDialogHeader(),
            
            // 中间内容区域
            _buildDialogContent(),
            
            // 底部按钮区域
            _buildDialogActions(),
          ],
        ),
      ),
    );
  }

  /// 构建弹窗头部
  Widget _buildDialogHeader() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onClose ?? () => Get.back(),
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 24.w,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建弹窗内容
  Widget _buildDialogContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      constraints: BoxConstraints(
        minHeight: 80.h,
        maxHeight: 300.h,
      ),
      child: SingleChildScrollView(
        child: contentWidget ?? Text(
          content ?? '',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// 构建弹窗底部按钮
  Widget _buildDialogActions() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // 上方按钮
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onTopPressed ?? () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 2,
              ),
              child: Text(
                topButtonText,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // 下方按钮
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton(
              onPressed: onBottomPressed ?? () => Get.back(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                bottomButtonText,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 弹窗工具类
class DialogUtils {
  /// 获取或创建DialogController
  static DialogController _getController() {
    try {
      return Get.find<DialogController>();
    } catch (e) {
      return Get.put<DialogController>(DialogController());
    }
  }

  /// 显示基础自定义弹窗
  static void showCustom({
    String title = '提示',
    String? message,
    Widget? contentWidget,
    String confirmText = '确定',
    String cancelText = '取消',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    assert(message != null || contentWidget != null, 'message 和 contentWidget 不能同时为空');
    assert(message == null || contentWidget == null, 'message 和 contentWidget 不能同时提供');
    final controller = _getController();
    controller.showCustomDialog(
      title: title,
      content: message,
      contentWidget: contentWidget,
      topButton: confirmText,
      bottomButton: cancelText,
      onTopPressed: () {
        controller.closeDialog();
        onConfirm?.call();
      },
      onBottomPressed: () {
        controller.closeDialog();
        onCancel?.call();
      },
    );
  }

  /// Promise风格的确认弹窗
  static Future<bool> showConfirm({
    String title = '确认',
    String? message,
    Widget? contentWidget,
    String confirmText = '确认',
    String cancelText = '取消',
  }) {
    assert(message != null || contentWidget != null, 'message 和 contentWidget 不能同时为空');
    assert(message == null || contentWidget == null, 'message 和 contentWidget 不能同时提供');
    final controller = _getController();
    return controller.showDialogWithPromise(
      title: title,
      content: message,
      contentWidget: contentWidget,
      confirmText: confirmText,
      cancelText: cancelText,
    );
  }

  /// Promise风格的信息弹窗
  static Future<void> showInfo({
    String title = '信息',
    String? message,
    Widget? contentWidget,
    String confirmText = '知道了',
  }) {
    assert(message != null || contentWidget != null, 'message 和 contentWidget 不能同时为空');
    assert(message == null || contentWidget == null, 'message 和 contentWidget 不能同时提供');
    final controller = _getController();
    return controller.showInfoWithPromise(message, contentWidget);
  }

  /// 显示信息弹窗
  static void showInfoDialog({
    required String title,
    String? message,
    Widget? contentWidget,
    String confirmText = '确定',
    VoidCallback? onConfirm,
  }) {
    showCustom(
      title: title,
      message: message,
      contentWidget: contentWidget,
      confirmText: confirmText,
      cancelText: '取消',
      onConfirm: onConfirm,
    );
  }

  /// 显示确认弹窗
  static void showConfirmDialog({
    required String title,
    String? message,
    Widget? contentWidget,
    String confirmText = '确认',
    String cancelText = '取消',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showCustom(
      title: title,
      message: message,
      contentWidget: contentWidget,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  /// 显示警告弹窗
  static void showWarning({
    String? message,
    Widget? contentWidget,
    String confirmText = '知道了',
    VoidCallback? onConfirm,
  }) {
    showCustom(
      title: '⚠️ 警告',
      message: message,
      contentWidget: contentWidget,
      confirmText: confirmText,
      cancelText: '忽略',
      onConfirm: onConfirm,
    );
  }

  /// 显示成功弹窗
  static void showSuccess({
    String? message,
    Widget? contentWidget,
    String confirmText = '太好了',
    VoidCallback? onConfirm,
  }) {
    showCustom(
      title: '✅ 成功',
      message: message,
      contentWidget: contentWidget,
      confirmText: confirmText,
      cancelText: '关闭',
      onConfirm: onConfirm,
    );
  }

  /// 显示错误弹窗
  static void showError({
    String? message,
    Widget? contentWidget,
    String confirmText = '重试',
    VoidCallback? onConfirm,
  }) {
    showCustom(
      title: '❌ 错误',
      message: message,
      contentWidget: contentWidget,
      confirmText: confirmText,
      cancelText: '取消',
      onConfirm: onConfirm,
    );
  }

  // === Promise风格方法 ===

  /// Promise风格删除确认
  static Future<bool> confirmDelete(String itemName) {
    return showConfirm(
      title: '确认删除',
      message: '确定要删除"$itemName"吗？\n\n此操作不可撤销！',
      confirmText: '删除',
      cancelText: '保留',
    );
  }

  /// Promise风格保存确认
  static Future<bool> confirmSave([String? message]) {
    return showConfirm(
      title: '保存确认',
      message: message ?? '是否保存当前更改？',
      confirmText: '保存',
      cancelText: '不保存',
    );
  }

  /// Promise风格退出确认
  static Future<bool> confirmExit([String? message]) {
    return showConfirm(
      title: '退出确认',
      message: message ?? '确定要退出吗？',
      confirmText: '退出',
      cancelText: '取消',
    );
  }

  /// Promise风格操作流程
  static Future<bool> showWorkflow({
    required String title,
    required String message,
    String confirmText = '开始',
    String cancelText = '取消',
  }) async {
    final confirmed = await showConfirm(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
    );

    if (confirmed) {
      // 显示进度提示
      Get.snackbar('执行中', '正在执行操作...');
      return true;
    } else {
      Get.snackbar('已取消', '用户取消了操作');
      return false;
    }
  }

  /// 快速成功提示
  static void quickSuccess(String message) {
    Get.snackbar(
      '✅ 成功',
      message,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: Duration(seconds: 2),
    );
  }

  /// 快速错误提示
  static void quickError(String message) {
    Get.snackbar(
      '❌ 错误',
      message,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      duration: Duration(seconds: 3),
    );
  }

  /// 快速警告提示
  static void quickWarning(String message) {
    Get.snackbar(
      '⚠️ 警告',
      message,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.orange.shade800,
      duration: Duration(seconds: 3),
    );
  }

  /// 快速信息提示
  static void quickInfo(String message) {
    Get.snackbar(
      '💡 提示',
      message,
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade800,
      duration: Duration(seconds: 2),
    );
  }
}