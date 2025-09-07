#  Flutter App

一个基于 GetX 状态管理的 Flutter 应用程序，支持国际化、主题切换和网络请求。

## 功能特性

- ✅ **GetX 状态管理和路由管理**
- ✅ **国际化支持** (中英文切换)
- ✅ **主题切换** (亮色/暗色/跟随系统)
- ✅ **屏幕适配** (使用 flutter_screenutil)
- ✅ **网络请求封装** (基于 Dio)
- ✅ **底部导航栏** (首页/奖励/账户)
- ✅ **响应式设计**

## 项目结构

```
lib/
├── bindings/           # 依赖注入绑定
├── controllers/        # GetX 控制器
├── l10n/              # 国际化文件
├── pages/             # 页面
├── routes/            # 路由配置
├── services/          # 服务层 (HTTP等)
├── themes/            # 主题配置
├── utils/             # 工具类
└── widgets/           # 自定义组件
```

## 主要依赖

- `get`: ^4.6.6 - 状态管理和路由
- `dio`: ^5.4.0 - 网络请求
- `flutter_screenutil`: ^5.9.0 - 屏幕适配
- `get_storage`: ^2.1.1 - 本地存储
- `intl`: ^0.20.2 - 国际化

## 使用方法

### 1. 安装依赖
```bash
flutter pub get
```

### 2. 生成国际化文件
```bash
flutter gen-l10n
```

### 3. 运行应用
```bash
flutter run
```

## 核心功能详解

### 状态管理
使用 GetX 进行状态管理，提供响应式的状态更新。

### 网络请求
在控制器中直接使用封装好的 HttpService：
```dart
final response = await httpService.get<List<dynamic>>('/api/data');
if (response.success) {
  // 处理数据
}
```

### 国际化
支持中英文切换，可在设置页面进行语言切换。

### 主题切换
支持亮色、暗色和跟随系统三种主题模式。

### 屏幕适配
使用 flutter_screenutil 确保在不同尺寸设备上的一致显示效果。

## API 集成

HttpService 已封装好常用的 HTTP 方法：
- `get()` - GET 请求
- `post()` - POST 请求  
- `put()` - PUT 请求
- `delete()` - DELETE 请求

所有请求都会返回统一的 `ApiResponse<T>` 格式。

## 页面说明

- **MainPage**: 主页面，包含底部导航栏
- **HomePage**: 首页，显示欢迎信息和数据列表
- **RewardPage**: 奖励页面，显示积分和可领取奖励
- **AccountPage**: 账户页面，用户信息和设置入口
- **SettingsPage**: 设置页面，主题和语言切换

## 开发指南

### 添加新页面
1. 在 `lib/pages/` 创建页面文件
2. 在 `lib/controllers/` 创建对应控制器
3. 在 `lib/routes/` 添加路由配置

### 添加新的国际化文本
1. 更新 `lib/l10n/app_en.arb` 和 `lib/l10n/app_zh.arb`
2. 运行 `flutter gen-l10n` 重新生成

### 网络请求
在控制器中注入 HttpService 并直接调用相应方法即可。

## 注意事项

- 确保在 `HttpService` 中配置正确的 API 基础地址
- 所有网络请求都有统一的错误处理
- 主题和语言设置会自动保存到本地存储