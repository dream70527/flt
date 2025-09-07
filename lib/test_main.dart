import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/controllers/theme_controller.dart';
import 'core/controllers/locale_controller.dart';
import 'services/http_service.dart';
import 'utils/storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 初始化本地存储
    await GetStorage.init();
    await StorageManager.init();
    
    await _initServices();
    
    runApp(const TestApp());
  } catch (e) {
    print('Error during initialization: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Initialization Error: $e'),
        ),
      ),
    ));
  }
}

Future<void> _initServices() async {
  Get.put<HttpService>(HttpService(), permanent: true);
  Get.put<ThemeController>(ThemeController(), permanent: true);
  Get.put<LocaleController>(LocaleController(), permanent: true);
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Test App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: const TestPage(),
        );
      },
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'App initialized successfully!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}