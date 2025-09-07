import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import '../controllers/game_controller.dart';

class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final canGoBack = await _onWillPop();
        if (canGoBack) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // 自定义导航栏
              _buildNavigationBar(context),
              // 内容区域
              Expanded(
                child: _buildGameContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建自定义导航栏
  Widget _buildNavigationBar(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 返回按钮
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20.w,
              color: Colors.black87,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 40.w,
              minHeight: 40.h,
            ),
          ),
          SizedBox(width: 8.w),
          
          // 页面标题
          Expanded(
            child: Obx(() => Text(
              controller.pageTitle.value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
          ),
          
          // 刷新按钮
          IconButton(
            onPressed: controller.reload,
            icon: Icon(
              Icons.refresh,
              size: 20.w,
              color: Colors.black87,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 40.w,
              minHeight: 40.h,
            ),
          ),
          
          // 更多选项按钮
          IconButton(
            onPressed: () => _showMoreOptions(context),
            icon: Icon(
              Icons.more_vert,
              size: 20.w,
              color: Colors.black87,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 40.w,
              minHeight: 40.h,
            ),
          ),
          
          // URL输入按钮
          IconButton(
            onPressed: () => _showUrlInput(context),
            icon: Icon(
              Icons.link,
              size: 20.w,
              color: Colors.black87,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 40.w,
              minHeight: 40.h,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建游戏内容区域
  Widget _buildGameContent() {
    return Obx(() {
      if (controller.hasError.value) {
        return _buildErrorView();
      }
      
      return Stack(
        children: [
          // 根据平台显示不同内容
          if (controller.isWeb) 
            _buildWebContent()
          else 
            _buildMobileContent(),
          
          // 加载指示器
          if (controller.isLoading.value)
            Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
    });
  }

  /// 构建Web平台内容（iframe）
  Widget _buildWebContent() {
    final viewId = controller.createIframe(controller.currentUrl.value);
    return HtmlElementView(viewType: viewId);
  }

  /// 构建移动端内容（WebView）
  Widget _buildMobileContent() {
    if (controller.webViewController != null) {
      return WebViewWidget(controller: controller.webViewController!);
    } else {
      return const Center(
        child: Text('WebView初始化失败'),
      );
    }
  }

  /// 构建错误视图
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              '页面加载失败',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              controller.errorMessage.value,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: controller.reload,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              ),
              child: Text(
                '重新加载',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示更多选项
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('返回首页'),
              onTap: () {
                Get.back();
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('刷新页面'),
              onTap: () {
                Get.back();
                controller.reload();
              },
            ),
            if (controller.isMobile) ...[
              ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('清除缓存'),
                onTap: () {
                  Get.back();
                  controller.clearCache();
                  Get.snackbar('提示', '缓存已清除');
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('页面信息'),
              onTap: () {
                Get.back();
                _showPageInfo(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 显示页面信息
  void _showPageInfo(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('页面信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('平台: ${controller.isWeb ? 'Web (iframe)' : 'Mobile (WebView)'}'),
            SizedBox(height: 8.h),
            Text('标题: ${controller.pageTitle.value}'),
            SizedBox(height: 8.h),
            Text('URL: ${controller.currentUrl.value}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  /// 显示URL输入对话框
  void _showUrlInput(BuildContext context) {
    final urlController = TextEditingController(text: controller.currentUrl.value);
    
    Get.dialog(
      AlertDialog(
        title: const Text('输入游戏URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: '请输入支持iframe的网站URL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 16.h),
            const Text(
              '建议使用支持iframe嵌入的游戏网站：\n• https://example.com\n• https://httpbin.org\n• 自己搭建的游戏网站',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final url = urlController.text.trim();
              if (url.isNotEmpty) {
                controller.loadGame(gameUrl: url);
                Get.back();
              }
            },
            child: const Text('加载'),
          ),
        ],
      ),
    );
  }

  /// 处理返回按键
  Future<bool> _onWillPop() async {
    final canGoBack = await controller.goBack();
    if (!canGoBack) {
      // 如果无法后退，则退出页面
      return true;
    }
    return false;
  }
}