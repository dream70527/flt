# 登录功能使用说明

## 功能概述
实现了完整的登录功能，包括：
- 图形验证码获取
- 用户登录认证
- 登录状态管理
- 自动跳转功能

## 文件结构
```
lib/
├── models/
│   ├── user_info_entity.dart    # 用户信息实体
│   └── captcha_entity.dart      # 验证码实体
├── services/
│   └── auth_api_service.dart    # 认证API服务
├── controllers/
│   └── auth_controller.dart     # 认证控制器
├── pages/
│   ├── login_page.dart          # 登录页面
│   └── account_page.dart        # 账户页面（已更新）
├── bindings/
│   └── auth_binding.dart        # 认证绑定
└── routes/
    ├── routes.dart              # 路由常量
    └── app_pages.dart           # 路由页面配置
```

## API接口
- **获取验证码**: `GET /get-captcha/base64`
  - 返回: `{key: '', img: ''}` (img为base64格式)
- **用户登录**: `POST /login`
  - 参数: `{account, login_password, key, captcha}`
  - 返回: 用户信息对象

## 使用流程

### 1. 点击账户页面
- 未登录：显示登录提示界面，点击"立即登录"跳转登录页
- 已登录：显示用户信息和功能菜单

### 2. 登录页面
- 默认账号：`apitest`
- 默认密码：`123456`
- 自动获取验证码（点击验证码图片可刷新）
- 输入验证码后点击登录

### 3. 登录成功
- 保存用户信息到内存
- 自动返回账户页面
- 显示用户信息

## 主要组件

### AuthController
- 管理登录状态 (`isLoggedIn`)
- 处理验证码获取 (`getCaptcha()`)
- 处理用户登录 (`login()`)
- 处理退出登录 (`logout()`)

### AccountController
- 集成AuthController
- 监听登录状态变化
- 处理用户信息显示

### LoginPage
- 响应式UI设计
- 验证码图片显示
- 表单验证
- 加载状态显示

## 扩展功能
可以很容易地添加以下功能：
- 记住密码
- 本地存储token
- 自动登录
- 注册功能
- 找回密码
- 第三方登录

## 测试
使用默认账号密码 `apitest/123456` 进行测试。