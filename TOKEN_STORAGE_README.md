# Token本地缓存功能说明

## 功能概述
实现了完整的token本地缓存机制，包括：
- Token自动保存到本地存储
- 应用启动时自动恢复登录状态  
- Token过期检测和清理
- HTTP请求自动携带token
- 登录后跳转到首页

## 主要文件

### StorageManager (`/lib/utils/storage_manager.dart`)
统一的存储管理类，提供：
- `saveToken(String token)` - 保存token
- `getToken()` - 获取token
- `hasToken()` - 检查token是否存在
- `saveUserInfo(Map userInfo)` - 保存用户信息
- `getUserInfo()` - 获取用户信息
- `isTokenExpired()` - 检查token是否过期（默认7天）
- `clearLoginData()` - 清除登录相关数据

### AuthController (已更新)
- 登录成功后自动保存token和用户信息
- 应用启动时从本地存储恢复登录状态
- 退出登录时清除本地数据
- Token过期自动清理

### RequestInterceptor (已更新)
- 自动从本地存储获取token
- 为每个HTTP请求自动添加 `Authorization: Bearer {token}` 头

## 功能流程

### 1. 登录流程
1. 用户输入账号密码和验证码
2. 调用登录API
3. 登录成功后：
   - 保存token到本地存储
   - 保存用户信息到本地存储
   - 设置登录状态为true
   - 跳转到首页

### 2. 应用启动流程
1. 初始化存储管理器
2. AuthController检查本地存储
3. 如果有有效token：
   - 恢复用户信息和登录状态
   - 设置HTTP服务的认证token
4. 如果token过期：
   - 清除本地数据

### 3. HTTP请求流程
1. RequestInterceptor自动获取token
2. 为请求添加Authorization头
3. 发送请求

### 4. 退出登录流程
1. 清除内存中的用户数据
2. 清除本地存储的数据
3. 移除HTTP服务的认证token

## Token存储结构
```json
{
  "user_token": "your_jwt_token_here",
  "user_info": {
    "account": "apitest",
    "email": "user@example.com",
    "nickname": "用户昵称",
    // ... 其他用户信息
  },
  "login_time": 1640995200000
}
```

## 配置说明

### Token过期时间
默认7天，可在StorageManager.isTokenExpired()中修改：
```dart
bool isTokenExpired({int expireHours = 24 * 7}) // 7天
```

### 存储Key
- `user_token` - 存储token
- `user_info` - 存储用户信息
- `login_time` - 存储登录时间

## 安全特性
- Token存储在设备本地，相对安全
- 支持过期时间检测
- 出错时自动清理数据
- 不在日志中打印敏感信息

## 扩展功能
可以很容易地添加：
- 自动刷新token
- 多账号支持
- 加密存储
- 指纹/面部识别
- 服务端token验证

## 测试
1. 使用默认账号 `apitest/123456` 登录
2. 关闭应用重新打开，应该自动恢复登录状态
3. 可在StorageManager中设置较短的过期时间来测试过期清理功能