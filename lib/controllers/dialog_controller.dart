import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class DialogController extends GetxController {
  // 弹窗状态管理
  RxBool isDialogShowing = false.obs;
  
  // 弹窗内容
  RxString dialogTitle = '提示'.obs;
  RxString dialogContent = '这是弹窗内容，可以放置任何信息。'.obs;
  Rx<Widget?> dialogContentWidget = Rx<Widget?>(null);
  RxString topButtonText = '确认'.obs;
  RxString bottomButtonText = '取消'.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('DialogController 初始化');
  }

  @override
  void onClose() {
    super.onClose();
    print('DialogController 销毁');
  }

  /// 显示自定义弹窗
  void showCustomDialog({
    String? title,
    String? content,
    Widget? contentWidget,
    String? topButton,
    String? bottomButton,
    VoidCallback? onTopPressed,
    VoidCallback? onBottomPressed,
  }) {
    assert(content != null || contentWidget != null, 'content 和 contentWidget 不能同时为空');
    assert(content == null || contentWidget == null, 'content 和 contentWidget 不能同时提供');
    
    if (title != null) dialogTitle.value = title;
    if (content != null) {
      dialogContent.value = content;
      dialogContentWidget.value = null;
    }
    if (contentWidget != null) {
      dialogContentWidget.value = contentWidget;
      dialogContent.value = '';
    }
    if (topButton != null) topButtonText.value = topButton;
    if (bottomButton != null) bottomButtonText.value = bottomButton;
    
    isDialogShowing.value = true;
    
    Get.dialog(
      _buildCustomDialog(
        onTopPressed: onTopPressed ?? () => closeDialog(),
        onBottomPressed: onBottomPressed ?? () => closeDialog(),
      ),
      barrierDismissible: true,
    );
  }

  /// Promise风格的弹窗 - 返回Future<bool>
  Future<bool> showDialogWithPromise({
    String? title,
    String? content,
    Widget? contentWidget,
    String? confirmText,
    String? cancelText,
  }) {
    assert(content != null || contentWidget != null, 'content 和 contentWidget 不能同时为空');
    assert(content == null || contentWidget == null, 'content 和 contentWidget 不能同时提供');
    final Completer<bool> completer = Completer<bool>();
    
    if (title != null) dialogTitle.value = title;
    if (content != null) {
      dialogContent.value = content;
      dialogContentWidget.value = null;
    }
    if (contentWidget != null) {
      dialogContentWidget.value = contentWidget;
      dialogContent.value = '';
    }
    if (confirmText != null) topButtonText.value = confirmText;
    if (cancelText != null) bottomButtonText.value = cancelText;
    
    isDialogShowing.value = true;
    
    Get.dialog(
      _buildCustomDialog(
        onTopPressed: () {
          closeDialog();
          completer.complete(true); // resolve(true)
        },
        onBottomPressed: () {
          closeDialog();
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

  /// Promise风格的确认弹窗
  Future<bool> showConfirmWithPromise(String message) {
    return showDialogWithPromise(
      title: '确认',
      content: message,
      confirmText: '确认',
      cancelText: '取消',
    );
  }

  /// Promise风格的信息弹窗
  Future<void> showInfoWithPromise(String? message, [Widget? contentWidget]) {
    assert(message != null || contentWidget != null, 'message 和 contentWidget 不能同时为空');
    assert(message == null || contentWidget == null, 'message 和 contentWidget 不能同时提供');
    final Completer<void> completer = Completer<void>();
    
    showCustomDialog(
      title: '提示',
      content: message,
      contentWidget: contentWidget,
      topButton: '知道了',
      bottomButton: '关闭',
      onTopPressed: () {
        closeDialog();
        completer.complete(); // resolve()
      },
      onBottomPressed: () {
        closeDialog();
        completer.complete(); // resolve()
      },
    );
    
    return completer.future;
  }

  /// 关闭弹窗
  void closeDialog() {
    isDialogShowing.value = false;
    Get.back();
  }

  /// 构建自定义弹窗
  Widget _buildCustomDialog({
    required VoidCallback onTopPressed,
    required VoidCallback onBottomPressed,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: Get.width * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部标题栏
            _buildDialogHeader(),
            
            // 中间内容区域
            _buildDialogContent(),
            
            // 底部按钮区域
            _buildDialogActions(
              onTopPressed: onTopPressed,
              onBottomPressed: onBottomPressed,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建弹窗头部
  Widget _buildDialogHeader() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Obx(() => Text(
                dialogTitle.value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ),
          IconButton(
            onPressed: closeDialog,
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 24,
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
      padding: EdgeInsets.all(20),
      child: Obx(() {
        final widget = dialogContentWidget.value;
        if (widget != null) {
          return SingleChildScrollView(child: widget);
        }
        return Text(
          dialogContent.value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        );
      }),
    );
  }

  /// 构建弹窗底部按钮
  Widget _buildDialogActions({
    required VoidCallback onTopPressed,
    required VoidCallback onBottomPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // 上方按钮
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onTopPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Obx(() => Text(
                topButtonText.value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )),
            ),
          ),
          
          SizedBox(height: 12),
          
          // 下方按钮
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onBottomPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Obx(() => Text(
                bottomButtonText.value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  /// 预设弹窗方法
  void showInfoDialog(String message) {
    showCustomDialog(
      title: '信息',
      content: message,
      topButton: '确定',
      bottomButton: '取消',
    );
  }

  void showConfirmDialog(
    String message, {
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showCustomDialog(
      title: '确认',
      content: message,
      topButton: '确认',
      bottomButton: '取消',
      onTopPressed: onConfirm ?? () => closeDialog(),
      onBottomPressed: onCancel ?? () => closeDialog(),
    );
  }

  void showWarningDialog(String message) {
    showCustomDialog(
      title: '警告',
      content: message,
      topButton: '知道了',
      bottomButton: '忽略',
    );
  }
}