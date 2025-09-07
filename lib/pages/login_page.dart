import 'dart:convert';
import 'package:claudecodeflt/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/widget_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _accountController = TextEditingController(text: 'apitest');
  final TextEditingController _passwordController = TextEditingController(text: '123456');
  final TextEditingController _captchaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 页面加载时获取验证码
    _authController.getCaptcha();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo或标题
            Icon(
              Icons.account_circle,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 30),
            
            // 账号输入框
            TextField(
              controller: _accountController,
              decoration: InputDecoration(
                labelText: '账号',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            
            // 密码输入框
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '密码',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            
            // 验证码输入框和图片
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _captchaController,
                    decoration: InputDecoration(
                      labelText: '验证码',
                      prefixIcon: Icon(Icons.verified),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // 验证码图片
                Obx(() => InkWell(
                  onTap: _authController.getCaptcha,
                  child: Container(
                    width: 120,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _authController.isCaptchaLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : _authController.captcha.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child:
                              WidgetUtils.base64ImageWidget(
                                baseUrl: _authController.captcha.value!.img,
                                 fit:BoxFit.contain
                              )
                              )
                            : Center(
                                child: Text(
                                  '点击获取',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                  ),
                )),
              ],
            ),
            SizedBox(height: 30),
            
            // 登录按钮
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _authController.isLoading.value ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _authController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('登录', style: TextStyle(fontSize: 18)),
              ),
            )),
            
            SizedBox(height: 20),
            
            // 提示信息
            Text(
              '默认账号：apitest\n默认密码：123456',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    if (_captchaController.text.trim().isEmpty) {
      Get.snackbar('错误', '请输入验证码');
      return;
    }

    final success = await _authController.login(
      account: _accountController.text.trim(),
      password: _passwordController.text.trim(),
      captchaCode: _captchaController.text.trim(),
    );

    if (!success) {
      // 登录失败，清空验证码输入框
      _captchaController.clear();
    }else{
      Get.offAllNamed(Routes.home);
    }
  }
}