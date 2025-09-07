# HTTP服务拦截器使用说明

## 目录结构
```
lib/
├── interceptors/
│   ├── request_interceptor.dart    # 请求拦截器
│   ├── response_interceptor.dart   # 响应拦截器
│   └── interceptors.dart          # 导出文件
└── services/
    └── http_service.dart          # HTTP服务类
```

## 拦截器功能

### RequestInterceptor (请求拦截器)
- 自动添加API认证头信息
- 生成X-Verification-Token
- 设置通用请求头
- 支持加载状态控制

### ResponseInterceptor (响应拦截器)
- 统一响应数据处理
- 统一错误处理
- 可扩展响应数据转换

## 使用示例

### 基础用法
```dart
// 直接使用HttpService，拦截器会自动处理认证
final httpService = Get.find<HttpService>();

// 获取字符串数据
final message = await httpService.get<String>('/api/message');

// 获取单个对象
final user = await httpService.get<UserModel>(
  '/api/user/123',
  converter: (data) => UserModel.fromJson(data),
);

// 获取对象列表
final users = await httpService.get<List<UserModel>>(
  '/api/users',
  converter: (data) => (data as List)
      .map((json) => UserModel.fromJson(json))
      .toList(),
);
```

### 自定义拦截器

如果需要添加新的拦截器，可以继承Interceptor类：

```dart
class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 自定义请求处理逻辑
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 自定义响应处理逻辑
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 自定义错误处理逻辑
    super.onError(err, handler);
  }
}
```

然后在HttpService中添加：
```dart
_dio.interceptors.add(CustomInterceptor());
```