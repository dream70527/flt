import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/dialog_controller.dart';

/// 自定义弹窗组件
class CustomDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final String topButtonText;
  final String bottomButtonText;
  final VoidCallback? onTopPressed;
  final VoidCallback? onBottomPressed;
  final VoidCallback? onClose;

  const CustomDialogWidget({
    super.key,
    required this.title,
    required this.content,
    this.topButtonText = '确认',
    this.bottomButtonText = '取消',
    this.onTopPressed,
    this.onBottomPressed,
    this.onClose,
  });

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
        child: Text(
          content,
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
  static final DialogController _controller = Get.find<DialogController>();

  /// 显示信息弹窗
  static void showInfo({
    required String title,
    required String message,
    String confirmText = '确定',
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      CustomDialogWidget(
        title: title,
        content: message,
        topButtonText: confirmText,
        bottomButtonText: '取消',
        onTopPressed: () {
          Get.back();
          onConfirm?.call();
        },
      ),
      barrierDismissible: true,
    );
  }

  /// 显示确认弹窗
  static void showConfirm({
    required String title,
    required String message,
    String confirmText = '确认',
    String cancelText = '取消',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      CustomDialogWidget(
        title: title,
        content: message,
        topButtonText: confirmText,
        bottomButtonText: cancelText,
        onTopPressed: () {
          Get.back();
          onConfirm?.call();
        },
        onBottomPressed: () {
          Get.back();
          onCancel?.call();
        },
      ),
      barrierDismissible: true,
    );
  }

  /// 显示警告弹窗
  static void showWarning({
    required String message,
    String confirmText = '知道了',
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      CustomDialogWidget(
        title: '⚠️ 警告',
        content: message,
        topButtonText: confirmText,
        bottomButtonText: '忽略',
        onTopPressed: () {
          Get.back();
          onConfirm?.call();
        },
      ),
      barrierDismissible: true,
    );
  }

  /// 显示成功弹窗
  static void showSuccess({
    required String message,
    String confirmText = '太好了',
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      CustomDialogWidget(
        title: '✅ 成功',
        content: message,
        topButtonText: confirmText,
        bottomButtonText: '关闭',
        onTopPressed: () {
          Get.back();
          onConfirm?.call();
        },
      ),
      barrierDismissible: true,
    );
  }

  /// 显示错误弹窗
  static void showError({
    required String message,
    String confirmText = '重试',
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      CustomDialogWidget(
        title: '❌ 错误',
        content: message,
        topButtonText: confirmText,
        bottomButtonText: '取消',
        onTopPressed: () {
          Get.back();
          onConfirm?.call();
        },
      ),
      barrierDismissible: true,
    );
  }
}