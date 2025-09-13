import 'package:flutter/material.dart';

/// 应用颜色配置
class AppColors {
  // 主色调
  static const Color primary = Color(0xFF6366F1); // 紫蓝色
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4338CA);
  
  // 辅助色
  static const Color secondary = Color(0xFF10B981); // 绿色
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF047857);
  
  // 强调色
  static const Color accent = Color(0xFFEF4444); // 红色
  static const Color accentLight = Color(0xFFF87171);
  static const Color accentDark = Color(0xFFDC2626);
  
  // 中性色
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral900 = Color(0xFF171717);
  
  // 功能色
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // 背景色
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF1F2937);
  static const Color surface = Color(0xFFF9FAFB);
  static const Color surfaceDark = Color(0xFF374151);
  
  // Web3/币安风格颜色
  static const Color binanceYellow = Color(0xFFF0B90B);
  static const Color cryptoGreen = Color(0xFF0ECB81);
  static const Color cryptoRed = Color(0xFFF6465D);
  
  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cryptoGradient = LinearGradient(
    colors: [binanceYellow, cryptoGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// 扩展 BuildContext 以便快速访问主题颜色
extension ThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  
  // 快速访问自定义颜色
  Color get appPrimary => AppColors.primary;
  Color get appSecondary => AppColors.secondary;
  Color get appAccent => AppColors.accent;
  Color get appSuccess => AppColors.success;
  Color get appWarning => AppColors.warning;
  Color get appError => AppColors.error;
  Color get appInfo => AppColors.info;
}

/// 主题相关的工具方法
class ThemeUtils {
  /// 根据背景色自动选择文字颜色
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
  
  /// 获取颜色的半透明版本
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  /// 获取颜色的深色版本
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
  
  /// 获取颜色的浅色版本
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}