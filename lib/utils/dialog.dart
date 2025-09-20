import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:async';

/// 弹窗工具类
class DialogUtils {
  /// 显示基础弹窗
  static void show({
    String title = '提示',
    String? message,
    Widget? content,
    String confirmText = '确定',
    String cancelText = '取消',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    assert(message != null || content != null, 'message 和 content 不能同时为空');
    assert(message == null || content == null, 'message 和 content 不能同时提供');
    Get.dialog(
      _buildDialog(
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: () {
          Get.back();
          onConfirm?.call();
        },
        onCancel: () {
          Get.back();
          onCancel?.call();
        },
      ),
      barrierDismissible: true,
    );
  }

  /// Promise风格弹窗 - 返回Future<bool>
  static Future<bool> confirm({
    String title = '确认',
    String? message,
    Widget? content,
    String confirmText = '确认',
    String cancelText = '取消',
  }) {
    assert(message != null || content != null, 'message 和 content 不能同时为空');
    assert(message == null || content == null, 'message 和 content 不能同时提供');
    final Completer<bool> completer = Completer<bool>();

    Get.dialog(
      _buildDialog(
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: () {
          Get.back();
          completer.complete(true); // resolve(true)
        },
        onCancel: () {
          Get.back();
          completer.complete(false); // resolve(false)
        },
      ),
      barrierDismissible: true,
    ).then((_) {
      // 如果通过点击外部区域关闭，返回false
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    return completer.future;
  }

  /// 构建弹窗Widget
  static Widget _buildDialog({
    required String title,
    String? message,
    Widget? content,
    required String confirmText,
    required String cancelText,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: Get.width * 0.85,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部标题栏 - 黑色背景，白色文字
              _buildHeader(title),
              
              // 中间内容区域
              _buildContent(message, content),
              
              // 底部按钮区域 - 上下两个按钮
              _buildActions(
                confirmText: confirmText,
                cancelText: cancelText,
                onConfirm: onConfirm,
                onCancel: onCancel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建弹窗头部 - 黑色标题栏
  static Widget _buildHeader(String title) {
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
          // 左侧占位，保证标题居中
          SizedBox(width: 56.w), // 与右侧关闭按钮同等宽度
          
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // 右侧关闭按钮
          SizedBox(
            width: 56.w,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 24.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建弹窗内容区域
  static Widget _buildContent(String? message, Widget? content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      constraints: BoxConstraints(
        minHeight: 80.h,
        maxHeight: 300.h,
      ),
      child: SingleChildScrollView(
        child: content ?? Text(
          message ?? '',
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

  /// 构建弹窗底部按钮 - 上下布局
  static Widget _buildActions({
    required String confirmText,
    required String cancelText,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // 上方按钮 - 主按钮
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 2,
              ),
              child: Text(
                confirmText,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // 下方按钮 - 次按钮
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                cancelText,
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

  // === 预设弹窗方法 ===

  /// 信息弹窗
  static void info({
    String title = '信息',
    String? message,
    Widget? content,
    String confirmText = '知道了',
    VoidCallback? onConfirm,
  }) {
    show(
      title: title,
      message: message,
      content: content,
      confirmText: confirmText,
      cancelText: '关闭',
      onConfirm: onConfirm,
    );
  }

  /// 成功弹窗
  static void success({
    String title = '✅ 成功',
    String? message,
    Widget? content,
    String confirmText = '太好了',
    VoidCallback? onConfirm,
  }) {
    show(
      title: title,
      message: message,
      content: content,
      confirmText: confirmText,
      cancelText: '关闭',
      onConfirm: onConfirm,
    );
  }

  /// 警告弹窗
  static void warning({
    String title = '⚠️ 警告',
    String? message,
    Widget? content,
    String confirmText = '知道了',
    VoidCallback? onConfirm,
  }) {
    show(
      title: title,
      message: message,
      content: content,
      confirmText: confirmText,
      cancelText: '忽略',
      onConfirm: onConfirm,
    );
  }

  /// 错误弹窗
  static void error({
    String title = '❌ 错误',
    String? message,
    Widget? content,
    String confirmText = '重试',
    VoidCallback? onConfirm,
  }) {
    show(
      title: title,
      message: message,
      content: content,
      confirmText: confirmText,
      cancelText: '取消',
      onConfirm: onConfirm,
    );
  }

  // === Promise风格预设方法 ===

  /// 删除确认
  static Future<bool> confirmDelete(String itemName) {
    return confirm(
      title: '确认删除',
      message: '确定要删除"$itemName"吗？\n\n此操作不可撤销！',
      confirmText: '删除',
      cancelText: '保留',
    );
  }

  /// 保存确认
  static Future<bool> confirmSave([String? message]) {
    return confirm(
      title: '保存确认',
      message: message ?? '是否保存当前更改？',
      confirmText: '保存',
      cancelText: '不保存',
    );
  }

  /// 退出确认
  static Future<bool> confirmExit([String? message]) {
    return confirm(
      title: '退出确认',
      message: message ?? '确定要退出吗？',
      confirmText: '退出',
      cancelText: '取消',
    );
  }

  // === 快速提示方法 ===

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

/// 使用Flutter原生Dialog的弹窗工具类
class NativeDialog {
  /// 显示原生风格弹窗
  static void show({
    String title = '提示',
    String? message,
    Widget? content,
    String confirmText = '确定',
    String cancelText = '取消',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    assert(message != null || content != null, 'message 和 content 不能同时为空');
    assert(message == null || content == null, 'message 和 content 不能同时提供');
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: content ?? Text(
              message ?? '',
              style: TextStyle(
                fontSize: 16.sp,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
              child: Text(
                cancelText,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  /// Promise风格原生弹窗
  static Future<bool> confirm({
    String title = '确认',
    String? message,
    Widget? content,
    String confirmText = '确认',
    String cancelText = '取消',
  }) {
    assert(message != null || content != null, 'message 和 content 不能同时为空');
    assert(message == null || content == null, 'message 和 content 不能同时提供');
    final Completer<bool> completer = Completer<bool>();

    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: content ?? Text(
              message ?? '',
              style: TextStyle(
                fontSize: 16.sp,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false);
              },
              child: Text(
                cancelText,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    ).then((_) {
      // 如果通过点击外部区域关闭，返回false
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    return completer.future;
  }

  /// 原生风格的自定义AlertDialog
  static void showCustomAlert({
    String title = '提示',
    required String message,
    List<String> actions = const ['确定', '取消'],
    List<VoidCallback>? callbacks,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(fontSize: 18.sp),
              ),
            ],
          ),
          content: Container(
            constraints: BoxConstraints(maxHeight: 200.h),
            child: SingleChildScrollView(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          actions: List.generate(actions.length, (index) {
            return index == 0
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      callbacks?[index]?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(actions[index]),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (callbacks != null && index < callbacks.length) {
                        callbacks[index]?.call();
                      }
                    },
                    child: Text(
                      actions[index],
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
          }),
        );
      },
    );
  }

  /// 简单信息弹窗
  static void info({
    String? message,
    Widget? content,
    String confirmText = '知道了',
    VoidCallback? onConfirm,
  }) {
    assert(message != null || content != null, 'message 和 content 不能同时为空');
    assert(message == null || content == null, 'message 和 content 不能同时提供');
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8.w),
              Text('信息'),
            ],
          ),
          content: content ?? Text(message ?? ''),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  /// 成功弹窗
  static void success({
    String? message,
    Widget? content,
    String confirmText = '太好了',
    VoidCallback? onConfirm,
  }) {
    assert(message != null || content != null, 'message 和 content 不能同时为空');
    assert(message == null || content == null, 'message 和 content 不能同时提供');
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8.w),
              Text('成功'),
            ],
          ),
          content: content ?? Text(message ?? ''),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  /// 警告弹窗
  static void warning({
    String? message,
    Widget? content,
    String confirmText = '知道了',
    VoidCallback? onConfirm,
  }) {
    assert(message != null || content != null, 'message 和 content 不能同时为空');
    assert(message == null || content == null, 'message 和 content 不能同时提供');
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8.w),
              Text('警告'),
            ],
          ),
          content: content ?? Text(message ?? ''),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  /// 错误弹窗
  static void error({
    String? message,
    Widget? content,
    String confirmText = '重试',
    VoidCallback? onConfirm,
  }) {
    assert(message != null || content != null, 'message 和 content 不能同时为空');
    assert(message == null || content == null, 'message 和 content 不能同时提供');
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8.w),
              Text('错误'),
            ],
          ),
          content: content ?? Text(message ?? ''),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('取消', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  // === Promise风格预设方法 ===

  /// Promise风格删除确认
  static Future<bool> confirmDelete(String itemName) {
    return confirm(
      title: '确认删除',
      message: '确定要删除"$itemName"吗？\n\n此操作不可撤销！',
      confirmText: '删除',
      cancelText: '保留',
    );
  }

  /// Promise风格保存确认
  static Future<bool> confirmSave([String? message]) {
    return confirm(
      title: '保存确认',
      message: message ?? '是否保存当前更改？',
      confirmText: '保存',
      cancelText: '不保存',
    );
  }

  /// Promise风格退出确认
  static Future<bool> confirmExit([String? message]) {
    return confirm(
      title: '退出确认',
      message: message ?? '确定要退出吗？',
      confirmText: '退出',
      cancelText: '取消',
    );
  }
}