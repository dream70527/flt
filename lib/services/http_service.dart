import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? code;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.code,
  });

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error(String message, {int? code}) {
    return ApiResponse(
      success: false,
      message: message,
      code: code,
    );
  }
}

// String baseUrl =
class HttpService extends getx.GetxService {
  late Dio _dio;

  static const String baseUrl = 'https://gx003-api.w9fun.com'; // 替换为实际的API地址
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: connectTimeout),
      receiveTimeout: const Duration(milliseconds: receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.extra['isShowLoading'] ?? false) {
          // ToastUtils.showLoading();
        }

        Map<String, dynamic> headers = options.headers;

        // String? token = StringKV.token.get();
        // if (token == null) {
        //   UserController.to.loginStatus.value = false;
        // }

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
        // print("---------------");
        // print(xToken);
        headers['Accept'] = 'application/json';
        headers['Content-Type'] = 'application/json';
        headers['Cache-Control'] = 'no-cache';
        // headers['token'] = token;
        headers['Accept-Language'] = 'zh';
        headers['X-Requested-With'] = 'XMLHttpRequest';
        headers['X-Verification-Token'] = xToken;

        headers.removeWhere((key, value) => value == null);
        options.headers = headers;
        handler.next(options);
      },
      onResponse: (response, handler) {
        // 统一在这里处理响应数据
        // dynamic responseData = response.data;
        //
        // // 处理后端返回的包装结构 {data: [...], message: 'ok'}
        // if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        //   response.data = responseData['data'];
        // }
        
        handler.next(response);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));
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

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<List<T>>> getList<T>(
    String path, {
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleListResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<List<T>>(e);
    }
  }

  ApiResponse<List<T>> _handleListResponse<T>(
    Response response, 
    T Function(Map<String, dynamic>) fromJson
  ) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic responseData = response.data;
      
      // 处理后端返回的包装结构 {data: [...], message: 'ok'}
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        responseData = responseData['data'];
      }
      
      if (responseData is List) {
        final list = responseData
            .map((json) => fromJson(json as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(list, message: 'Success');
      } else {
        return ApiResponse.error('Expected list data but got ${responseData.runtimeType}');
      }
    } else {
      return ApiResponse.error(
        'Request failed with status: ${response.statusCode}',
        code: response.statusCode,
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  ApiResponse<T> _handleResponse<T>(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic responseData = response.data;
      
      // 处理后端返回的包装结构 {data: [...], message: 'ok'}
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        responseData = responseData['data'];
      }
      
      // 处理模型序列化
      if (T.toString().startsWith('List<') && T.toString().contains('Model')) {
        // 处理 List<SomeModel> 类型
        if (responseData is List) {
          // 这里需要根据具体的模型类型进行转换
          // 暂时返回原始数据，让上层处理
          return ApiResponse.success(responseData as T, message: 'Success');
        }
      }
      
      return ApiResponse.success(
        responseData as T,
        message: 'Success',
      );
    } else {
      return ApiResponse.error(
        'Request failed with status: ${response.statusCode}',
        code: response.statusCode,
      );
    }
  }

  ApiResponse<T> _handleError<T>(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiResponse.error('Connection timeout');
        case DioExceptionType.sendTimeout:
          return ApiResponse.error('Send timeout');
        case DioExceptionType.receiveTimeout:
          return ApiResponse.error('Receive timeout');
        case DioExceptionType.connectionError:
          return ApiResponse.error('Connection error');
        case DioExceptionType.cancel:
          return ApiResponse.error('Request cancelled');
        default:
          return ApiResponse.error(
            error.message ?? 'Unknown error',
            code: error.response?.statusCode,
          );
      }
    }
    return ApiResponse.error('Unexpected error: $error');
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}