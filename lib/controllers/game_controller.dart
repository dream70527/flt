import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

class GameController extends GetxController {
  WebViewController? webViewController;
  html.IFrameElement? _iframeElement;
  String? _currentViewId;
  
  // 页面状态
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString currentUrl = ''.obs;
  final RxString pageTitle = '游戏页面'.obs;
  
  // 默认游戏URL - 使用支持iframe的网站
  final String defaultGameUrl = 'https://www.baidu.com';
  
  // 平台检测
  bool get isWeb => kIsWeb;
  bool get isMobile => !kIsWeb;
  
  @override
  void onInit() {
    super.onInit();
    if (isMobile) {
      _initializeWebView();
    } else if (isWeb) {
      _setupMessageListener();
    }
    _loadGame();
  }
  
  /// 设置Web平台消息监听
  void _setupMessageListener() {
    // 监听来自iframe的消息
    html.window.onMessage.listen((html.MessageEvent event) {
      try {
        // 处理来自iframe的消息
        if (event.data is Map) {
          final data = event.data as Map;
          if (data['type'] == 'titleChange') {
            pageTitle.value = data['title'] ?? '游戏页面';
          } else if (data['type'] == 'loadComplete') {
            isLoading.value = false;
            hasError.value = false;
          } else if (data['type'] == 'error') {
            hasError.value = true;
            errorMessage.value = data['message'] ?? '页面加载错误';
            isLoading.value = false;
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('处理iframe消息失败: $e');
        }
      }
    });
  }
  
  void _initializeWebView() {
    // 只在移动端初始化WebView
    if (isMobile) {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // 更新加载进度
              if (progress == 100) {
                isLoading.value = false;
              }
            },
            onPageStarted: (String url) {
              isLoading.value = true;
              hasError.value = false;
              currentUrl.value = url;
            },
            onPageFinished: (String url) {
              isLoading.value = false;
              currentUrl.value = url;
              _getPageTitle();
            },
            onWebResourceError: (WebResourceError error) {
              hasError.value = true;
              errorMessage.value = error.description;
              isLoading.value = false;
              if (kDebugMode) {
                print('WebView error: ${error.description}');
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              // 可以在这里添加URL过滤逻辑
              return NavigationDecision.navigate;
            },
          ),
        );
    }
  }
  
  /// 加载游戏URL
  void _loadGame({String? gameUrl}) {
    final url = gameUrl ?? defaultGameUrl;
    currentUrl.value = url;
    
    if (isMobile && webViewController != null) {
      webViewController!.loadRequest(Uri.parse(url));
    } else if (isWeb) {
      // Web平台直接设置状态
      isLoading.value = false;
      hasError.value = false;
      pageTitle.value = '游戏页面';
    }
  }
  
  /// 手动加载游戏URL（供外部调用）
  void loadGame({String? gameUrl}) {
    _loadGame(gameUrl: gameUrl);
  }
  
  /// Web平台创建iframe
  String createIframe(String url) {
    if (_currentViewId != null && _iframeElement != null) {
      // 如果已有iframe，更新URL
      _iframeElement!.src = url;
      return _currentViewId!;
    }
    
    // 创建新的viewId
    final viewId = 'game-iframe-${DateTime.now().millisecondsSinceEpoch}';
    _currentViewId = viewId;
    
    // 创建iframe元素
    _iframeElement = html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..onLoad.listen((_) {
        isLoading.value = false;
        hasError.value = false;
        _extractTitleFromIframe();
      })
      ..onError.listen((_) {
        hasError.value = true;
        errorMessage.value = '页面加载失败 - 可能是网站不支持iframe嵌入';
        isLoading.value = false;
      });
    
    // 添加错误监听器来捕获X-Frame-Options错误
    html.window.addEventListener('error', (event) {
      final errorEvent = event as html.ErrorEvent;
      if (errorEvent.message?.contains('X-Frame-Options') == true || 
          errorEvent.message?.contains('frame') == true) {
        hasError.value = true;
        errorMessage.value = '网站不允许在iframe中显示，请尝试其他URL';
        isLoading.value = false;
      }
    });
    
    // 注册到Flutter
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) => _iframeElement!,
    );
    
    return viewId;
  }
  
  /// 从iframe提取标题
  void _extractTitleFromIframe() {
    // 由于跨域限制，无法直接访问contentDocument
    // 改为使用URL推断标题或等待消息通信
    try {
      final url = _iframeElement?.src ?? '';
      if (url.isNotEmpty) {
        final uri = Uri.parse(url);
        pageTitle.value = uri.host.isNotEmpty ? uri.host : '游戏页面';
      }
    } catch (e) {
      if (kDebugMode) {
        print('解析URL失败: $e');
      }
      pageTitle.value = '游戏页面';
    }
  }
  
  /// 重新加载页面
  void reload() {
    hasError.value = false;
    if (isMobile && webViewController != null) {
      webViewController!.reload();
    } else if (isWeb && _iframeElement != null) {
      isLoading.value = true;
      // 重新加载iframe
      _iframeElement!.src = _iframeElement!.src!;
    }
  }
  
  /// 返回上一页
  Future<bool> goBack() async {
    if (isMobile && webViewController != null) {
      final canGoBack = await webViewController!.canGoBack();
      if (canGoBack) {
        webViewController!.goBack();
        return true;
      }
    } else if (isWeb && _iframeElement != null) {
      // Web平台由于跨域限制，无法直接操作iframe的history
      // 可以发送消息给iframe让其自行处理
      try {
        _iframeElement!.contentWindow?.postMessage({'action': 'goBack'}, '*');
        return true;
      } catch (e) {
        if (kDebugMode) {
          print('Web平台返回失败: $e');
        }
      }
    }
    return false;
  }
  
  /// 前进到下一页
  Future<bool> goForward() async {
    if (isMobile && webViewController != null) {
      final canGoForward = await webViewController!.canGoForward();
      if (canGoForward) {
        webViewController!.goForward();
        return true;
      }
    } else if (isWeb && _iframeElement != null) {
      // Web平台发送消息给iframe让其自行处理
      try {
        _iframeElement!.contentWindow?.postMessage({'action': 'goForward'}, '*');
        return true;
      } catch (e) {
        if (kDebugMode) {
          print('Web平台前进失败: $e');
        }
      }
    }
    return false;
  }
  
  /// 获取页面标题
  void _getPageTitle() async {
    if (isMobile && webViewController != null) {
      try {
        final title = await webViewController!.getTitle();
        if (title != null) {
          pageTitle.value = title;
        }
      } catch (e) {
        if (kDebugMode) {
          print('获取页面标题失败: $e');
        }
      }
    }
  }
  
  /// 执行JavaScript代码
  Future<void> runJavaScript(String code) async {
    if (isMobile && webViewController != null) {
      try {
        await webViewController!.runJavaScript(code);
      } catch (e) {
        if (kDebugMode) {
          print('执行JavaScript失败: $e');
        }
      }
    } else if (isWeb && _iframeElement != null) {
      // Web平台通过消息传递执行JavaScript
      try {
        _iframeElement!.contentWindow?.postMessage({
          'action': 'executeScript',
          'script': code
        }, '*');
      } catch (e) {
        if (kDebugMode) {
          print('Web平台执行JavaScript失败: $e');
        }
      }
    }
  }
  
  /// 清除缓存
  Future<void> clearCache() async {
    if (isMobile && webViewController != null) {
      try {
        await webViewController!.clearCache();
        await webViewController!.clearLocalStorage();
      } catch (e) {
        if (kDebugMode) {
          print('清除缓存失败: $e');
        }
      }
    } else if (isWeb) {
      // Web平台清除缓存（需要重新加载iframe）
      if (_iframeElement != null) {
        final currentSrc = _iframeElement!.src;
        _iframeElement!.src = 'about:blank';
        await Future.delayed(const Duration(milliseconds: 100));
        _iframeElement!.src = currentSrc;
      }
    }
  }
  
  @override
  void onClose() {
    _iframeElement = null;
    _currentViewId = null;
    super.onClose();
  }
}