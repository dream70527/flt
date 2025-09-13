# Flutter 高级语法详解：Extension、Mixin、With 等

## 目录
1. [Extension（扩展）](#extension扩展)
2. [Mixin（混入）](#mixin混入)
3. [With 关键字](#with-关键字)
4. [实际应用场景](#实际应用场景)
5. [常见面试题](#常见面试题)

---

## Extension（扩展）

### 基础语法
Extension 允许你为现有的类添加新功能，而不修改原始类的代码。

```dart
// 基本语法
extension ExtensionName on ClassName {
  // 添加新方法
  // 添加新 getter/setter
  // 添加新操作符
}
```

### 实际示例

#### 1. 为 String 添加扩展
```dart
extension StringExtension on String {
  // 判断是否为空或null
  bool get isNullOrEmpty => this.isEmpty;
  
  // 首字母大写
  String get capitalize => 
    this.isEmpty ? this : this[0].toUpperCase() + this.substring(1);
  
  // 去除所有空格
  String get removeAllSpaces => this.replaceAll(' ', '');
  
  // 判断是否为有效邮箱
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
  
  // 转换为颜色
  Color get toColor {
    String hex = this.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}

// 使用示例
void main() {
  String name = "john doe";
  print(name.capitalize); // "John doe"
  
  String email = "test@example.com";
  print(email.isValidEmail); // true
  
  String colorHex = "#FF5733";
  Color color = colorHex.toColor;
}
```

#### 2. 为 int 添加扩展
```dart
extension IntExtension on int {
  // 转换为时长格式
  String get toDuration {
    int hours = this ~/ 3600;
    int minutes = (this % 3600) ~/ 60;
    int seconds = this % 60;
    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}';
  }
  
  // 判断是否为偶数
  bool get isEven => this % 2 == 0;
  
  // 转换为文件大小
  String get toFileSize {
    if (this < 1024) return '${this}B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(1)}KB';
    if (this < 1024 * 1024 * 1024) return '${(this / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}

// 使用示例
void main() {
  int seconds = 3661;
  print(seconds.toDuration); // "01:01:01"
  
  int fileSize = 1048576;
  print(fileSize.toFileSize); // "1.0MB"
}
```

#### 3. 为 Widget 添加扩展
```dart
extension WidgetExtension on Widget {
  // 添加点击事件
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
  
  // 添加边距
  Widget padding(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
  
  // 添加居中
  Widget get center => Center(child: this);
  
  // 添加卡片样式
  Widget get card => Card(child: this);
  
  // 添加圆角
  Widget borderRadius(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }
  
  // 添加阴影
  Widget shadow({
    Color color = Colors.grey,
    double blurRadius = 5.0,
    Offset offset = const Offset(0, 2),
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blurRadius,
            offset: offset,
          ),
        ],
      ),
      child: this,
    );
  }
}

// 使用示例
Widget build(BuildContext context) {
  return Text('Hello World')
    .padding(EdgeInsets.all(16))
    .onTap(() => print('Tapped!'))
    .card
    .center;
}
```

---

## Mixin（混入）

### 基础概念
Mixin 是一种在多个类层次结构中重用类代码的方法。它解决了 Dart 单继承的限制。

```dart
// 定义 mixin
mixin MixinName {
  // 属性和方法
}

// 或者带约束的 mixin
mixin MixinName on SuperClass {
  // 只能被 SuperClass 的子类使用
}
```

### 实际示例

#### 1. 基础 Mixin 示例
```dart
// 定义能力相关的 mixin
mixin Flyable {
  void fly() => print('Flying in the sky!');
  double get flySpeed => 100.0;
}

mixin Swimmable {
  void swim() => print('Swimming in water!');
  double get swimSpeed => 50.0;
}

mixin Walkable {
  void walk() => print('Walking on ground!');
  double get walkSpeed => 10.0;
}

// 使用 mixin
class Bird with Flyable, Walkable {
  String name;
  Bird(this.name);
  
  void introduce() {
    print('I am $name');
  }
}

class Fish with Swimmable {
  String species;
  Fish(this.species);
}

class Duck with Flyable, Swimmable, Walkable {
  String name;
  Duck(this.name);
  
  // 可以覆盖 mixin 的方法
  @override
  void fly() {
    print('$name is flying like a duck!');
  }
}

// 使用示例
void main() {
  var bird = Bird('Eagle');
  bird.introduce(); // "I am Eagle"
  bird.fly();       // "Flying in the sky!"
  bird.walk();      // "Walking on ground!"
  
  var duck = Duck('Donald');
  duck.fly();   // "Donald is flying like a duck!"
  duck.swim();  // "Swimming in water!"
  duck.walk();  // "Walking on ground!"
}
```

#### 2. Flutter 中的实际应用
```dart
// 状态管理相关 mixin
mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;
  
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }
  
  Widget buildWithLoading(Widget child) {
    return Stack(
      children: [
        child,
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

// 网络请求相关 mixin
mixin NetworkMixin {
  Future<T?> handleNetworkCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      print('Network error: $e');
      return null;
    }
  }
}

// 使用示例
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> 
    with LoadingStateMixin, NetworkMixin {
  
  String data = '';
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setLoading(true);
    
    final result = await handleNetworkCall(() async {
      // 模拟网络请求
      await Future.delayed(Duration(seconds: 2));
      return 'Data loaded successfully';
    });
    
    if (result != null) {
      data = result;
    }
    
    setLoading(false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mixin Demo')),
      body: buildWithLoading(
        Center(
          child: Text(data.isEmpty ? 'No data' : data),
        ),
      ),
    );
  }
}
```

#### 3. 带约束的 Mixin
```dart
// 只能被 StatefulWidget 的 State 使用的 mixin
mixin LifecycleMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    onInitState();
  }
  
  @override
  void dispose() {
    onDispose();
    super.dispose();
  }
  
  // 子类需要实现的方法
  void onInitState();
  void onDispose();
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with LifecycleMixin {
  @override
  void onInitState() {
    print('Widget initialized');
  }
  
  @override
  void onDispose() {
    print('Widget disposed');
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

---

## With 关键字

### 基础用法
`with` 关键字用于将 mixin 应用到类中。

```dart
// 单个 mixin
class MyClass with MixinA {
  // class body
}

// 多个 mixin（顺序很重要）
class MyClass with MixinA, MixinB, MixinC {
  // class body
}

// 继承 + mixin
class MyClass extends SuperClass with MixinA, MixinB {
  // class body
}

// 实现接口 + mixin
class MyClass with MixinA implements InterfaceA {
  // class body
}
```

### Mixin 的线性化（Linearization）
当使用多个 mixin 时，Dart 遵循线性化原则：

```dart
mixin A {
  void method() => print('A');
}

mixin B {
  void method() => print('B');
}

mixin C {
  void method() => print('C');
}

class MyClass with A, B, C {
  // 最右边的 mixin (C) 具有最高优先级
}

void main() {
  MyClass().method(); // 输出: "C"
}
```

### super 在 mixin 中的使用
```dart
mixin A {
  void method() {
    print('A');
    super.method(); // 调用下一个 mixin 或父类的方法
  }
}

mixin B {
  void method() {
    print('B');
    super.method();
  }
}

class Base {
  void method() => print('Base');
}

class MyClass extends Base with A, B {
  @override
  void method() {
    print('MyClass');
    super.method(); // 调用 B.method()
  }
}

void main() {
  MyClass().method();
  // 输出:
  // MyClass
  // B
  // A
  // Base
}
```

---

## 实际应用场景

### 1. GetX Controller Mixin
```dart
mixin LoadingMixin on GetxController {
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  
  void setLoading(bool loading) => _isLoading.value = loading;
  
  Future<T?> executeWithLoading<T>(Future<T> Function() task) async {
    try {
      setLoading(true);
      return await task();
    } finally {
      setLoading(false);
    }
  }
}

class UserController extends GetxController with LoadingMixin {
  final users = <User>[].obs;
  
  Future<void> loadUsers() async {
    await executeWithLoading(() async {
      final result = await userService.getUsers();
      users.assignAll(result);
    });
  }
}
```

### 2. 验证 Mixin
```dart
mixin ValidationMixin {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '邮箱不能为空';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }
  
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '密码不能为空';
    }
    if (value.length < 6) {
      return '密码至少需要6位';
    }
    return null;
  }
  
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '手机号不能为空';
    }
    if (!RegExp(r'^1[3456789]\d{9}$').hasMatch(value)) {
      return '请输入有效的手机号';
    }
    return null;
  }
}

class LoginController extends GetxController with ValidationMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  String? get emailError => validateEmail(emailController.text);
  String? get passwordError => validatePassword(passwordController.text);
  
  bool get isFormValid => 
    emailError == null && passwordError == null;
}
```

### 3. 权限管理 Mixin
```dart
mixin PermissionMixin {
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }
    
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    
    return false;
  }
  
  Future<bool> requestCameraPermission() => 
    requestPermission(Permission.camera);
    
  Future<bool> requestStoragePermission() => 
    requestPermission(Permission.storage);
    
  Future<bool> requestLocationPermission() => 
    requestPermission(Permission.location);
}
```

---

## 常见面试题

### 1. Extension 相关面试题

**Q1: Extension 和继承有什么区别？**

A: 
- Extension 不创建新的类型，只是添加功能
- Extension 不能添加实例变量，只能添加计算属性
- Extension 不能被覆盖（override）
- Extension 在编译时解析，而继承在运行时

```dart
// Extension 示例
extension StringExt on String {
  // 只能添加计算属性，不能添加实例变量
  String get reversed => split('').reversed.join();
}

// 继承示例
class MyString extends String {
  // 错误：不能继承 String（sealed class）
}
```

**Q2: Extension 的作用域规则是什么？**

A: Extension 需要被导入才能使用，可以通过 `show` 和 `hide` 控制可见性：

```dart
// 导入时控制
import 'extensions.dart' show StringExtension;
import 'extensions.dart' hide IntExtension;

// 冲突时的解决方案
extension StringExt1 on String {
  String get process => 'ext1: $this';
}

extension StringExt2 on String {
  String get process => 'ext2: $this';
}

// 使用时需要显式指定
void main() {
  String str = 'hello';
  print(StringExt1(str).process); // "ext1: hello"
  print(StringExt2(str).process); // "ext2: hello"
}
```

### 2. Mixin 相关面试题

**Q3: Mixin 和多重继承有什么区别？**

A:
- Dart 不支持多重继承，但支持 Mixin
- Mixin 遵循线性化顺序，避免了菱形继承问题
- Mixin 不能有构造函数
- Mixin 可以有 on 约束

```dart
// 错误：Dart 不支持多重继承
class Child extends Parent1, Parent2 {} // 编译错误

// 正确：使用 Mixin
class Child extends Parent with Mixin1, Mixin2 {}
```

**Q4: 解释 Mixin 的线性化过程**

A: 当类使用多个 Mixin 时，Dart 创建一个线性化的继承链：

```dart
class A {}
mixin M1 on A {}
mixin M2 on A {}
class B extends A with M1, M2 {}

// 线性化结果：B -> M2 -> M1 -> A -> Object
// 方法解析顺序：B.method() -> M2.method() -> M1.method() -> A.method()
```

**Q5: 什么时候使用 `on` 约束？**

A: 当 Mixin 需要使用特定类型的方法或属性时：

```dart
mixin TimestampMixin on StatefulWidget {
  // 可以安全地使用 StatefulWidget 的方法
  DateTime get createdAt => DateTime.now();
  
  void logCreation() {
    print('Widget ${runtimeType} created at $createdAt');
  }
}

// 只能在 StatefulWidget 子类中使用
class MyWidget extends StatefulWidget with TimestampMixin {
  // ...
}
```

### 3. With 关键字相关面试题

**Q6: `with` 关键字的使用顺序重要吗？**

A: 非常重要！顺序决定了方法解析的优先级：

```dart
mixin A {
  void method() => print('A');
}

mixin B {
  void method() => print('B');
}

class Test1 with A, B {} // B 优先
class Test2 with B, A {} // A 优先

void main() {
  Test1().method(); // 输出 "B"
  Test2().method(); // 输出 "A"
}
```

**Q7: 能否在 Mixin 中调用 super？**

A: 可以，super 会调用 Mixin 链中的下一个：

```dart
mixin A {
  void method() {
    print('A start');
    super.method();
    print('A end');
  }
}

mixin B {
  void method() {
    print('B start');
    super.method();
    print('B end');
  }
}

class Base {
  void method() => print('Base');
}

class Child extends Base with A, B {
  @override
  void method() {
    print('Child start');
    super.method(); // 调用 B.method()
    print('Child end');
  }
}

// 输出顺序：
// Child start
// B start  
// A start
// Base
// A end
// B end
// Child end
```

### 4. 综合面试题

**Q8: 比较 Extension、Mixin、继承的使用场景**

A:

| 特性 | Extension | Mixin | 继承 |
|------|-----------|-------|------|
| 用途 | 为现有类添加功能 | 代码复用，横切关注点 | 建立 is-a 关系 |
| 实例变量 | ❌ | ✅ | ✅ |
| 构造函数 | ❌ | ❌ | ✅ |
| 多个使用 | ✅ | ✅ | ❌ |
| 覆盖 | ❌ | ✅ | ✅ |
| 类型关系 | ❌ | ✅ | ✅ |

**Q9: 实现一个带缓存功能的 Repository 模式**

```dart
mixin CacheMixin<T> {
  final Map<String, T> _cache = {};
  Duration get cacheDuration => Duration(minutes: 5);
  final Map<String, DateTime> _timestamps = {};
  
  T? getCached(String key) {
    final timestamp = _timestamps[key];
    if (timestamp != null && 
        DateTime.now().difference(timestamp) < cacheDuration) {
      return _cache[key];
    }
    return null;
  }
  
  void setCache(String key, T value) {
    _cache[key] = value;
    _timestamps[key] = DateTime.now();
  }
  
  void clearCache([String? key]) {
    if (key != null) {
      _cache.remove(key);
      _timestamps.remove(key);
    } else {
      _cache.clear();
      _timestamps.clear();
    }
  }
}

mixin NetworkMixin {
  Future<T> get<T>(String url, T Function(Map<String, dynamic>) parser) async {
    // 网络请求实现
    await Future.delayed(Duration(seconds: 1)); // 模拟网络延迟
    return parser({'data': 'mock data'});
  }
}

class UserRepository with CacheMixin<List<User>>, NetworkMixin {
  Future<List<User>> getUsers() async {
    const key = 'users';
    
    // 检查缓存
    final cached = getCached(key);
    if (cached != null) {
      return cached;
    }
    
    // 网络请求
    final users = await get<List<User>>(
      '/api/users',
      (json) => (json['users'] as List)
          .map((u) => User.fromJson(u))
          .toList(),
    );
    
    // 缓存结果
    setCache(key, users);
    return users;
  }
}
```

**Q10: 解释以下代码的输出顺序**

```dart
class Base {
  void method() => print('Base');
}

mixin A on Base {
  @override
  void method() {
    print('A before');
    super.method();
    print('A after');
  }
}

mixin B on Base {
  @override
  void method() {
    print('B before');
    super.method();  
    print('B after');
  }
}

class Child extends Base with A, B {
  @override
  void method() {
    print('Child before');
    super.method();
    print('Child after');
  }
}

void main() {
  Child().method();
}
```

**答案：**
```
Child before
B before
A before  
Base
A after
B after
Child after
```

**解析：** 
1. 线性化顺序：Child -> B -> A -> Base
2. 每个 `super.method()` 调用链中的下一个
3. 方法执行完毕后返回到调用点继续执行

---

## 总结

- **Extension**: 为现有类型添加功能，不改变类型关系
- **Mixin**: 实现代码复用，解决单继承限制  
- **With**: 应用 Mixin 的关键字，顺序很重要
- **应用场景**: 状态管理、验证、网络请求、权限管理等横切关注点
- **面试重点**: 理解线性化、super 调用链、使用场景区别

掌握这些概念对于编写高质量的 Flutter/Dart 代码非常重要！