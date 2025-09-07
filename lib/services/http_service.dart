import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../interceptors/interceptors.dart';

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

    _dio.interceptors.add(RequestInterceptor());
    _dio.interceptors.add(ResponseInterceptor());
  }


  Future<ApiResponse<T>> get<T>(
    String path, {
    T Function(dynamic)? converter,
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
      return _handleResponse<T>(response, converter);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? converter,
  ) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic responseData = response.data;
      
      // 处理后端返回的包装结构 {data: [...], message: 'ok'}
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        responseData = responseData['data'];
      }
      
      T result;
      if (converter != null) {
        result = converter(responseData);
      } else {
        result = responseData as T;
      }
      
      return ApiResponse.success(result, message: 'Success');
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
    T Function(dynamic)? converter,
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
      return _handleResponse<T>(response, converter);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? converter,
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
      return _handleResponse<T>(response, converter);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? converter,
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
      return _handleResponse<T>(response, converter);
    } catch (e) {
      return _handleError<T>(e);
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