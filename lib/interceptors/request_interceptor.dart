import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import '../utils/storage_manager.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra['isShowLoading'] ?? false) {
      // ToastUtils.showLoading();
    }

    Map<String, dynamic> headers = options.headers;

    // 自动添加token到请求头
    final token = StorageManager.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    // 需求替换掉第一个/ 要不然加密失败
    String apiPath = options.path.replaceFirst("/", "");
    final secretToken = 'api-78-token';
    final timestamp = generateHexTimestamp();
    // X-Verification-Token : 1f9d3c4f6bebe37ea13ffdf7215879ba38808a33f56a67b4535fac215d250765:api-78-token:1973f745170
    String xToken = generateFinalToken(
      uri: apiPath,
      secretToken: secretToken,
      timestamp: timestamp,
    );

    headers['Accept'] = 'application/json';
    headers['Content-Type'] = 'application/json';
    headers['Cache-Control'] = 'no-cache';
    headers['Accept-Language'] = 'zh';
    headers['X-Requested-With'] = 'XMLHttpRequest';
    headers['X-Verification-Token'] = xToken;

    headers.removeWhere((key, value) => value == null);
    options.headers = headers;
    handler.next(options);
  }

  String generateHexTimestamp() {
    final milliseconds = DateTime.now().millisecondsSinceEpoch;
    return milliseconds.toRadixString(16);
  }

  String generateFinalToken({
    required String uri,
    required String secretToken,
    required String timestamp,
  }) {
    final originalString = '$secretToken:$uri:$timestamp';
    // 生成 SHA-256 哈希值
    final bytes = utf8.encode(originalString);
    final digest = sha256.convert(bytes).toString();
    // 拼接最终 Token
    final finalToken = '$digest:$secretToken:$timestamp';
    return finalToken;
  }
}