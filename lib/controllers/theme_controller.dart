import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum ThemeType { light, dark, system }

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_mode';
  
  final _themeMode = ThemeType.system.obs;
  ThemeType get themeMode => _themeMode.value;
  
  // 定义应用主色调
  static const Color primaryColor = Color(0xFF6366F1); // 紫蓝色
  static const Color secondaryColor = Color(0xFF10B981); // 绿色
  static const Color accentColor = Color(0xFFEF4444); // 红色
  
  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    final storage = GetStorage();
    final themeString = storage.read(_themeKey) ?? 'system';
    _themeMode.value = ThemeType.values.firstWhere(
      (e) => e.name == themeString,
      orElse: () => ThemeType.system,
    );
    _updateTheme();
  }

  void changeTheme(ThemeType themeType) {
    _themeMode.value = themeType;
    GetStorage().write(_themeKey, themeType.name);
    _updateTheme();
  }

  void _updateTheme() {
    switch (_themeMode.value) {
      case ThemeType.light:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case ThemeType.dark:
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case ThemeType.system:
        Get.changeThemeMode(ThemeMode.system);
        break;
    }
  }
}