import 'package:dio/dio.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 统一在这里处理响应数据
    // dynamic responseData = response.data;
    //
    // // 处理后端返回的包装结构 {data: [...], message: 'ok'}
    // if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
    //   response.data = responseData['data'];
    // }
    
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 可以在这里添加统一的错误处理逻辑
    // 比如统一的错误日志记录、错误提示等
    
    handler.next(err);
  }
}