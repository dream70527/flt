import 'package:flutter/material.dart';

/// 自定义图标工具类
class CustomIcons {
  /// 使用图片资源创建图标
  static Widget assetIcon(
    String assetPath, {
    double? size,
    Color? color,
  }) {
    return ImageIcon(
      AssetImage(assetPath),
      size: size ?? 24.0,
      color: color,
    );
  }
  
  /// 创建可点击的图标按钮
  static Widget assetIconButton(
    String assetPath, {
    required VoidCallback onPressed,
    double? size,
    Color? color,
    String? tooltip,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: assetIcon(assetPath, size: size, color: color),
      tooltip: tooltip,
    );
  }
  
  /// 使用网络图片创建图标
  static Widget networkIcon(
    String url, {
    double? size,
    Color? color,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return SizedBox(
      width: size ?? 24.0,
      height: size ?? 24.0,
      child: Image.network(
        url,
        width: size ?? 24.0,
        height: size ?? 24.0,
        color: color,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? 
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            );
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? 
            Icon(Icons.error, size: size ?? 24.0, color: color);
        },
      ),
    );
  }
  
  /// 创建SVG图标（需要flutter_svg包）
  static Widget svgIcon(
    String assetPath, {
    double? size,
    Color? color,
  }) {
    // 注意：需要添加 flutter_svg 依赖
    // return SvgPicture.asset(
    //   assetPath,
    //   width: size ?? 24.0,
    //   height: size ?? 24.0,
    //   color: color,
    // );
    
    // 临时使用普通图片
    return assetIcon(assetPath, size: size, color: color);
  }
}

/// 创建自定义IconData的扩展
extension CustomIconData on IconData {
  /// 从Material图标创建自定义图标
  static IconData fromMaterial(int codePoint) {
    return IconData(
      codePoint,
      fontFamily: 'MaterialIcons',
    );
  }
  
  /// 从Cupertino图标创建自定义图标
  static IconData fromCupertino(int codePoint) {
    return IconData(
      codePoint,
      fontFamily: 'CupertinoIcons',
      fontPackage: 'cupertino_icons',
    );
  }
}