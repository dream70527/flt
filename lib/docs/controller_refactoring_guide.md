# 控制器模块化拆分指南

当控制器变得过于复杂时，可以通过以下三种方式进行模块化拆分：

## 方案1：按功能拆分为服务类（Service层）

**适用场景**：功能相对独立，可以被多个控制器共享

**结构**：
```
services/auth/
├── auth_state_service.dart      # 认证状态管理
├── captcha_service.dart         # 验证码管理  
├── login_service.dart           # 登录业务逻辑
```

**优点**：
- 服务可以被多个控制器复用
- 职责分离清晰
- 便于单元测试

**缺点**：
- 需要管理服务之间的依赖关系
- 可能增加代码复杂度

**使用示例**：
```dart
// 在控制器中使用
class AuthController extends GetxController {
  late final AuthStateService _authStateService;
  late final CaptchaService _captchaService;
  late final LoginService _loginService;
  
  @override
  void onInit() {
    super.onInit();
    _authStateService = Get.find<AuthStateService>();
    _captchaService = Get.find<CaptchaService>();
    _loginService = Get.find<LoginService>();
  }
}
```

## 方案2：基于继承和Mixin的模块化（推荐）

**适用场景**：功能模块相对固定，需要灵活组合

**结构**：
```
controllers/auth/
├── auth_base_controller.dart    # 基础控制器
├── captcha_mixin.dart          # 验证码功能Mixin
├── login_mixin.dart            # 登录功能Mixin
├── auth_controller_modular.dart # 组合后的控制器
```

**优点**：
- 功能模块化，可按需组合
- 钩子方法支持定制化
- 代码结构清晰
- 易于扩展和维护

**缺点**：
- 需要理解继承和Mixin概念
- 调试时需要跟踪继承链

**使用示例**：
```dart
// 基础控制器定义核心状态
abstract class AuthBaseController extends GetxController {
  final Rxn<UserInfoEntity> userInfo = Rxn<UserInfoEntity>();
  final RxBool isLoggedIn = false.obs;
  
  // 钩子方法供子类重写
  void onLoginSuccess() {}
}

// Mixin定义功能模块
mixin CaptchaMixin on GetxController {
  final Rxn<CaptchaEntity> captcha = Rxn<CaptchaEntity>();
  Future<void> getCaptcha() async { /* 实现 */ }
}

// 组合使用
class AuthController extends AuthBaseController 
    with CaptchaMixin, LoginMixin {
  // 可以重写钩子方法定制行为
}
```

## 方案3：Repository模式

**适用场景**：数据访问逻辑复杂，需要统一管理

**结构**：
```
repositories/
├── auth_repository.dart         # 数据访问层
controllers/
├── auth_controller_repository.dart # 使用Repository的控制器
```

**优点**：
- 数据访问逻辑集中管理
- 便于切换数据源（本地/远程）
- 符合领域驱动设计原则

**缺点**：
- 增加了抽象层级
- 对于简单项目可能过度设计

**使用示例**：
```dart
// Repository管理所有数据访问
class AuthRepository {
  Future<UserInfoEntity?> login({...}) async { /* 实现 */ }
  UserInfoEntity? getUserFromLocal() { /* 实现 */ }
  Future<void> saveUserToLocal(UserInfoEntity user) async { /* 实现 */ }
}

// 控制器使用Repository
class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  
  Future<bool> login({...}) async {
    final result = await _authRepository.login(...);
    if (result != null) {
      await _authRepository.saveUserToLocal(result);
    }
  }
}
```

## 选择指南

1. **小型项目**：直接使用原始控制器
2. **中型项目**：推荐方案2（Mixin模块化）
3. **大型项目**：方案1（Service层）+ 方案3（Repository）
4. **团队协作**：根据团队熟悉度选择

## 实施步骤

1. **识别功能模块**：将控制器按功能划分（如：状态管理、业务逻辑、数据访问）
2. **选择拆分方案**：根据项目规模和团队情况选择
3. **逐步重构**：不要一次性重构所有代码，可以逐个功能模块进行
4. **保持接口一致**：确保重构后的接口与原控制器保持一致
5. **添加测试**：为拆分后的模块添加单元测试

## 注意事项

- 不要过度拆分，保持合理的粒度
- 确保模块之间的依赖关系清晰
- 考虑性能影响，避免过度抽象
- 保持代码的可读性和可维护性