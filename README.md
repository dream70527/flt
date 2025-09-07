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

## APK 打包步骤

### 环境要求
- Flutter SDK (当前版本 3.32.1)
- Android Studio 或 Android SDK
- Java Development Kit (JDK)

### 遇到的问题及解决方案

#### 1. Android SDK 配置问题
当前项目在打包时遇到以下问题：
- **cmdline-tools 组件缺失**
- **Android 许可证状态未知**
- **Gradle 下载超时或文件损坏**

#### 2. 解决步骤

##### 步骤 1: 安装 Android SDK 命令行工具
```bash
# 方法一：通过 Android Studio 安装
# 1. 打开 Android Studio
# 2. 进入 Preferences -> Appearance & Behavior -> System Settings -> Android SDK
# 3. 选择 "SDK Tools" 标签
# 4. 勾选 "Android SDK Command-line Tools (latest)"
# 5. 点击 Apply 安装

# 方法二：手动下载安装
# 从 https://developer.android.com/studio#command-line-tools-only 下载
# 解压到 $ANDROID_HOME/cmdline-tools/latest/
```

##### 步骤 2: 设置环境变量
```bash
# 在 ~/.zshrc 或 ~/.bash_profile 中添加：
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

  1. 安装 Android SDK Command-line Tools：
    - 打开 Android Studio
    - 进入 SDK Manager
    - 安装 "Android SDK Command-line Tools (latest)"
  2. 接受许可证：
  flutter doctor --android-licenses

```

##### 步骤 3: 接受 Android 许可证
```bash
flutter doctor --android-licenses
# 输入 'y' 接受所有许可证
```

##### 步骤 4: 清理并重新构建
```bash
# 清理项目缓存
flutter clean
rm -rf ~/.gradle  # 清理 Gradle 缓存（如果有问题）

# 获取依赖
flutter pub get

# 检查环境
flutter doctor
```

##### 步骤 5: 构建 APK
```bash
# 构建 release 版本 APK
flutter build apk --release

# 或者构建分架构的 APK（减小文件大小）
flutter build apk --split-per-abi

# 或者构建 debug 版本用于测试
flutter build apk --debug
```

### APK 输出位置
构建成功后，APK 文件将位于：
```
build/app/outputs/flutter-apk/
├── app-release.apk              # 通用版本
├── app-arm64-v8a-release.apk    # ARM64 版本
├── app-armeabi-v7a-release.apk  # ARM32 版本
└── app-x86_64-release.apk       # x86_64 版本
```

### 常见问题排除

#### Gradle 下载超时
```bash
# 删除损坏的 Gradle 缓存
rm -rf ~/.gradle/wrapper/dists/gradle-*

rm -rf ~/.gradle/wrapper/dists
flutter clean
flutter pub get

# 或者完全重置 Gradle
rm -rf ~/.gradle
```

#### 网络问题
如果在国内网络环境下构建缓慢，可以配置镜像：

在 `android/build.gradle` 中添加：
```gradle
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/central' }
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
        google()
        mavenCentral()
    }
}
```

### 构建说明
1. 首次构建可能需要较长时间下载依赖
2. 确保网络连接稳定
3. 如果使用的是 M1/M2 Mac，可能需要额外配置
4. 构建前建议运行 `flutter doctor` 确保环境正常

### 下一步
完成环境配置后，重新运行构建命令即可成功生成 APK 文件。

## iOS 目录结构说明

Flutter 项目中的 `ios/` 目录包含了所有 iOS 平台相关的配置和代码文件：

### 📁 主要目录结构
```
ios/
├── Flutter/                # Flutter 相关配置
│   └── AppFrameworkInfo.plist
├── Runner/                 # iOS 应用主模块
│   ├── AppDelegate.swift   # 应用启动入口
│   ├── Info.plist         # 应用配置信息
│   ├── Assets.xcassets/   # 图标和启动图资源
│   ├── Base.lproj/        # 本地化文件
│   └── Generated*.{h,m}   # 自动生成的插件文件
├── Runner.xcodeproj/      # Xcode 项目文件
├── Runner.xcworkspace/    # Xcode 工作空间
├── RunnerTests/           # 单元测试文件
└── Podfile               # CocoaPods 依赖管理
```

### 📄 核心文件说明

#### 配置文件
- **Info.plist** - iOS 应用信息配置文件
  - 应用名称、版本号、Bundle ID
  - 权限配置（相机、位置、网络等）
  - 支持的设备方向和 iOS 版本
  - URL Schemes 和深度链接配置

- **Podfile** - CocoaPods 依赖管理
  - 管理 iOS 原生依赖库
  - 设置最低 iOS 版本支持
  - 配置 Flutter 框架集成

#### 应用入口
- **AppDelegate.swift** - iOS 应用启动委托
  - 应用生命周期管理
  - Flutter 引擎初始化
  - 处理应用启动、后台、恢复等状态
  - 原生功能集成入口点

#### 项目配置
- **Runner.xcodeproj** - Xcode 项目配置
  - 编译设置和构建配置
  - 代码签名和证书配置
  - 目标设备和架构设置

- **Runner.xcworkspace** - Xcode 工作空间
  - 集成 CocoaPods 依赖
  - 管理多个项目和库的关系

#### 资源文件
- **Assets.xcassets** - 应用图标和启动图
  - App 图标（不同尺寸）
  - 启动屏幕图片
  - 其他应用内图标资源

- **Base.lproj** - 国际化和本地化
  - LaunchScreen.storyboard（启动屏幕）
  - 多语言支持文件

#### 自动生成文件
- **GeneratedPluginRegistrant.{h,m}** - 插件注册文件
  - 自动生成，用于注册 Flutter 插件
  - 包含 Objective-C 头文件和实现文件
  - 请勿手动修改

- **Runner-Bridging-Header.h** - Swift-Objective-C 桥接文件
  - 用于 Swift 和 Objective-C 代码互操作
  - 导入需要在 Swift 中使用的 Objective-C 头文件

### 🔧 常见修改场景

1. **应用信息配置**: 修改 `Info.plist` 中的应用名称、版本等
2. **权限配置**: 在 `Info.plist` 中添加所需权限说明
3. **应用图标**: 替换 `Assets.xcassets` 中的图标文件
4. **启动屏幕**: 修改 `LaunchScreen.storyboard`
5. **原生代码集成**: 在 `AppDelegate.swift` 中添加原生功能
6. **依赖管理**: 修改 `Podfile` 添加原生库依赖
7. **代码签名**: 在 Xcode 项目中配置开发者证书

### 🍎 iOS 特有注意事项
- **开发者账号**: 真机测试和发布需要 Apple 开发者账号
- **代码签名**: 必须配置正确的证书和描述文件
- **App Store 审核**: 发布前需通过 Apple 的审核流程
- **iOS 版本兼容**: 注意设置合适的最低支持 iOS 版本
- **权限申请**: iOS 对权限管理很严格，需要详细说明用途

### 💡 注意事项
- 修改 iOS 配置需要在 macOS 上进行
- Xcode 是必需的开发工具
- 真机调试需要开发者证书
- 不要手动修改自动生成的文件
- Pod 依赖变更后需要运行 `pod install`